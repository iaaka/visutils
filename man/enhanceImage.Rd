% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visium.utilities.R
\name{enhanceImage}
\alias{enhanceImage}
\title{Adjast image brightnes and contrast}
\usage{
enhanceImage(p, wb = FALSE, pow = 1, qs = NULL)
}
\arguments{
\item{p}{image (3d numeric array)}

\item{wb}{logical, specifies whether output image should be transformed to grayscale}

\item{pow}{power of transformation}

\item{qs}{quantiles to trim. Numerical vector with two items. Trims all values outside of specified quantile range.}
}
\value{
image (3d numeric array)
}
\description{
Adjast image brightnes and contrast
}
