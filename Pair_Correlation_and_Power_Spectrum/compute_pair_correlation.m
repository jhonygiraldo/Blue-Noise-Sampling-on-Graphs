function pair_correlation = compute_pair_correlation(s,geodesic_distances_matrix,delta_r,radial_distance)
% Author: Jhony G. Giraldo, Alejandro Parada-Mayorga.
% This function computes the pair correlation of a sampling pattern s of a
% graph W, taking the definition of weights in W as the geodesic distances
% on graphs.

%%%
% Parameter Description
% 
% Input
% s: sampling pattern,
% geodesic_distances: matrix of all geodesic distances,
% delta_r: width of the annulus region,
% radial_distance: vector of distances in which the pair correlation is
% going to be evaluated.
% 
% Output
% pair_correlation: pair correlation vector
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

N = size(geodesic_distances_matrix,1);
if(sum(s) > sum(~s))
    minority_nodes = 0;
else
    minority_nodes = 1;
end
%%
[indexes_s] = find(s == minority_nodes);
pair_correlation_num = zeros(size(indexes_s,1),size(radial_distance,2));
pair_correlation_den = zeros(N,size(radial_distance,2));
cont = 1;
for(i=1:N)
    if(ismember(i,indexes_s))
        for(j=1:length(radial_distance))
            nodes_in_ring = find(geodesic_distances_matrix(i,:) >= ...
                radial_distance(j)-delta_r/2 & geodesic_distances_matrix(i,:) < ...
                radial_distance(j)+delta_r/2 & geodesic_distances_matrix(i,:) ~= 0);
            subset_nodes_in_ring = s(nodes_in_ring);
            pair_correlation_den(i,j) = sum(subset_nodes_in_ring);
            pair_correlation_num(cont,j) = pair_correlation_den(i,j);
        end
        cont = cont + 1;
    else
        for(j=1:length(radial_distance))
            nodes_in_ring = find(geodesic_distances_matrix(i,:) >= ...
                radial_distance(j)-delta_r/2 & geodesic_distances_matrix(i,:) < ...
                radial_distance(j)+delta_r/2 & geodesic_distances_matrix(i,:) ~= 0);
            subset_nodes_in_ring = s(nodes_in_ring);
            pair_correlation_den(i,j) = sum(subset_nodes_in_ring);
        end
    end
end
pair_correlation = mean(pair_correlation_num)./mean(pair_correlation_den);