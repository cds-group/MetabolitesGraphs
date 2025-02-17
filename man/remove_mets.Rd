% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MetEdgesComp.R
\name{remove_mets}
\alias{remove_mets}
\title{Remove recurring metabolites}
\usage{
remove_mets(edges_list_w_enzymes, recurring_mets)
}
\arguments{
\item{edges_list}{Metabolites edges dataframe, where metabolites columns are named "met1" and "met2"}

\item{met_list}{vector of recurring metabolites ids}
}
\value{
A dataframe with metabolites edges list, without recurring metabolites
}
\description{
This function removes the recurring metabolites to avoid unrealistic connections
}
\examples{
\dontrun{
data(recurring_mets)
edges_list_no_rec_mets <- remove_mets(edges_list_w_enzymes, curr_met)}
}
