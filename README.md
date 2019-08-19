# Blue-Noise-Sampling-on-Graphs
By Alejandro Parada-Mayorga, Daniel L Lau, Jhony H Giraldo, Gonzalo R Arce

**Abstract**: In the area of graph signal processing, a graph is a set of nodes arbitrarily connected by weighted links; a graph signal is a set of scalar values associated with each node; and sampling is the problem of selecting an optimal subset of nodes from which any graph signal can be reconstructed. For small graphs, finding the optimal sampling subset can be determined by looking at the graph's Fourier transform; however in some cases the spectral decomposition used to calculate the Fourier transform is not available. As such, this paper proposes the use of a spatial dithering, on the graph, as a way to conveniently find a statistically good, if not ideal, sampling-establishing that the best sampling patterns are the ones that are dominated by high frequency spectral components, creating a power spectrum referred to as blue-noise. The theoretical connection between blue-noise sampling on graphs and previous results in graph signal processing is also established, explaining the advantages of the proposed approach. Restricting our analysis to undirected and connected graphs, numerical tests are performed in order to compare the effectiveness of blue-noise sampling against other approaches.

## Citing Blue Noise Sampling on Graphs

If you find blue noise sampling on graphs useful in your research, please consider citing:

```
@ARTICLE{parada2019blue,
  author={A. {Parada-Mayorga} and D. L. {Lau} and J. H. {Giraldo} and G. R. {Arce}}, 
  journal={IEEE Transactions on Signal and Information Processing over Networks}, 
  title={Blue-Noise Sampling on Graphs}, 
  year={2019}, 
  volume={5}, 
  number={3}, 
  pages={554-569}, 
  keywords={Bandwidth;Laplace equations;Signal processing algorithms;Eigenvalues and eigenfunctions;Information processing;Signal sampling;Blue-noise sampling;graph signal processing;signal processing on graphs;sampling sets}, 
  doi={10.1109/TSIPN.2019.2922852}, 
  ISSN={2373-776X}, 
  month={Sep.},}
```

## Requirements: software

The Graph Signal Processing Toolbox is required to run the script *Demo.m*. [GSP Toolbox](https://epfl-lts2.github.io/gspbox-html/).
