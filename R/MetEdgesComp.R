#' Load a metabolic model and extract the stoichiometric matrix
#'
#' This function loads a model in SBML format and returns a stoichiometric matrix.
#'
#' @param infile Path to the input SBML file
#' @import sybilSBML
#' @importFrom Hmisc %nin%
#' @return A stoichiometric matrix
#' @export
#'
#' @examples
#' \dontrun{
#'stoich_mat <- load_mod(system.file("extdata", "kidney.xml", package = "MetabolitesGraphs"))}
#'stoich_mat <- load_mod(system.file("extdata", "kidney.xml", package = "Met2Graph"))}
load_mod <- function(infile){
  mod <- readSBMLmod(infile, bndCond = FALSE)
  stoich_mat <- as.matrix(mod@S)
  colnames(stoich_mat) <- mod@react_id
  rownames(stoich_mat) <- mod@met_id
  stoich_mat
}

#' Extract produced and consumed metabolites (met) for each reaction (rxn) of the metabolic model
#'
#' This function creates the edges list necessary to build the metabolites graph.
#' It merges the metabolites produced and consumed by each reaction into a new
#' dataframe.
#'
#' @param infile stoichiometric matrix
#' @return A dataframe with metabolites edges list
#' @export
#' @examples
#' \dontrun{
#' edges_list <- edges_list(stoich_mat)
#' }
#'
#from stoichiometric matrix extract positive relationships between rxn and met
edges_list <- function(infile) {
  stoich_df=as.data.frame(infile)
  indices_pos <- which(stoich_df > 0, arr.ind=TRUE)
  indices_pos[,"row"] <- rownames(stoich_df)[as.numeric(indices_pos[,"row"])]
  indices_pos[,"col"] <- colnames(stoich_df)[as.numeric(indices_pos[,"col"])]
  #from stoich matrix extract negative rel between rxn and met
  indices_neg <- which(stoich_df < 0, arr.ind=TRUE)
  indices_neg[,"col"] <- colnames(stoich_df)[as.numeric(indices_neg[,"col"])]
  indices_neg[,"row"] <- rownames(stoich_df)[as.numeric(indices_neg[,"row"])]
  #merge by reaction name (edge_list)
  merge_neg_pos=merge(indices_neg,indices_pos,by.x="col",by.y="col")
  merge_neg_pos
}

#' Add enzymes catalyzing each reaction from the Generic genome-scale metabolic model of Homo sapiens
#'
#' This function add a new column with enzymes matching the correspondent reaction
#' @param edges_list dataframe with metabolites edges list
#' @param rx_gene RXN-GENE dataframe extracted from Homo Sapiens generic GEM
#' @importFrom dplyr rename %>%
#' @importFrom reshape2 melt
#' @return A dataframe with reactions, metabolites edges, and enzymes
#' @export
#' @examples
#' \dontrun{
#' data(rxn_gene)
#' edges_list_w_enzymes <- add_enzymes(edges_list, rxn_gene)}
add_enzymes <- function(edges_list, rxn_gene){
  f1=merge(edges_list,rxn_gene,by.x="col",by.y="V1")
  f2=melt(f1, id.vars=c("col", "row.x", "row.y"))
  f3=f2[!(is.na(f2$value) | f2$value==""), ]
  f3=f3 %>%
    rename(
      Reaction = col,
      met1 = row.x,
      met2 = row.y,
      Enzyme = value
    )
  f3
}


#' Remove recurring metabolites
#'
#' This function removes the recurring metabolites to avoid unrealistic connections
#'
#' @param edges_list Metabolites edges dataframe, where metabolites columns are named "met1" and "met2"
#' @param met_list vector of recurring metabolites ids
#' @importFrom Hmisc %nin%
#' @return A dataframe with metabolites edges list, without recurring metabolites
#' @export
#' @examples
#' \dontrun{
#' data(recurring_mets)
#' edges_list_no_rec_mets <- remove_mets(edges_list_w_enzymes, curr_met)}
#from stoich matrix extract positive relationships between rxn and met
remove_mets <- function(edges_list_w_enzymes, recurring_mets){
  met_filt_df = edges_list_w_enzymes[which(edges_list_w_enzymes$met1  %nin% recurring_mets), ]
  met_filt_df = met_filt_df[which(met_filt_df$met2  %nin% recurring_mets), ]
  met_filt_df
}

