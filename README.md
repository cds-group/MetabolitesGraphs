# MetabolitesGraphs

Code to build graphs integrating gene expression counts and a SBML metabolic model. The resulting weighted digrahps consist of nodes representing the metabolites; the edges connect substrate and product metabolites and their weights are obtained by combinations of expression values of the enzymes catalyzing the reactions in which the couple of metabolites is involved.

### Install
``` 
devtools::install_github("cds-group/MetaboliteGraphs")
```

### Cite
1. Granata, I., Guarracino, M.R., Kalyagin, V.A., Maddalena, L., Manipur, I. and Pardalos, P.M., 2018, December. Supervised classification of metabolic networks. In 2018 IEEE International Conference on Bioinformatics and Biomedicine (BIBM) (pp. 2688-2693). IEEE.
https://ieeexplore.ieee.org/abstract/document/8621500
2. Granata, I., Guarracino, M.R., Kalyagin, V.A., Maddalena, L., Manipur, I. and Pardalos, P.M., 2020. Model simplification for supervised classification of metabolic networks. Annals of Mathematics and Artificial Intelligence, 88(1), pp.91-104.
https://link.springer.com/article/10.1007/s10472-019-09640-y
