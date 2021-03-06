#' log10(1+x)
#'
#' Same as log1p but with base equal to 10
#'
#' @param x numeric vector
#'
#' @return log10(1+x)
#' @export
#'
log10p1 = function(x){
  log1p(x)/log(10)
}

#' Calculate weighted mean colour
#'
#' Weights are normalized per row by total
#'
#' @param cols vector of colors (any notation)
#' @param weights matrix with number of columns equal to the length of \code{cols} (in same order).
#'
#' @return vector of colours (length equal to nrow of weights)
#' @export
#'
weightedColourMeans = function(cols,weights){
  weights = sweep(weights,1,apply(weights,1,sum),'/')
  colrgb = col2rgb(cols)
  z = weights %*% t(colrgb)
  apply(z,1,function(x)rgb(x[1],x[2],x[3],maxColorValue = 255))
}

#' 2D density plot
#'
#' Replacement of scatterplot to be used when number of points is to high and/or they highly overlap
#'
#' @param x,y point coordinates
#' @param xbins,ybins number of bins or bin borders. Everything outside of bins are removed
#' @param cols colours to form gradient
#' @param zfun transformation of frequency (try \code{\link{log1p}}, \code{\link{sqrt}}, etc). Identity by default
#' @param leg.title legend title
#' @param num.leg.tic desired number of tics in the legend
#' @param legend logical, should legend be plotted
#' @param trimZq frequencies outside of quantile(trimZq,1-trimZq) are set to the corresponding (closest) quantiles. Default is 0 (not trimming). See \code{\link{trimQ}}.
#' @param xlim,ylim,xlab,ylab graphical parameters
#' @param new create new plot (default) or add to existing
#' @param ... other arguments for plot function
#'
#' @return list bith bins and frequencies (invisible)
#' @export plot.as.hm
plot.as.hm = function(x,y,xbins=100,ybins=100,cols=c('white','gray','blue','orange','red'),zfun=identity,leg.title='',num.leg.tic=NULL,legend=TRUE,trimZq=0,xlim=NULL,ylim=NULL,new=TRUE,xlab=deparse(substitute(x)),ylab=deparse(substitute(y)),...){
  xlab;ylab;
  f = !is.na(x) & !is.infinite(x) & !is.na(y) & !is.infinite(y)
  if(!is.null(xlim)) f = f & x >= xlim[1] & x <= xlim[2]
  if(!is.null(ylim)) f = f & y >= ylim[1] & y <= ylim[2]
  x = x[f]
  y = y[f]
  if(length(xbins)==1) xbins = seq(min(x),max(x),length.out = xbins+1)
  if(length(ybins)==1) ybins = seq(min(y),max(y),length.out = ybins+1)

  f = x >= xbins[1] & x <= xbins[length(xbins)] & y >= ybins[1] & y <= ybins[length(ybins)]
  x = x[f]
  y = y[f]

  xb = findInterval(x,xbins,rightmost.closed = TRUE)
  yb = findInterval(y,ybins,rightmost.closed = TRUE)


  z = as.matrix(table(factor(yb,levels=1:(length(ybins)-1)),factor(xb,levels=1:(length(xbins)-1))))
  z = trimQ(z,trimZq)
  if(is.null(xlim)) xlim = range(x)
  if(is.null(ylim)) ylim = range(y)
  if(new)
    plot(1,t='n',xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,...)
  z2col=function(x)num2col(zfun(x),cols)
  rect(rep(xbins[-length(xbins)],each =length(ybins)-1),
       rep(ybins[-length(ybins)],times=length(xbins)-1),
       rep(xbins[-1]            ,each =length(ybins)-1),
       rep(ybins[-1]            ,times=length(xbins)-1),
       col=z2col(z),border = NA)
  if(legend)
    plotColorLegend2(grconvertX(1,'npc','nfc'),1,grconvertY(0,'npc','nfc'),grconvertY(1,'npc','nfc'),
                     range(z),range(z),zfun,z2col=z2col,leg=num.leg.tic,title=leg.title)
  invisible(list(xbins=xbins,ybins=ybins,z=z))
}

#' Trim by quantiles
#'
#' Sets all values of x below qth quantile to the quantile. Sets all values of x above (1-q)th quantile to the quantile.
#'
#' @param x numeric vector
#' @param q quantile
#'
#' @return corrected x
#' @export
#'
trimQ = function(x,q){
  if(q==0) return(x)
  qq=quantile(x,sort(c(q,1-q)))
  x[x<=qq[1]] = qq[1]
  x[x>=qq[2]] = qq[2]
  x
}

#' Creates palette for character vector
#'
#' Sorts t numerically if possible, alphabetically otherwise.
#'
#' @param t input character vector
#' @param bpal RColorBrewer pallete to be used if number of colors less than 10
#' @param colfun pallete function to be used in number of colors 10 or more
#' @param palette logical, specifies whether pallete (color per unique value in t) or colour along t should be returned
#'
#' @return names colour vector
#' @export
char2col = function(t,bpal='Set1',colfun=rainbow,palette=TRUE){
  torig = t
  t = sort(unique(t))
  suppressWarnings({
    if(all(!is.na(as.integer(t)))){
      t = as.character(sort(as.integer(t)))
    }
  })
  if(length(t)<10)
    r=setNames(RColorBrewer::brewer.pal(max(3,length(t)),bpal),t)[1:length(t)]
  else
    r=setNames(colfun(length(t)),t)
  if(!palette)
    r = r[torig]
  r
}

#' Recycle vector v along i
#'
#' @param v vector to be recycled
#' @param i either number of values to be obtained or 1:number_of_values
#'
#' @return recycled vector
#' @export
recycle = function(v,i){
  if(length(i)==1)
    i = 1:i
  v[(i-1)%%length(v)+1]
}

#' Transforms numbers to colours
#'
#' Wrapper function for colorRamp. Transforms numbers to the gradient specified by col parameter
#'
#' @param d numbers to be transformed
#' @param col colours to form gradient (blue-red by default)
#' @param minx,maxx range of x values (min(x),max(x) by default)
#'
#' @return vector of colours (same length as d)
#' @export
num2col = function(d,col=c('blue','cyan','gray','orange','red'),minx=min(d,na.rm = TRUE),maxx=max(d,na.rm = TRUE)){
  if(sd(d,na.rm=TRUE)==0)
    return(rep(col[1],length(d)))
  d[d<minx] = minx
  d[d>maxx] = maxx
  bwr = colorRamp(col,alpha=TRUE)
  apply(bwr(scaleTo(d,0,1,minx=minx,maxx=maxx))/255,1,function(x){
    if(is.na(x[1])) return(NA)
    rgb(x[1],x[2],x[3],x[4])
  })
}

#' Tests whether value is colour
#'
#' @param x vector to be tested
#'
#' @return logical vector
#' @export
isColors <- function(x) {
  if(is.factor(x)) return(rep(FALSE,length(x)))
  x %in% colors() | (substr(x,1,1)=='#' & (nchar(x)==7 |  nchar(x)==9))
}

#' Plot heatmap with numbers
#'
#' Wraps image functions
#'
#' @param d matrix to be plotted
#' @param t text to be ploted on top of image (rounds d by default)
#' @param digits number of digits retained under rounding of d
#' @param text.col color for text
#' @param xaxlab,yaxlab axis labels, dimnames(d) by default
#' @param centerColors0 logical, specifies whether 0 should be considered as palette center (makes sense for correlation matrices)
#' @param las orientation of axis labels (see las in ?par)
#' @param ... other options to be supplied to image
#'
#' @return
#' @export
imageWithText = function(d,t=NULL,digits=2,text.col=NULL,xaxlab=rownames(d),yaxlab=colnames(d),centerColors0=FALSE,las=2,...){
  if(is.null(t))
    t = round(d,digits = digits)
  pars = list(...)
  if(is.null(pars$col)) pars$col= num2col(1:100)
  pars$x = 1:nrow(d)
  pars$y = 1:ncol(d)
  if(is.null(pars$xlab)) pars$xlab=''
  if(is.null(pars$ylab)) pars$ylab=''
  pars$z = d
  pars$xaxt='n'
  pars$yaxt='n'
  if(!is.null(col) & centerColors0){
    m = max(abs(d),na.rm=T)
    if(is.numeric(centerColors0))
      m = centerColors0
    pars$breaks = seq(-m,m,length.out = length(pars$col)+1)
  }
  do.call(image,pars)
  if(is.null(text.col))
    text.col = 'black'
  text(rep(pars$x,times=length(pars$y)),rep(pars$y,each=length(pars$x)),t,col=text.col)
  if(!is.null(xaxlab))
    axis(1,pars$x,xaxlab,las=las)
  if(!is.null(yaxlab))
    axis(2,pars$y,yaxlab,las=las)
}

#' Gradient legend
#'
#' Wrapper for plotColorLegend to plot legend for given range
#'
#' @param x0,x1,y0,y1 rectange coordinates of the legend in nfc coordinates
#' @param fullzlim numeric vector with two items. Full range
#' @param zlim numeric vector with two items. Range to show (should be within fullzlim)
#' @param zfun transformation for value (gradient will be drawn along transformed value). Identity, log1p, sqrt, ets.
#' @param z2col function to transform numbers to colors
#' @param N number of steps in the gradient
#' @param ntic desired number of tics
#' @param leg tics values, if NULL (default) estimated automatically
#' @param title legend title
#'
#' @return
#' @export
plotColorLegend2 = function(x0,x1,y0,y1,fullzlim,zlim,zfun,z2col,N=100,ntic=5,leg=NULL,title=NULL){
  # make tics
  if(is.null(leg)){
    ztic = seq(zlim[1],zlim[2],length.out = 1e5)
    ztict = zfun(ztic)
    ztticat = seq(zfun(zlim[1]),zfun(zlim[2]),length.out = ntic)
    leg = ztic[findInterval(ztticat,ztict)]
    leg[1] = zlim[1]
    leg[ntic] = zlim[2]

    # adjust tic step
    d = (10^floor(log10(leg[2]-leg[1])))/2
    leg = unique(d*round(leg / d))
    leg = leg[leg>=zlim[1]]
  }
  # make colors
  ztat = zfun(leg)
  ztcol = sort(unique(c(ztat,seq(zfun(zlim[1]),zfun(zlim[2]),length.out = N))))
  col = z2col(c(zfun(fullzlim),ztcol))[-(1:length(fullzlim))]
  at = match(ztat,ztcol)
  plotColorLegend(x0,x1,y0,y1,col,at=at,legend=leg,title=title)
}

#' Gradient legend
#'
#' @param x0,x1,y0,y1 rectange coordinates of the legend in nfc coordinates
#' @param col vector of colors (full gradient)
#' @param at indexes (of col vector) to place tics
#' @param legend tics labels
#' @param title legend title
#'
#' @return
#' @export
#'
#' @examples
#' plot(1)
#' plotColorLegend(0.4,0.5,0.8,0.3,getPal(n=100),0:10*10,1:10)
plotColorLegend = function(x0,x1,y0,y1,col,at,legend,title=NULL){
  xpd = par(xpd=TRUE)
  y = seq(grconvertY(y0,'nfc','user'),grconvertY(y1,'nfc','user'),length.out = length(col)+1)
  rect(grconvertX(x0,'nfc','user'),y[-length(y)],grconvertX(x0+(x1-x0)*0.25,'nfc','user'),y[-1],col=col,border = NA)
  at = y[at]+(y[2]-y[1])/2
  text(grconvertX(x0+(x1-x0)*0.3,'nfc','user'),at,legend,adj=c(0,0.5))
  if(!is.null(title)){
    #text(grconvertX(x1,'nfc','user'),y[length(y)],title,adj=c(1,-0.5))
    text(grconvertX(x0,'nfc','user'),y[length(y)],title,adj=c(0,-0.5))
  }
  par(xpd=xpd)
}

#' Merge multiple png files into pdf
#'
#' @param dir path to the folder with pngfiles (used if \code{fls} is NULL)
#' @param fls character vector of paths to png files
#' @param pdfout name of output pdf
#' @param ... other parameters for \code{\link{pdf}} function
#'
#' @return
#' @export
mergePNG2PFD = function(dir=NULL,fls=NULL,pdfout,...){
  require(png)
  pdf(pdfout,...)

  if(is.null(fls))
    fls = sort(list.files(dir,full.names = T,pattern = "*.png"))

  for(f in fls) {
    print(f)
    pngRaster = readPNG(f)
    plot.new()
    par(xpd=NA)
    rasterImage(pngRaster, grconvertX(0,'ndc','user'), grconvertY(0,'ndc','user'),grconvertX(1,'ndc','user'),grconvertY(1,'ndc','user'))
  }
  dev.off()
}

#' Plots barplot with text around bar tops
#'
#' Barplot wrapper
#'
#' @param x heights of bars
#' @param t text to be plotted (\code{x} by default)
#' @param adj relative text position (see \code{\link{text}})
#' @param srt text rotation (see \code{\link{text}})
#' @param text.y text position (\code{x} by default)
#' @param ylim ylim
#' @param ... other barplot options
#'
#' @return
#' @export
barplotWithText = function(x,t=x,adj=c(0.5,1.1),srt=0,text.y=x,ylim=c(0,max(x)),...){
  if(length(ylim)==1)
    ylim = c(0,max(x)*ylim)
  b=barplot(x,ylim=ylim,...)
  text(b,text.y,t,adj=adj,srt=srt)
}

#' Splits numetic vector into equally sized bins
#'
#' @param v vector to be splitted
#' @param n number of bins
#'
#' @return numeric vector win bin number (same length as \code{v})
#' @export
number2bin = function(v,n){
  o = order(v)
  j = 1
  for(i in 1:length(v)){
    if(j < i/length(v)*n)
      j = j + 1
    v[o[i]] = j
  }
  v
}

#' Calculates row sums for matrix subsets
#'
#' @param d matrix
#' @param f character vector, factor to split matrix columns (length should be equal to nrow(d))
#' @param FUN function to be applied to matrix slices (mean by default)
#' @param verbose
#'
#' @return matrix with number of rows equal to nrow(d) and number of columns equal to number of unique(f)
#' @export
calcMeanCols = function(d,f,FUN=base::mean,verbose=FALSE){
  u = sort(unique(as.character(f)))
  r = matrix(ncol=length(u),nrow=nrow(d))
  colnames(r) = u
  rownames(r) = rownames(d)
  for(j in 1:length(u)){
    i = u[j]
    if(verbose) cat('\r',j,' from ',length(u),'; ',i,'      ')
    r[,i] = apply(d[,f==i,drop=F],1,FUN,na.rm=TRUE)
  }
  r
}

#' Add panel label
#'
#' Adds letter into top left corner of the plot
#'
#' @param l letter to be added
#' @param cex letter size
#' @param adj see adj parameter of \code{\link{text}}
#' @param ... other parameters for text function
#'
#' @return
#' @export
plotPanelLetter = function(l,cex=1.2,adj=c(0,1.1),...){
  x=grconvertX(0,from='nfc',to='user')
  y=grconvertY(1,from='nfc',to='user')
  text(x=x,y=y,labels=l,adj=adj,font=2,cex=cex,xpd=NA)
}

#' Line with confidence interval
#'
#' CI is shown by area
#'
#' @param x x coordinates
#' @param p y coordinates. Matrix with two (mean and sd) or three (mean, lower CI bound, higher CI bound) columns
#' @param col line and area colour
#' @param sd.mult coefficient to multiply sd to get CI
#' @param new make ne plot (default is to add line on existed plot)
#' @param ylim,xlim see \code{\link{plot}}
#' @param area.transp alpha for CI area
#' @param type type of \code{\link{plot}}
#' @param area.den density of \code{\link{polygon}}
#' @param cilim numerical vector with two values, gives lower and apper values to truncate CI. NULL (to truncation) by default.
#' @param ...
#'
#' @return
#' @export
plotArea = function(x,p,col,sd.mult=2,new=FALSE,ylim=NULL,xlim=range(x),area.transp=0.2,type='l',area.den=-1,cilim=NULL,...){
  #p should contain either mean and sd
  #or mean, lower and upper bounds
  o = order(x)
  x = x[o]
  p = p[o,,drop=F]
  na = !is.na(p[,1])
  x = x[na]
  p = p[na,,drop=F]
  if(ncol(p)==2)
    yp = c(p[,1]-p[,2]*sd.mult,rev(p[,1]+p[,2]*sd.mult))
  else
    yp = c(p[,2],rev(p[,3]))
  if(!is.null(cilim))
    yp = pmin(pmax(yp,cilim[1]),cilim[2])
  if(new){
    if(is.null(ylim))
      ylim = range(yp,na.rm=T)
    plot(1,t='n',xlim=xlim,ylim=ylim,...)
  }
  col.pol = col2rgb(col,alpha=TRUE)/255
  col.pol = rgb(col.pol[1],col.pol[2],col.pol[3],col.pol[4]*area.transp)
  polygon(c(x,rev(x)),yp,col=col.pol,border=NA,den=area.den)
  lines(x,p[,1],col=col,type=type,...)
}

#' Plots matrix as dotPlot
#'
#' Shows values in matix by point size and color
#'
#' @param m numeric matrix to be shown
#' @param rfun function to calculate radius from matrix values. Use sqrt (default) to make area proportional to value
#' @param colfun function to transform values to colour gradient
#' @param grid logial, should grid be plotted
#' @param grid.lty lty of grid
#' @param grid.col line color of grid
#' @param max.cex max size of dots
#' @param xlab,ylab axis labels
#' @param ylab.cex magnification label for ylabs
#' @param colColours colour matrix to plot annotation for columns (matrix with nrow equal to ncol(m); each column of colColours is annotation)
#' @param rowColours colour matrix to plot annotation for row (matrix with nrow equal to nrow(m); each column of rowColours is annotation)
#' @param scaleWM logical, specifies wheter computed radiuses should be scaled into [0,1] interval
#' @param pch point character (19 by default)
#' @param ... other parameters to be passed to plot function
#'
#' @return
#' @export
dotPlot = function(m,rfun=sqrt,colfun=function(x)num2col(x,c('white','yellow','violet','black')),grid=TRUE,grid.lty=2,grid.col='gray',
                   max.cex=0.9,xlab='',ylab='',ylab.cex=1,xlab.cex=1,colColours=NULL,rowColours=NULL,scaleWM=TRUE,pch=19,...){
  x = rep(1:ncol(m),each=nrow(m))
  y = rep(nrow(m):1,times=ncol(m))

  xlim=c(0,max(x)+1)
  ylim=c(0,max(y)+1)

  if(!is.null(colColours)){
    if(!is.array(colColours))
      colColours = matrix(colColours,ncol=1)
    ylim[1] = -ncol(colColours)
  }

  if(!is.null(rowColours)){
    if(!is.array(rowColours))
      rowColours = matrix(rowColours,ncol=1)
    xlim[1] = -ncol(rowColours)
  }


  plot(1,t='n',xaxt='n',yaxt='n',xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,yaxs='i',xaxs='i',...)
  if(grid){
    abline(v=1:ncol(m),lty=grid.lty,col=grid.col)
    abline(h=1:nrow(m),lty=grid.lty,col=grid.col)
  }
  wh = par('cin')
  # sym.size=max(c(grconvertX(wh[1],'in','user')-grconvertX(0,'in','user'),grconvertY(wh[2],'in','user')-grconvertY(0,'in','user')))
  # r = scaleTo(rfun(m))/sym.size*max.cex
  r = rfun(m)
  if(scaleWM)
    r = scaleTo(r)
  r = r*max.cex
  points(x,y,cex=r,col=colfun(m),pch=pch)

  # add col annotation
  if(!is.null(colColours)){
    for(i in 1:ncol(colColours))
      for(j in 1:nrow(colColours)){
        rect(j-0.5,0-i,j+0.5,1-i,border = NA,col=colColours[j,i])
      }

    if(!is.null(colnames(colColours))){
      text(nrow(colColours)+1,-(1:ncol(colColours))+0.5,colnames(colColours),adj=c(0,0.5),xpd=T)
    }
  }

  # add row annotation
  if(!is.null(rowColours)){
    for(i in 1:ncol(rowColours))
      for(j in 1:nrow(rowColours)){
        rect(0-i,nrow(rowColours)-j+1.5,1-i,nrow(rowColours)-j+0.5,border = NA,col=rowColours[j,i])
      }
    if(!is.null(colnames(rowColours))){
      text(-(1:ncol(rowColours))+0.5,0,colnames(rowColours),srt=90,adj=c(1,0.5),xpd=T)
    }
  }
  if(par('xaxt')=='s'){
    par.out = par(cex=xlab.cex)
    axis(1,1:ncol(m),colnames(m))
    do.call(par,par.out)
  }
  if(par('yaxt')=='s'){
    par.out = par(cex=ylab.cex)
    axis(2,nrow(m):1,rownames(m))
    do.call(par,par.out)
  }
}


#' Plots scatterplot with regression line
#'
#' Wrapper for pllot function
#'
#' @param x,y coordinates
#' @param cor.method pearson (default) or spearman
#' @param line.col colour of line
#' @param line.lwd line width
#' @param plot.ci logical, should CI be plotted
#' @param ci.transparency alpha of CI area
#' @param line.on.top logical, should line be on the top of points
#' @param new logical, create new plot (default) or add to existing
#' @param ... other arguments for plot function
#'
#' @return
#' @export
plotLine = function(x,y=NULL,cor.method='pearson',line.col='red',line.lwd=1,plot.ci=FALSE,ci.transparency=0.3,line.on.top=TRUE,new=TRUE,...){
  if(is.null(y)){
    y = x[,2]
    x = x[,1]
  }
  if(new)
    plot(x,y,t='n',...)
  if(line.on.top)
    points(x,y,...)
  f = !is.na(x) & !is.na(y) & !is.infinite(x) &  !is.infinite(y)
  x = x[f]
  y = y[f]
  o = order(x)
  y = y[o]
  x = x[o]
  x = as.numeric(x)
  y = as.numeric(y)
  m = lm(y~x)
  ci=predict.lm(m,interval='confidence')
  if(plot.ci){
    c=col2rgb(line.col)
    polygon(c(x,rev(x)),c(ci[,2],rev(ci[,3])),border=NA,col=rgb(c[1],c[2],c[3],ci.transparency*255,maxColorValue = 255))
  }
  lines(x,ci[,1],col=line.col,lwd=line.lwd)
  if(!line.on.top)
    points(x,y,...)
  if(tolower(cor.method)==substr('spearman',1,nchar(cor.method))){
    x = rank(x)
    y = rank(y)
    cor.method = 'pearson'
  }
  c = cor.test(x,y,m=cor.method)
  ci = round(c$conf.int,2)
  leg=paste(toupper(substr(cor.method,1,1)),'CC=',round(c$estimate,2),' [',ci[1],',',ci[2],']\npv=',format(c$p.value,digits=2,scientific=TRUE),'\nN=',length(x),sep='')
  text(grconvertX(0.01,'npc','user'),grconvertY(0.99,'npc','user'),leg,col=line.col,adj=c(0,1),font=2)
}

#' Rename cluster by size
#'
#' Gives larger clusters smaller index
#'
#' @param x clustering, numeric vector with membership (as returned by cutree for instance)
#'
#' @return numeric cluster with new membership
#' @export
renameClustsBySize = function(x){
  t = table(x)
  n = names(t)
  o = order(t,decreasing=T)
  r = x
  for(i in 1:length(o))
    r[x == n[o[i]]] = i
  r
}

#' Scale numeric vector
#'
#' @param x numeric vector to be scaled
#' @param from,to target range
#' @param minx,maxx true min of "real x" (in case if given x is just subset of the real)
#' @param fraction fraction of target range to be used
#'
#' @return
#' @export
scaleTo = function(x,from=0,to=1,minx=min(x,na.rm=TRUE),maxx=max(x,na.rm=TRUE),fraction=1){
  x = (x-minx)/(maxx-minx)
  x*(to-from)*fraction + from + (to-from)*(1-fraction)/2
}

#' Extract read coverage from bam files
#'
#' @param bams character vector with paths to bam files
#' @param chr contig name
#' @param start,end coordinates of region
#' @param strand strand, NA for unstranded (default)
#'
#' @return list with three items: x (chr coordinates); cov - number of reads mapped to chr position; juncs - data.frame with introns
#' @export
getReadCoverage = function(bams,chr,start,end,strand=NA){
  require(GenomicAlignments)
  if(start>end){
    t = start
    start = end
    end=t
  }
  r = list(x = start:end,cov = NULL,juncs=NULL)
  param = ScanBamParam(flag=scanBamFlag(isMinusStrand=strand==-1),which=GRanges(chr, IRanges(start, end)))
  i = 1
  for(b in bams){
    cat('\r',i,'     ')
    i = i + 1
    bam = readGAlignments(b,param = param)
    cov=coverage(bam)[[chr]][start:end]
    juncs = as.data.frame(summarizeJunctions(bam))
    rownames(juncs)=paste(juncs$seqnames,juncs$start,juncs$end,sep='-')
    if(is.null(r$cov)){
      r$cov=cov
      r$juncs=juncs
    }else{
      r$cov = r$cov + cov
      cmn = intersect(rownames(juncs),rownames(r$juncs))
      r$juncs[cmn,'score'] = r$juncs[cmn,'score'] + juncs[cmn,'score']
      r$juncs = rbind(r$juncs,juncs[setdiff(rownames(juncs),rownames(r$juncs)),])
    }
  }
  invisible(r)
}

#' Plots read coverage
#'
#' @param r read coverage; output of \code{\link{getReadCoverage}}
#' @param min.junc.cov numeric, plots only junctions (introns) with coverage not less than \code{min.junc.cov}
#' @param plot.junc.only.within logical, plot only juctions within the region
#' @param ylim,xlim see \code{\link{plot}}
#' @param reverse reverse x coordinates
#' @param junc.col colour for junction line
#' @param junc.lwd line width for jucntion line
#' @param ... other parameters for plot function
#'
#' @return
#' @export
plotReadCov = function(r,min.junc.cov=0,plot.junc.only.within=FALSE,ylim=NULL,xlim=range(r$x),reverse=FALSE,junc.col='red',junc.lwd=3,...){
  f = r$x >= xlim[1] & r$x <=xlim[2]
  r$x = r$x[f]
  r$cov = r$cov[f]
  r$juncs = r$juncs[r$juncs$start <= xlim[2] | r$juncs$end >=xlim[1],]

  start = r$x[1]
  end = r$x[length(r$x)]
  r$cov[c(1,length(r$cov))] = 0
  if(is.null(ylim))
    ylim = c(0,max(r$cov,r$juncs$score))
  if(reverse)
    xlim=rev(xlim)
  plot(r$x,r$cov,t='n',ylim=ylim,xlim=xlim,...)
  polygon(r$x,r$cov,col = 'gray',border=NA)
  if(nrow(r$juncs)>0)
    for(i in 1:nrow(r$juncs))
      if(r$juncs$score[i] >= min.junc.cov & (!plot.junc.only.within || (r$juncs$start[i] > min(xlim) & r$juncs$end[i]< max(xlim))))
        plotArc(r$juncs$start[i],r$juncs$end[i],r$juncs$score[i],col=junc.col,lwd=junc.lwd)
}

#' Plots parabolic arc
#'
#' @param from,to x coordinates of arc
#' @param top highest point of arc
#' @param n number of points
#' @param y.base bottom coordinate of arc
#' @param ... other parameters of lines functoin
#'
#' @return
plotArc = function(from,to,top,n=100,y.base=0,...){
  len = to - from
  x = seq(from=0,to=len,length.out = n)
  y = x*4*top/len - x^2*(4*top/len^2)
  lines(x+from,y+y.base,...)
}

#' Capitalize first letter of input text
#'
#' @param t character vector
#'
#' @return t with first letter of each item capitalized
#' @export
first2Upper = function(t){
  paste0(toupper(substr(t,1,1)),substr(t,2,nchar(t)))
}
