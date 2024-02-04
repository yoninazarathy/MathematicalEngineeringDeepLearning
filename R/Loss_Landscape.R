set.seed(101)
n <- 1000
x1 <- rnorm(n,2,sd=2)
x2 <-rnorm(n,1,sd=1)
#x2 <-rnorm(n,x1-3,sd=2)
y <- 2*x1+0.5*x2+rnorm(n,sd=0.01)


cor(x1,x2)

lm.mod <- lm.mod <- lm(y~-1+x1+x2)
theta.hat <- lm.mod$coef
X <-as.matrix(cbind(x1,x2))
y <- matrix(y,ncol=1)
cost <- 0.5*mean((X%*%matrix(theta.hat,ncol=1)-y)**2)
cost


Cost.fct <- function(theta0,theta1) {
  theta <- c(theta0,theta1)
  X <-as.matrix(cbind(x1,x2))
  y <- matrix(y,ncol=1)
  cost <- 0.5*mean((X%*%matrix(theta,ncol=1)-y)**2)
  return(cost)
}

Cost.fct.norm <- function(theta0,theta1) {
  theta <- c(theta0,theta1)
  x1 <- scale(x1)
  x2 <- scale(x2)
  X <-as.matrix(cbind(x1,x2))
  y <- matrix(y,ncol=1)
  cost <- 0.5*mean((X%*%matrix(theta,ncol=1)-y)**2)
  return(cost)
}



#par(mfrow=c(1,2))
theta0 <- seq(-20, 20, 0.1)
theta1 <- seq(-20, 20, 0.1)
cost <- outer(theta0, theta1, function(x,y) mapply(Cost.fct,x,y))
pdf(file="normalized-input-a-new.pdf", height=10, width=10)
par(cex.axis=2,mar=c(5,5,2,2) + 0.1)
contour(x = theta0, y = theta1, cex.lab=2,ylab=expression(w[2]),xlab=expression(w[1]),nlevel=20,z = cost,labcex=1)
dev.off()


theta0 <- seq(-20, 20, 0.5)
theta1 <- seq(-20, 20, 0.5)
cost <- outer(theta0, theta1, function(x,y) mapply(Cost.fct.norm,x,y))
pdf(file="normalized-input-b-new.pdf", height=10, width=10)
par(cex.axis=2,mar=c(5,5,2,2) + 0.1)
contour(x = theta0, y = theta1, cex.lab=2,ylab=expression(tilde(w)[2]),xlab=expression(tilde(w)[1]),nlevel=20,z = cost,labcex=1)
#contour(x = theta0, y = theta1,nlevel=20,z = cost,labcex=1)


dev.off()


