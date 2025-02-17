% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getMetGraph.R
\name{getMetGraph}
\alias{getMetGraph}
\title{Transform the edges list of each sample in graphml format graphs}
\usage{
getMetGraph(input_dir, output_dir)
}
\arguments{
\item{input_dir}{path to input directory containing the samples edge lists}

\item{output_dir}{path to output directory}
}
\value{
graphs in graphml format
}
\description{
This function creates a graph for each sample where metabolites are nodes and the enzymes are the edges, whose weight is given by the expression value.
It simplifies the multiedges in single ones by taking the mean of enzyme catalyzing the same reaction and summing up those coming from different reactions.
}
\examples{
\dontrun{
input_dir <- system.file("extdata/edges_list/", package = "MetabolitesGraphs")
output_dir <- "/path/to/ouput/"
getMetGraph(input_dir,output_dir)}
}
