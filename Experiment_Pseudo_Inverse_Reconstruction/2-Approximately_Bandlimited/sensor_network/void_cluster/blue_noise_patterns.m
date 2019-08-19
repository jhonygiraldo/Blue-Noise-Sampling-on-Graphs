clear all, close all, clc;
%%
N = 1000;   % Number of nodes
G = gsp_sensor(N);
weights = zeros(N,N);
%% Euclidean distances, this step is not required in logical graphs.
for i=1:N
    conexions = find(G.W(i,:) > 0);
    for j=1:length(conexions)
        weights(i,conexions(j)) = norm(G.coords(i,:)-G.coords(conexions(j),:));
    end
end
G.W = weights;
D = diag(sum(G.W'));
L = D-G.W;
%% Eigendecomposition
G = gsp_compute_fourier_basis(G);
save('../sensor_graph.mat','G');
%%
disp('Computing the shortest path matrix and geodesic distances');
geodesic_distances = distances(graph(G.W));
%%
vec_matrix_paths = reshape(geodesic_distances,[G.N*G.N,1]);
stand_dev = (mean(vec_matrix_paths)/32);
%%
exp_geodesic_distances = zeros(G.N,G.N);
for i=1:G.N
    for j=1:G.N
        exp_geodesic_distances(i,j) = exp(-(geodesic_distances(i,j)^2)/(2*stand_dev^2));
    end
end
m = [20:20:200];
void_cluster_pattern = {};
for b=1:length(m)
    b
    repetitions = 100;
    void_cluster_pattern_temp = zeros(repetitions,G.N);
    parfor(h=1:repetitions)
        %%
        amount_nodes = m(b); % Amount of nodes
        initial_binary_pattern = zeros(G.N,1);
        initial_binary_pattern(randperm(G.N,amount_nodes),1) = 1;
        old_index_most_cluster = 1;
        old_index_most_void = 1;
        index_most_cluster = 0;
        index_most_void = 0;
        while((index_most_cluster ~= old_index_most_void) || (index_most_void ~= old_index_most_cluster))
            old_index_most_cluster = index_most_cluster;
            old_index_most_void = index_most_void;
            %%
            index_initial_binary_pattern = find(initial_binary_pattern == 1);
            if(length(index_initial_binary_pattern) == 1)
                void_cluster_array = exp_geodesic_distances(:,index_initial_binary_pattern)';
            else
                void_cluster_array = sum(exp_geodesic_distances(:,index_initial_binary_pattern)');
            end
            %%
            indixes_cluster = find(initial_binary_pattern == 1);
            indixes_void = find(initial_binary_pattern == 0);
            %%
            index_most_cluster = find(void_cluster_array == max(void_cluster_array(indixes_cluster)));
            index_most_cluster = index_most_cluster(1);
            %%
            index_most_void = find(void_cluster_array == min(void_cluster_array(indixes_void)));
            index_most_void = index_most_void(1);
            %%
            initial_binary_pattern(index_most_cluster) = 0;
            initial_binary_pattern(index_most_void) = 1;
            %%
        end
        void_cluster_pattern_temp(h,:) = initial_binary_pattern;
    end
    %%
    void_cluster_pattern{b} = void_cluster_pattern_temp;
end
save(['void_cluster_pattern.mat'],'void_cluster_pattern');