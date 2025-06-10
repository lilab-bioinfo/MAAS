## MAAS
### Overview
Single-cell multimodal analysis enables highly accurate delineation of clinically relevant tumor cell subpopulations

<p align="center">



<img src="https://bioinfo.szbl.ac.cn/share/MAAS_data/Figure 1.png" alt="Flowchart" style="width: 70%">

<p align="center">

### Installation
Before installation, we recommend gcc 6.1 or newer in your system. The installation works well with gcc = 11.4.0 in our system.
Use command below to check the version of gcc. If it doesn't meet the requirement, you can ask the system administrator to update the gcc.
```
gcc -v
```

Run the command in R
```
if (!requireNamespace("devtools", quietly = T)) {
  install.packages("devtools")
}
devtools::install_github("Larrycpan/MAAS")
```

### Quick start
```
library(MAAS)
set.seed(1234) ## This ensure the same result for each MAAS run
# Here we load the example data of cell-cell similarity cell matrices for each layer
data("maas_example")
maas.test <- MAAS(maas_example$Peak, maas_example$CNV, maas_example$SNV, dims = 2:5)
```

##### Then we can do clustering based on the consensus latent factors
```
#### Determine the reasonable clustering strategy
clusPerformance <- data.frame(matrix(nrow = length(maas.test)-1, ncol = 5),
                              row.names = paste0("dims=", 2:length(maas.test)))
colnames(clusPerformance) <- paste0("k=", 2:6)
for(i in 1:(length(maas.test)-1)){
  for(j in 2:6){
    df <- as.data.frame(maas.test[[i]]$W)
    maas.tmp.clu <- withr::with_seed(2, kmeans(df, centers = j)$cluster)
    clusPerformance[i,j-1] <- clusteringMetric(maas.test[[i]]$W, clu = maas.tmp.clu, disMethod = "cosine")
  }
}
```

From `clusPerformance`, we observe that *W* = 2 (number of latent factors) and *k* = 2 (number of clusters) yield an optimal score, we can then set up the parameters and run clustering again.

|        | k=2       | k=3       | k=4        | k=5        | k=6         |
|--------|-----------|-----------|------------|------------|-------------|
| dims=2 | 7.6580070| 0.04792606| 0.001519815| 0.0003074383| 0.000000e+00 |
| dims=3 | 0.1610961 | 0.10854696| 0.011809798| 0.0666966181| 3.026747e-03 |
| dims=4 | 0.1280585 | 0.05573401| 0.015179780| 0.0071901979| 1.336539e-05 |
| dims=5 | 0.2274295 | 0.09587623| 0.006809193| 0.0052164072| 1.387891e-02 |



##### Re-running clustering with the optimal performance
```
df <- as.data.frame(maas.test[[1]]$W)
maas.clu <- data.frame(Cluster = withr::with_seed(2, kmeans(df, centers = 2)$cluster))
maas.clu$Cluster <- as.factor(maas.clu$Cluster)
```

##### Visualize clusters projected on embeddings
```
umap.axis <- withr::with_seed(2, uwot::umap(df, n_neighbors = 10, metric = "correlation"))
umap.axis <- as.data.frame(umap.axis); umap.axis$Cluster <- maas.clu$Cluster
colnames(umap.axis) <- c("UMAP-1", "UMAP-2", "Cluster")
ggplot(umap.axis, aes(`UMAP-1`, `UMAP-2`))+
  geom_point(aes(color = Cluster), size = 1.75)+
  theme_dr()+
  labs(x = "UMAP-1", y = "UMAP-2")+
  theme(panel.grid = element_blank(),
        axis.title = element_text(size = 14),
        axis.text = element_blank(),
        legend.text = element_text(size = 12))
```

<p align="center">
<img src="https://www.helloimg.com/i/2025/06/10/68479ca101406.png" alt="Flowchart" style="width: 40%">
</p>

Documentation and step-by-step tutorials (full data preparation and integration) can be found at <https://larrycpan.github.io/MAAS/>.

In addition, we highly recommend installing [openBLAS](https://github.com/OpenMathLib/OpenBLAS) to speed matrix operations.

### Getting help

If you encounter a bug or have a feature request, please open an [Issues](https://github.com/Larrycpan/MAAS/issues).

If you would like to discuss questions related to single-cell analysis, you can open a [Discussions](https://github.com/Larrycpan/MAAS/discussions).


### Related packages
-  [Signac](https://stuartlab.org/signac/): peak calling
-  [epiAneufinder](https://github.com/colomemaria/epiAneufinder): CNV calling
-  [SComatic](https://github.com/cortes-ciriano-lab/SComatic): SNV calling
-  [CBM](https://github.com/zhyu-lab/cbm): SNV denoising
