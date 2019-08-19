clear all, close all, clc;
load('../barabasi_graph.mat');
%%
N = G.N;
m = 200;
sampling_patterns_tsitsvero = zeros(length(m),N);
sampling_index_tsitsvero = zeros(m);
bandwidth = 50;
for(i=1:length(m))
    i
    [sampling_patterns_tsitsvero(i,:),sampling_index_tsitsvero] = sampling_tsitsvero_algorithm(G.U,m(i),bandwidth);
end
save('sampling_patterns_tsitsvero.mat','sampling_patterns_tsitsvero','sampling_index_tsitsvero');