clear all, close all, clc;
load('results/pair_correlation.mat');
load('results/s_all.mat');
load('results/radial_distance.mat');
load('results/power_spectrum.mat');
load('results/densities.mat');
load('sensor_graph.mat');
param.colorbar = 0;
%%
vec_mean_weight_each_node = zeros(G.N,1);
for i=1:G.N
    indexes_first_neigh = find(G.W(i,:) > 0);
    vec_mean_weight_each_node(i) = mean(G.W(i,indexes_first_neigh));
end
D = mean(vec_mean_weight_each_node);
%%
path_figures = 'figures/';
mkdir(path_figures);
%%
font_size = 20;
lambda_bvec=[0.3999 0.1588 0.0999 0.07645];
for rr=1:size(densities,2)
    %% Visualization of the sampling pattern on the graph
    G2 = graph(G.W);
    s1=s_all{rr}(rr,:)';
    figure;
    pa = plot(G2,'XData',G.coords(:,1),'YData',G.coords(:,2));
    xlim([-0.01 1.01]);
    ylim([-0.01 1.01]);
    set(gca,'LooseInset',get(gca,'TightInset'));
    pa.MarkerSize = 2*s1+2;
    pa.EdgeColor=[192,192,192]/255;
    pa.NodeColor=repmat(s1,[1,3]).*repmat([0,102,204]/255,[G.N,1])+repmat(1-s1,[1,3]).*repmat([180, 180, 180]/255,[G.N,1]);
    axis off
    title(['$d=$',num2str(densities(rr))],'Interpreter','latex','FontSize',font_size);
    saveas(gcf,[path_figures,'void_and_cluster_sensor_graph_' num2str(densities(rr)*100) '.svg'])
    %% Pair correlation picture
    pair_correlation_chart = mean(pair_correlation{rr});
    figure;
    plot(radial_distance,pair_correlation_chart,'LineWidth',2,'Color','black');
    set(gca,'LooseInset',get(gca,'TightInset'));
    xlabel('$\rho$','Interpreter','latex','FontSize',font_size);
    ylabel('$\mathcal{R}(\rho)$','Interpreter','latex','FontSize',font_size);
    ylim([0 2]);
    xlim([0 0.5]);
    title(strcat('$d=$',num2str(densities(rr))),'Interpreter','latex','FontSize',font_size);
    grid;
    hold on;
    lambda_pwav=lambda_bvec(rr);
    plot(lambda_pwav,min(pair_correlation_chart(:)),'k','Marker','d','MarkerSize',8,'MarkerFaceColor',[0,102,204]/255,'LineWidth',2,'Color','blue');
    %%
    frame_h = get(handle(gcf),'JavaFrame');
    set(gca,'LooseInset',get(gca,'TightInset'));
    get(gca);
    set(gca,'FontName','times','FontSize',font_size);
    %%
    saveas(gcf,[path_figures,'void_and_cluster_sensor_Pair_Correlation_' num2str(densities(rr)*100) '.svg'])
    %% Spectrum pictures
    figure;
    stem(G.e(2:end),power_spectrum(rr,:),'LineWidth',1,'Color','black','Marker','.');
    set(gca,'LooseInset',get(gca,'TightInset'))
    %%
    axis tight
    ylim([0 3]);
    xlabel('$\mu$','Interpreter','latex','FontSize',font_size);
    ylabel('$\mathbf{p}(\mu)$','Interpreter','latex','FontSize',font_size);
    title(strcat('$d=$',num2str(densities(rr))),'Interpreter','latex','FontSize',font_size);
    grid;
    %%
    frame_h = get(handle(gcf),'JavaFrame');
    set(gca,'LooseInset',get(gca,'TightInset'));
    get(gca);
    set(gca,'FontName','times','FontSize',font_size);
    %%
    saveas(gcf,[path_figures,'void_and_cluster_sensor_Power_Spectrum_' num2str(densities(rr)*100) '.svg']);
end