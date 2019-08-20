clear all, close all, clc;
%%
G = gsp_sensor(1000);
weights = zeros(G.N,G.N);
for i=1:G.N
    conexions = find(G.W(i,:) > 0);
    for j=1:length(conexions)
        weights(i,conexions(j)) = norm(G.coords(i,:)-G.coords(conexions(j),:));
    end
end
G.W = weights;
%%
D = diag(sum(G.W'));
G.L = D-G.W;
%%
G = gsp_compute_fourier_basis(G);
save('sensor_graph.mat','G');
%%
percentage_sampled_nodes = [0.01 0.05 0.1 0.15];
%%
disp('Computing the shortest path matrix and geodesic distances');
geodesic_distances = distances(graph(G.W));
save('geodesic_distances_sensor.mat','geodesic_distances');
%%
vectorized_geodesic = reshape(geodesic_distances,[G.N*G.N,1]);
stand_dev = mean(vectorized_geodesic)/32;
%%
exp_geodesic_distances = zeros(G.N,G.N);
for i=1:G.N
    for j=1:G.N
        exp_geodesic_distances(i,j) = exp(-(geodesic_distances(i,j)^2)/(2*stand_dev^2));
    end
end
for b=1:length(percentage_sampled_nodes)
    b
    repetitions = 100;
    void_cluster_pattern = zeros(repetitions,G.N);
    parfor(h=1:repetitions)
        %%
        amount_nodes = round(G.N*percentage_sampled_nodes(b));
        %% Initial random pattern
        initial_binary_pattern = zeros(G.N,1);
        initial_binary_pattern(randperm(G.N,amount_nodes),1) = 1;
        %% Void and cluster iterations
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
        void_cluster_pattern(h,:) = initial_binary_pattern;
    end
    %%
    save(['void_cluster_pattern_',num2str(percentage_sampled_nodes(b)),'.mat'],'void_cluster_pattern');
end