% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/merge.spots.R
\name{getCenters}
\alias{getCenters}
\title{Makes one step coarser spot mesh}
\usage{
getCenters(coors, cstart = 0L, type = 1L, to.merge = NULL, image.name = NULL)
}
\arguments{
\item{coors}{Seurat object or coors seu@images[\link{.}]@coordinates}

\item{cstart}{column coordinate of first (in -2th row) cluster center. Numbers for 0 to 13 will give different groupings.}

\item{type}{orientation of mesh, 1 or -1}

\item{to.merge}{logical vector specifying spots to be merged, use v$nCount_Spatial<500 to merge spots with less than 500 UMIs. NULL is identicall to all TRUE.}
}
\value{
modified spot coordinate table with group column added
}
\description{
Makes one step coarser spot mesh
}
\details{
There are severals ways to do so in dependence on starting point, this is controlled by cstart and type parameters. Maybe some combinations of these parameters results in identicall groupings, I didn't check it properly. Anyway I would suggest to always use defaults since it should not be very important.
}
\examples{
c2 = getCenters(v2)
plotVisium(v2,c2$group)
}
