library(animation)
## set larger 'interval' if the speed is too fast
#ani.options(interval = 1)
#par(mar = c(3, 3, 1, 1.5), mgp = c(1.5, 0.5, 0))
#kmeans.ani()

# To reproduce our example you need to source the following code
source("Kmeans-animation-benoit.R")


par(mfrow=c(3,2))
ani.options('6')

pdf(file="Kmeans-algo.pdf", height=10, width=10)
#par(mar = c(5.1, 5.1, 4.1, 2.1))
par(mfrow=c(3,2))
set.seed(101)
library(mvtnorm)
x = rbind(rmvnorm(40, mean=c(0,1),sigma = 0.05*diag(2)),rmvnorm(40, mean=c(0.5,0),sigma = 0.05*diag(2)),rmvnorm(40, mean=c(1,1),sigma = 0.05*diag(2)))
par(mfrow=c(3,2))
colnames(x) = c("x1", "x2")
kmeans.benoit(x, centers = matrix(c(0.5,1,0.5,0,1,1),byrow=T,ncol=2))
dev.off()
