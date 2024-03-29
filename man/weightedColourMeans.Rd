% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/general.purpuse.utilities.R
\name{weightedColourMeans}
\alias{weightedColourMeans}
\title{Calculate weighted mean colour}
\usage{
weightedColourMeans(cols, weights)
}
\arguments{
\item{cols}{vector of colors (any notation)}

\item{weights}{matrix with number of columns equal to the length of \code{cols} (in same order).}
}
\value{
vector of colours (length equal to nrow of weights)
}
\description{
Weights are normalized per row by total
}
