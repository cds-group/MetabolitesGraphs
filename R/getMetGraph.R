#' Transform the edges list of each sample in graphml format graphs
#'
#' This function creates a graph for each sample where metabolites are nodes and the enzymes are the edges, whose weight is given by the expression value.
#' It simplifies the multiedges in single ones by taking the mean of enzyme catalyzing the same reaction and summing up those coming from different reactions.
#' @param input_dir path to input directory containing the samples edge lists
#' @param output_dir path to output directory
#' @return graphs in graphml format
#' @import igraph
#' @export
#'
#' @examples
#' \dontrun{
#' input_dir <- system.file("extdata/edges_list/", package = "Met2Graph"))
#' output_dir <- "./"
#' getMetGraph(input_dir,output_dir)}
getMetGraph <- function(input_dir, output_dir){
  fileListKeep <- gsub('.txt', '', list.files(input_dir))
  for (i in fileListKeep){
    fileNamefull <- file.path(input_dir, paste0(i, ".txt"))
    graphRead <- read.csv(fileNamefull, header = TRUE)
  # Run for finding the mean of same rkns and sum for different rkns----------
    graphRead$met_nodes <- paste(graphRead$met1, graphRead$met2,sep = "_")
    graphRead$HMR_met_nodes <- paste(graphRead$Reaction, graphRead$met_nodes ,sep = "_")

  graph_mean <- as.data.frame(tapply(graphRead$expr, graphRead$HMR_met_nodes, mean))
  graph_mean$nodes <- substring(rownames(graph_mean), 10)
  graph_mean_sum <- as.data.frame(tapply(graph_mean$`tapply(graphRead$expr, graphRead$HMR_met_nodes, mean)`, graph_mean$nodes, sum))

  options(stringsAsFactors = FALSE)
  inpGraph <- as.data.frame(sub('\\_.*', '', row.names(graph_mean_sum)))
  colnames(inpGraph) <- "V1"
  inpGraph$V2 <- sub('.*\\_', '',row.names(graph_mean_sum) )
  inpGraph$weight <- graph_mean_sum[, 1]
  colnames(inpGraph) <- c("V1", "V2", "weight")

  graphMet <- graph.data.frame(inpGraph, directed = TRUE)

  fileNameout <- file.path(output_dir, paste0(i, '.graphml'))
  write.graph(graphMet, fileNameout, "graphml")

}
}
