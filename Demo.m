clear all, close all, clc;
%% Graph Construction using the GSP toolbox.
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
%% Computation of the geodesic distances.
disp('Computing the shortest path distances of all node pair');
geodesic_distances = distances(graph(G.W));
%% Blue noise sampling pattern generation.
density_nodes = 0.1;    % Density of sampled nodes
amount_nodes = round(density_nodes*G.N); % Amount of nodes
sampling_pattern = blue_noise_sampling_pattern(G,geodesic_distances,amount_nodes,0,1000); % Blue noise sampling pattern
%% Plot sampling pattern
pa = plot(graph(G.W),'XData',G.coords(:,1),'YData',G.coords(:,2));
xlim([-0.01 1.01]);
ylim([-0.01 1.01]);
pa.MarkerSize = 2*sampling_pattern+2;
pa.EdgeColor = [192,192,192]/255;
pa.NodeColor = repmat(sampling_pattern,[1,3]).*repmat([0,102,204]/255,[G.N,1])+repmat(1-sampling_pattern,[1,3]).*repmat([180, 180, 180]/255,[G.N,1]);
title(['$d=$',num2str(density_nodes)],'Interpreter','latex','FontSize',18);
axis off;