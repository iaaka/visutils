% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tissue.border.R
\name{findTissueBorder}
\alias{findTissueBorder}
\title{Classifies visium spots according to its position relative to tissue slice border}
\usage{
findTissueBorder(rc, image.name = NULL)
}
\arguments{
\item{rc}{either seurat object or seu@images[\link{.}]@coordinates dataframe}
}
\value{
list with two elements:
\enumerate{
\item augmented rc dataframe with spot coordinates. Following columns added:
tissue.piece - number of tissue piece
is.border - specifies whether spot is tissue border
border.inx - consecutive number of border spots
\item nj - list of spot neighbors
}
}
\description{
Classifies visium spots according to its position relative to tissue slice border
}
