clear all, close all, clc;
mkdir('results/');
load('sensor_graph.mat');
load('geodesic_distances_sensor.mat');
%%
densities = [0.01 0.05 0.1 0.15];
%%
power_spectrum = zeros(length(densities),G.N-1);
for h=1:length(densities)
    load(['void_cluster_pattern_',num2str(densities(h)),'.mat']);
    s = void_cluster_pattern;
    %%
    q = size(void_cluster_pattern,1);
    s_hat = G.U'*s';
    s_hat = s_hat';
    for l=2:G.N
        for i=1:q
            power_spectrum(h,l-1) = power_spectrum(h,l-1) + s_hat(i,l)^2/((norm(s_hat(i,:)))^2);
        end
        power_spectrum(h,l-1) = (G.N/q)*(power_spectrum(h,l-1));
    end
end
%%
vectorized_geodesic_distances = reshape(geodesic_distances,[G.N*G.N,1]);
radial_distance = linspace(0,mean(vectorized_geodesic_distances),100);
save('results/radial_distance.mat','radial_distance');
%%
pair_correlation = {};
%%
vec_mean_weight_each_node = zeros(G.N,1);
for i=1:G.N
    indexes_first_neigh = find(G.W(i,:) > 0);
    vec_mean_weight_each_node(i) = min(G.W(i,indexes_first_neigh));
end
delta_r = mean(vec_mean_weight_each_node); 
%%
for i=1:size(densities,2)
    i
    load(['void_cluster_pattern_',num2str(densities(i)),'.mat']);
    for j=1:size(void_cluster_pattern,1)
        s = void_cluster_pattern(j,:);
        s_all{i}(j,:) = s;
        s = s';
        pair_correlation{i}(j,:) = compute_pair_correlation(s,geodesic_distances,delta_r,radial_distance);
    end
end
save('results/s_all.mat','s_all');
save('results/densities.mat','densities');
save('results/power_spectrum.mat','power_spectrum');
save('results/pair_correlation.mat','pair_correlation');