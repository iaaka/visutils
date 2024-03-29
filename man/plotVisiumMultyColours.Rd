% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visium.graphics.R
\name{plotVisiumMultyColours}
\alias{plotVisiumMultyColours}
\title{Plot multiple numerical values (gene expression or cell abundances) on H&E image}
\usage{
plotVisiumMultyColours(
  v,
  z,
  cols = NULL,
  zfun = function(x) x^2,
  scale.per.colour = TRUE,
  min.opacity = 0,
  title.adj = c(0, -0.5),
  legend.ncol = 1,
  ...
)
}
\arguments{
\item{v}{Seurat object}

\item{z}{matrix with values (in columns) to be plotted}

\item{cols}{colors to be used for columns in z}

\item{zfun}{function to transform values in z (z^2 is default)}

\item{scale.per.colour}{logical, specifies whether each color should cover whole range (that is, should z be scaled per column)}

\item{min.opacity}{minimal spot opacity. Default is 0, that means that spots with low intensity of all features will be almost transparent. Set it higer if you want at least one feature to be visible in each spot.}

\item{title.adj}{legend title adj (to be passed to text function)}

\item{legend.ncol}{number of legend columns. Set to 0 to suppress legend plotting.}

\item{...}{other parameters to be passed to plotVisium}
}
\value{
data.frame with user spot coordinates
}
\description{
Each spot is colored by weighted mean colour. Opacity of spot is proportional to maximal feature intensity.
}
