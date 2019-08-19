clear all, close all, clc;
load('sensor_graph.mat');
W = G.W;
N = size(W,1);
%%
load('void_cluster/void_cluster_pattern.mat');
void_cluster_all_patterns = void_cluster_pattern;
%%
load('chen_algorithm/sampling_operator_chen.mat');
%%
load('anis_algorithm/sampling_patterns_anis.mat');
%%
load('tsitsvero_algorithm/sampling_patterns_tsitsvero.mat');
%%
bandwidth = 50;
repetitions = 100;
m = [20:20:200];
%%
error_void_cluster = zeros(repetitions,length(m));
%%
error_chen = zeros(repetitions,length(m));
error_tsitsvero = zeros(repetitions,length(m));
error_anis = zeros(repetitions,length(m));
error_random = zeros(repetitions,length(m));
%%
for(p=1:size(m,2))
    p
    void_cluster_pattern = void_cluster_all_patterns{p};
    %%
    random_pattern = zeros(repetitions,N);
    parfor(h=1:repetitions)
        amount_intial_nodes = m(p); % Minority nodes
        initial_binary_pattern = zeros(N,1);
        white_noise_pattern = normrnd(1,0.5,[N,1]);
        white_noise_orderer = sort(white_noise_pattern,'descend');
        white_noise_orderer = white_noise_orderer(1:amount_intial_nodes);
        for(i=1:amount_intial_nodes)
            initial_binary_pattern(find(white_noise_pattern == white_noise_orderer(i))) = 1;
        end
        random_pattern(h,:) = initial_binary_pattern;
    end
    %%
    M_chen = sampling_operator(1:m(p),:);
    %%
    sampling_tsitsvero = zeros(N,1);
    sampling_tsitsvero(sampling_index_tsitsvero(1:m(p))) = 1;
    M_tsitsvero = zeros(m(p),N);
    ind_M_tsitsvero = 1;
    for(j=1:N)
        if(sampling_tsitsvero(j))
            M_tsitsvero(ind_M_tsitsvero,j) = 1;
            ind_M_tsitsvero = ind_M_tsitsvero + 1;
        end
    end
    pseudo_inverse_tsitsvero = pinv(M_tsitsvero*G.U(:,1:bandwidth));
    parfor(h=1:repetitions)
        M_void_cluster = zeros(m(p),N);
        M_anis = zeros(m(p),N);
        M_random = zeros(m(p),N);
        %%
        ind_M_void_cluster = 1;
        ind_M_anis = 1;
        ind_M_random = 1;
        for(j=1:N)
            if(void_cluster_pattern(h,j))
                M_void_cluster(ind_M_void_cluster,j) = 1;
                ind_M_void_cluster = ind_M_void_cluster + 1;
            end
            %%
            if(sampling_patterns_anis(p,j))
                M_anis(ind_M_anis,j) = 1;
                ind_M_anis = ind_M_anis + 1;
            end
            %%
            if(random_pattern(h,j))
                M_random(ind_M_random,j) = 1;
                ind_M_random = ind_M_random + 1;
            end
        end
        %%
        pseudo_inverse_void_cluster = pinv(M_void_cluster*G.U(:,1:bandwidth));
        pseudo_inverse_anis = pinv(M_anis*G.U(:,1:bandwidth));
        pseudo_inverse_chen = pinv(M_chen*G.U(:,1:bandwidth));
        pseudo_inverse_random = pinv(M_random*G.U(:,1:bandwidth));
        %%
        x_hat = normrnd(1,0.5,[bandwidth,1]);
        number_zeros = N-bandwidth;
        x_hat = [x_hat;zeros(number_zeros,1)];
        x = G.U*x_hat;
        %%
        SNR = 20;
        x_sampled_void_cluster = M_void_cluster*x;
        x_sampled_void_cluster = add_gaussian_noise(x_sampled_void_cluster,SNR);
        %%
        x_sampled_anis = M_anis*x;
        x_sampled_anis = add_gaussian_noise(x_sampled_anis,SNR);
        %%
        x_sampled_chen = M_chen*x;
        x_sampled_chen = add_gaussian_noise(x_sampled_chen,SNR);
        %%
        x_sampled_tsitsvero = M_tsitsvero*x;
        x_sampled_tsitsvero = add_gaussian_noise(x_sampled_tsitsvero,SNR);
        %%
        x_sampled_random = M_random*x;
        x_sampled_random = add_gaussian_noise(x_sampled_random,SNR);
        %%
        x_reconstructed_void_cluster = ...
            G.U(:,1:bandwidth)*pseudo_inverse_void_cluster*x_sampled_void_cluster;
        x_reconstructed_anis = ...
            G.U(:,1:bandwidth)*pseudo_inverse_anis*x_sampled_anis;
        %%
        x_reconstructed_chen = G.U(:,1:bandwidth)*pseudo_inverse_chen*x_sampled_chen;
        %%
        x_reconstructed_tsitsvero = G.U(:,1:bandwidth)*pseudo_inverse_tsitsvero*x_sampled_tsitsvero;
        %%
        x_reconstructed_random = ...
            G.U(:,1:bandwidth)*pseudo_inverse_random*x_sampled_random;
        %%
        error_void_cluster(h,p) = immse(x,x_reconstructed_void_cluster);
        error_anis(h,p) = immse(x,x_reconstructed_anis);
        %%
        error_chen(h,p) = immse(x,x_reconstructed_chen);
        %%
        error_tsitsvero(h,p) = immse(x,x_reconstructed_tsitsvero);
        %%
        error_random(h,p) = immse(x,x_reconstructed_random);
    end
end
%%
mkdir('results/');
save('results/error_void_cluster.mat','error_void_cluster');
save('results/error_anis.mat','error_anis');
save('results/error_chen.mat','error_chen');
save('results/error_tsitsvero.mat','error_tsitsvero');
save('results/error_random.mat','error_random');
%%
save('results/m.mat','m');
save('results/bandwidth.mat','bandwidth');