#' Add expression values to enzymes catalyzing each reaction for each sample
#'
#' This function creates a new file for each sample containing reactions, connected metabolites, enzymes and expression values
#' @param df dataframe of edges list containing, reactions. metabolites and enzymes. The latter named "Enzyme"
#' @param expr_dir path to directory containing samples expression data
#' @param extension files extension
#' @param tag new filename tags
#' @param output_dir path to output directory
#' @return Sample specific dataframes with reactions, metabolites edges, enzymes and expression values
#'
#' @export
#'
#' @examples
#' \dontrun{
#' expr_dir <- system.file("extdata/expression/", package = "Met2Graph"))
#' output_dir <- "./"
#' integrate_expression(edges_list_no_rec_mets,expr_dir, "txt", "edges-", output_dir)}
integrate_expression <- function(df, expr_dir, extension, tag, output_dir){
    if(missing(expr_dir)) {
      setwd("./")
    } else {
      setwd(expr_dir)
    }

  if(missing(extension)) {
    extension="txt"
  } else {
    extension=extension
  }
  if(missing(tag)) {
    tag="edges-"
  } else {
    tag=tag
  }
  fileNames <- Sys.glob("*")

  fileNumbers <- seq(fileNames)

  for (fileNumber in fileNumbers) {

    newFileName <-  paste(tag,
                          sub(paste("\\.", extension, sep = ""), "", fileNames[fileNumber]),
                          ".", extension, sep = "")

    # read expression data:
    sample <- read.table(fileNames[fileNumber],
                         header = TRUE, row.names = NULL)


    colnames(sample)[1]="gene"
    colnames(sample)[2]="v1"

    df$expr= sample$v1[match(df$Enzyme,sample$gene)]
    f4=df[!(is.na(df$expr) | df$expr=="NA"), ]
    # write old data to new files:
    write.table(f4,
                paste0(output_dir,newFileName),
                append = FALSE,
                quote = FALSE,
                sep = ",",
                row.names = FALSE,
                col.names = TRUE)

  }

}
