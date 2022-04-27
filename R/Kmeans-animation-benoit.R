kmeans.benoit <- function (x = cbind(X1 = runif(50), X2 = runif(50)), centers = 3, 
          hints = c("", ""), pch = 1:3, col = 1:3) 
{
  x = as.matrix(x)
  ocluster = sample(centers, nrow(x), replace = TRUE)
  if (length(centers) == 1) 
    centers = x[sample(nrow(x), centers), ]
  else centers = as.matrix(centers)
  numcent = nrow(centers)
  dst = matrix(nrow = nrow(x), ncol = numcent)
  j = 1
  pch = rep(pch, length = numcent)
  col = rep(col, length = numcent)
  for (j in 1:ani.options("nmax")) {
    dev.hold()
    if(j==1){plot(x, pch = 4, col = col[ocluster], main="Mean computation",panel.first = grid())
      text(-0.3, 1.35, "Initialization",cex=1.5, col="blue")
    }
    if(j==2){plot(x, pch = pch[ocluster], col = col[ocluster], main="", panel.first = grid())}
      
    if(j>2){plot(x, pch = pch[ocluster], col = col[ocluster], panel.first = grid())}
     
    
    mtext(hints[1], 4)
    points(centers, pch = pch[1:numcent], cex = 3, lwd = 2, 
           col = col[1:numcent])
    ani.pause()
    for (i in 1:numcent) {
      dst[, i] = sqrt(apply((t(t(x) - unlist(centers[i, 
      ])))^2, 1, sum))
    }
    ncluster = apply(dst, 1, which.min)
    if(j==1){plot(x, main="Labelling", type = "n")}else{
      if(j==3){
        plot(x, type = "n")
        text(-0.3, 1.35, "Cluster output",cex=1.5, col="blue")
      }else{plot(x, type = "n")}}
    mtext(hints[2], 4)
    grid()
    ocenters = centers
    for (i in 1:numcent) {
      xx = subset(x, ncluster == i)
      polygon(xx[chull(xx), ], density = 10, col = col[i], 
              lty = 2)
      points(xx, pch = pch[i], col = col[i])
      centers[i, ] = apply(xx, 2, mean)
    }
    points(ocenters, cex = 3, col = col[1:numcent], pch = pch[1:numcent], 
           lwd = 2)
    ani.pause()
    if (all(centers == ocenters)) 
      break
    ocluster = ncluster
  }
  invisible(list(cluster = ncluster, centers = centers))
}