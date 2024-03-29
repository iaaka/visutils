% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/general.purpuse.utilities.R
\name{dotPlot}
\alias{dotPlot}
\title{Plots matrix as dotPlot}
\usage{
dotPlot(
  m,
  mc = m,
  rfun = sqrt,
  colfun = function(x) num2col(x, c("white", "yellow", "violet", "black")),
  grid = TRUE,
  grid.lty = 2,
  grid.col = "gray",
  max.cex = 1,
  xlab = "",
  ylab = "",
  ylab.cex = 1,
  xlab.cex = 1,
  colColours = NULL,
  rowColours = NULL,
  rowAnnWidth = 1,
  colAnnWidth = 1,
  scaleWM = FALSE,
  pch = 19,
  plot.legend = TRUE,
  legend.cex.at = NULL,
  legend.col.at = legend.cex.at,
  legend.cex.title = "",
  legend.col.title = "",
  ...
)
}
\arguments{
\item{m}{numeric matrix to be shown as dot size}

\item{mc}{numeric matrix to be shown as dot colour (uses m as default)}

\item{rfun}{function to calculate radius from matrix values. Use sqrt (default) to make area proportional to value}

\item{colfun}{function to transform values to colour gradient}

\item{grid}{logial, should grid be plotted}

\item{grid.lty}{lty of grid}

\item{grid.col}{line color of grid}

\item{max.cex}{max size of dots}

\item{xlab, ylab}{axis labels}

\item{ylab.cex}{magnification label for ylabs}

\item{colColours}{colour matrix to plot annotation for columns (matrix with nrow equal to ncol(m); each column of colColours is annotation)}

\item{rowColours}{colour matrix to plot annotation for row (matrix with nrow equal to nrow(m); each column of rowColours is annotation)}

\item{rowAnnWidth, colAnnWidth}{\itemize{
\item size of colour annotations in user coordinates
}}

\item{scaleWM}{logical, specifies wheter computed radiuses should be scaled into \link{0,1} interval (FALSE by default).}

\item{pch}{point character (19 by default)}

\item{plot.legend}{logical, whether legend should be plotted. Single legend will be plotted if m is identicall to mc.}

\item{legend.cex.at, legend.col.at}{values to be used in legend, set both to have two independent legends for size and colour}

\item{legend.cex.title, legend.col.title}{titles of legends}

\item{...}{other parameters to be passed to plot function}
}
\description{
Shows values in matix by point size and color. Size matrix (m) is not scaled by default, dot size is defined as m*max.cex
}
\examples{
c = matrix(1:12,ncol=3)
par(mar=c(4,4,1,10),bty='n')
dotPlot(c/12,-c,max.cex = 3,colColours = cbind(col1=c('red','blue','red'),col2=c('green','green','magenta')),
        rowColours = cbind(rrr1=c('red','blue','blue','red'),rrr2=c('green','green','magenta','green')),
      legend.cex.title='size',legend.col.title='col',
      colAnnWidth = 0.5,
      rowAnnWidth = 0.5)
}
