% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/general.purpuse.utilities.R
\name{plotArea}
\alias{plotArea}
\title{Line with confidence interval}
\usage{
plotArea(
  x,
  p,
  col,
  sd.mult = 2,
  new = FALSE,
  ylim = NULL,
  xlim = range(x),
  area.transp = 0.2,
  type = "l",
  area.den = -1,
  cilim = NULL,
  ...
)
}
\arguments{
\item{x}{x coordinates}

\item{p}{y coordinates. Matrix with two (mean and sd) or three (mean, lower CI bound, higher CI bound) columns}

\item{col}{line and area colour}

\item{sd.mult}{coefficient to multiply sd to get CI}

\item{new}{make ne plot (default is to add line on existed plot)}

\item{ylim, xlim}{see \code{\link{plot}}}

\item{area.transp}{alpha for CI area}

\item{type}{type of \code{\link{plot}}}

\item{area.den}{density of \code{\link{polygon}}}

\item{cilim}{numerical vector with two values, gives lower and apper values to truncate CI. NULL (to truncation) by default.}

\item{...}{}
}
\description{
CI is shown by area
}
