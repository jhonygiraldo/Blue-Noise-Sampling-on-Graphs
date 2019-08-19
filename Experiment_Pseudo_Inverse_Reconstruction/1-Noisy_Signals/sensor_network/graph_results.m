clear all, close all, clc;
%%
load('results/error_void_cluster.mat');
load('results/error_anis.mat');
load('results/error_chen.mat');
load('results/error_tsitsvero.mat');
load('results/error_random.mat');
%%
load('results/m.mat');
load('results/bandwidth.mat');
line_width = 2;
marker_size = 8;
%%
plot(m,10*log10(mean(error_random)),'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
plot(m,10*log10(mean(error_chen)),'LineWidth',line_width,'MarkerSize',marker_size);
plot(m,10*log10(mean(error_tsitsvero)),'LineWidth',line_width,'MarkerSize',marker_size);
plot(m,10*log10(mean(error_anis)),'-s','LineWidth',line_width,'MarkerSize',marker_size);
plot(m,10*log10(mean(error_void_cluster)),'-d','LineWidth',line_width,'MarkerSize',marker_size);
%%
lgd = legend('Random','Chen method','Tsitsvero method','Anis method','Void-and-cluster');
set(lgd,'Interpreter','latex');
xlabel('Sample size','Interpreter','Latex');
ylabel({'Reconstruction','MSE (dB)'},'Interpreter','Latex');
%%
frame_h = get(handle(gcf),'JavaFrame');
set(gca,'LooseInset',get(gca,'TightInset'));
%%
get(gca);
set(gca,'FontName','times','FontSize',20);
%%
xlim([bandwidth m(end)]);
ylim([-40 10]);
path_figures = 'figures/';
mkdir(path_figures);
saveas(gcf,[path_figures 'noisy_signals_G1.svg']);