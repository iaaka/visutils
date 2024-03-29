% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nmf.R
\name{getNMFNormFs}
\alias{getNMFNormFs}
\title{Get function to normalize NMF results}
\usage{
getNMFNormFs(type)
}
\arguments{
\item{type}{either 'no' for no normalization or 'max' for max-normalization of basis}
}
\value{
function that takes output of nmf function as input and calculates normalization coeficients
}
\description{
same NMF deconvolution can be expressed in infinite number of ways (different by scaling of factors), one need to define either normalization or regularization to unambiguously choose one.
}
