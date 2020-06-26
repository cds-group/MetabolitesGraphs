# MetabolitesGraphs
MetabolitesGraphs contains the codes to integrate gene expression data into a metabolic model and extract metabolites-based graphs. It provides test expression data and kidney model.

The metabolites are connected by reactions and by the relative catalyzing enzymes. Two metabolites are connected if one is a substrate and the other one is a product in one or multiple reactions.

The gene-protein-reaction associations are needed. The relative file, containing the reaction and the gene ids associated. By default, the one from the human generic GEM is used.

If the parameter catalyzed is TRUE, only reactions with associated enzymes are kept.

Each edge represented by the enzymes catalyzing the reactions is weighted by their expression values.

Multiple edges, corresponding to the multiple enzymes connecting the two metabolites, are simplified to single edges:
for each edge expression values of enzymes acting in the same reaction are averaged, and these averages are then summed up for enzymes acting in different reactions

This document provides a general pipeline.
To report bugs and arising issues, please visit https://github.com/cds-group/MetabolitesGraphs

# Installation Instructions

## System Prerequisites
MetabolitesGraphs needs the package sybilSBML, which in turn depends on libSBML to import and read SBML files.
Running functions could fail if these prerequisite library is not available. 
Please read through the instructions provided at https://github.com/cran/sybilSBML/blob/master/inst/INSTALL.

### R Package dependencies
devtools package is needed to install MetabolitesGraphs directly from github.

##### devtools
Package devtools is available at CRAN. For Windows, this seems to depend on
having Rtools for Windows installed. You can download and install this from:
http://cran.r-project.org/bin/windows/Rtools/

To install R package devtools call:
```r
    install.packages("devtools")

```

### MetabolitesGraphs Installation
#### From GitHub using devtools:
In R console, type:

```r
    library(devtools)
    install_github(repo="MetabolitesGraphs", username="cds-group")
```

# Getting Started
First, load the library.

```{r, echo=TRUE, eval=FALSE}
library(MetabolitesGraphs)
```

Import and read a metabolic model in SBML to get the stoichiometric matrix. In the example below the metabolic model of kidney tissue downloaded from https://metabolicatlas.org/ is imported.

```{r, echo=TRUE, eval=FALSE}
stoich_mat <- load_mod(system.file("extdata", "kidney.xml", package = "MetabolitesGraphs"))
```

Edges list is then extracted from the stoichiometric matrix.

```{r, echo=TRUE, eval=FALSE}
edges_list <- edges_list(stoich_mat)
```

Enzymes catalyzing each reaction from the Generic genome-scale metabolic model of Homo sapiens are added to the edges.

```{r, echo=TRUE, eval=FALSE}
data(rxn_gene)
edges_list_w_enzymes <- add_enzymes(edges_list, rxn_gene)
```

Most common recurring metabolites are removed to avoid unrealistic connections

```{r, echo=TRUE, eval=FALSE}
data(recurring_mets)
edges_list_no_rec_mets <- remove_mets(edges_list_w_enzymes, curr_met)
```

Expression values are associated to enzymes catalyzing each reaction for each sample

```{r, echo=TRUE, eval=FALSE}
expr_dir <- system.file("extdata/expression/", package = "MetabolitesGraphs"))
output_dir <- "./"
integrate_expression(edges_list_no_rec_mets,expr_dir, "txt", "edges-", output_dir)
```

Transform the edges list of each sample in graphml format graphs

```{r, echo=TRUE, eval=FALSE}
input_dir <- system.file("extdata/edges_list/", package = "MetabolitesGraphs"))
output_dir <- "./"
getMetGraph(input_dir,output_dir)
```


### Cite
1. Granata, I., Guarracino, M.R., Kalyagin, V.A., Maddalena, L., Manipur, I. and Pardalos, P.M., 2018, December. Supervised classification of metabolic networks. In 2018 IEEE International Conference on Bioinformatics and Biomedicine (BIBM) (pp. 2688-2693). IEEE.
https://ieeexplore.ieee.org/abstract/document/8621500
2. Granata, I., Guarracino, M.R., Kalyagin, V.A., Maddalena, L., Manipur, I. and Pardalos, P.M., 2020. Model simplification for supervised classification of metabolic networks. Annals of Mathematics and Artificial Intelligence, 88(1), pp.91-104.
https://link.springer.com/article/10.1007/s10472-019-09640-y
3. Granata, I., Guarracino, M.R., Maddalena, L. and Manipur, I., 2020, July. Network Distances for Weighted Digraphs. Accepted In 2020 International Conference on Mathematical Optimization Theory and Operations Research (MOTOR).
