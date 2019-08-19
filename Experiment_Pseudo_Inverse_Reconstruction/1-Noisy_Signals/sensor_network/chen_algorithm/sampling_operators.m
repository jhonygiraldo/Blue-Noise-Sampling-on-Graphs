clear all, close all, clc;
load('../sensor_graph.mat');
%%
N = G.N;
m = 200;
K = 50;
V_K = G.U(:,1:K);
sampling_operator = sampling_chen_algorithm(V_K,m,N);
save('sampling_operator_chen.mat','sampling_operator');