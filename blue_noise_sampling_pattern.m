function bn_pattern = blue_noise_sampling_pattern(G,geodesic_distances,amount_nodes,is_logical,iterations)
% Author: Jhony G. Giraldo, Alejandro Parada-Mayorga.
% This function computes the blue noise sampling set of a given graph G.

%%%
% Parameter Description
% 
% Input
% G: graph structure, same structure as GSP toolbox,
% geodesic_distances: matrix of all geodesic distances
% amount_nodes: amount of sampled nodes
% is_logical: 1 if G is a logical graph, 0 otherwise
% iterations: maximun number of iterations
% 
% Output
% bn_pattern: blue noise sampling pattern
% 
%%%
% If you use this function please kindly cite
%     Alejandro Parada-Mayorga, Daniel L Lau, Jhony H Giraldo, 
%     Gonzalo R Arce. (2019). "Blue-Noise Sampling on Graphs", 
%     IEEE Transactions on Signal and Information Processing over Networks,
%     5(3), 554-569.
% https://www.doi.org/10.1109/TSIPN.2019.2922852

% Author: Jhony G. Giraldo, Alejandro Parada-Mayorga.
% Date: August 2019

vectorized_geodesic = reshape(geodesic_distances,[G.N*G.N,1]);
%% Standar deviation parameter
if(is_logical)
    stand_dev = max(vectorized_geodesic)*mean(vectorized_geodesic)/32;
else
    stand_dev = mean(vectorized_geodesic)/32;
end
exp_geodesic_distances = zeros(G.N,G.N);
%% Gaussian kernel
for l=1:G.N
    for m=1:G.N
        exp_geodesic_distances(l,m) = exp(-(geodesic_distances(l,m)^2)/(2*stand_dev^2));
    end
end
%% Initial random pattern
initial_binary_pattern = zeros(G.N,1);
initial_binary_pattern(randperm(G.N,amount_nodes),1) = 1;
%% Void and cluster iterations
old_index_most_cluster = 1;
old_index_most_void = 1;
index_most_cluster = 0;
index_most_void = 0;
cont_iter = 1;
while((index_most_cluster ~= old_index_most_void) || (index_most_void ~= old_index_most_cluster) || cont_iter > iterations)
    old_index_most_cluster = index_most_cluster;
    old_index_most_void = index_most_void;
    %% Kernel evaluation
    index_initial_binary_pattern = find(initial_binary_pattern == 1);
    if(length(index_initial_binary_pattern) == 1)
        void_cluster_array = exp_geodesic_distances(:,index_initial_binary_pattern)';
    else
        void_cluster_array = sum(exp_geodesic_distances(:,index_initial_binary_pattern)');
    end
    %% Void and cluster indixes
    indixes_cluster = find(initial_binary_pattern == 1);
    indixes_void = find(initial_binary_pattern == 0);
    index_most_cluster = find(void_cluster_array == max(void_cluster_array(indixes_cluster)));
    index_most_cluster = index_most_cluster(1);
    %% Swap of sampled nodes
    index_most_void = find(void_cluster_array == min(void_cluster_array(indixes_void)));
    index_most_void = index_most_void(1);
    initial_binary_pattern(index_most_cluster) = 0;
    initial_binary_pattern(index_most_void) = 1;
    %% Iterations
    cont_iter = cont_iter + 1;
end
bn_pattern = initial_binary_pattern;    % Blue noise sampling pattern.