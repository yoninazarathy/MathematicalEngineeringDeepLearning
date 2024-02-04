clr1 <- c(rgb(1,0,0,1),rgb(0,1,0,1),rgb(0,0,1,1),rgb(0.5,0.5,0.5,1))
clr2 <- c(rgb(1,0,0,.1),rgb(0,1,0,.1),rgb(0,0,1,.1),rgb(0.5,0.5,0.5,.5))
x <- c(.4,.55,.65,.9,.1,.35,.5,.15,.2,.85,0.2,0.7,0.3,0.5,0.6,0.55,0.4)
y <- c(.85,.95,.8,.87,.5,.55,.5,.2,.1,.3,0.7,0.5,0.3,0.7,0.6,0.65,0.7)
z <- c(1,2,2,2,1,0,0,1,0,0,1,2,1,3,3,3,3)
df <- data.frame(x,y,z)
plot(x,y,pch=19,cex=2,col=clr1[z+1],ylab=expression(x[2]),xlab=expression(x[1]),cex.lab=1.4)
#save(df,file="data-sarat.Rdata")
library(nnet)
model.mult <- multinom(z~x+y,data=df)

pred_mult <- function(x,y){
  res <- predict(model.mult,
                 newdata=data.frame(x=x,y=y),type="probs")
  apply(res,MARGIN=1,which.max)
}
x_grid<-seq(0,1,length=601)
y_grid<-seq(0,1,length=601)
z_grid <- outer(x_grid,y_grid,FUN=pred_mult)

#pdf("Figure-boundary-softmax.pdf", width = 10, height = 8)
#pdf("../../../figures/chapter_3_figures/boundary-softmax.pdf", width = 8, height = 6)

image(x_grid,y_grid,z_grid,col=clr2,ylab=expression(x[2]),xlab=expression(x[1]),cex.lab=1.4)

points(x,y,pch=19,cex=2,col=clr1[z+1])
legend("topleft", inset=0.02, legend=c("class 1", "class 2","class 3","class 4"),
       col=clr1[c(1,3,2,4)], cex=0.9, pch=c(19,19))
dev.off()


library(nnet)
model.mult <- multinom(z~polym(x,y, degree=2, raw=TRUE),data=df)

pred_mult <- function(x,y){
  res <- predict(model.mult,
                 newdata=data.frame(x=x,y=y),type="probs")
  apply(res,MARGIN=1,which.max)
}
x_grid<-seq(0,1,length=601)
y_grid<-seq(0,1,length=601)
z_grid <- outer(x_grid,y_grid,FUN=pred_mult)

#pdf("Figure-boundary-softmax-NL-degree2.pdf", width = 10, height = 8)
#pdf("../../../figures/chapter_3_figures/boundary-softmax-degree2.pdf", width = 8, height = 6)

image(x_grid,y_grid,z_grid,col=clr2,ylab=expression(x[2]),xlab=expression(x[1]),cex.lab=1.4)

points(x,y,pch=19,cex=2,col=clr1[z+1])
legend("topleft", inset=0.02, legend=c("class 1", "class 2","class 3","class 4"),
       col=clr1[c(1,3,2,4)], cex=0.9, pch=c(19,19))

dev.off()





library(nnet)
model.mult <- multinom(z~polym(x,y, degree=8, raw=TRUE),data=df)

pred_mult <- function(x,y){
  res <- predict(model.mult,
                 newdata=data.frame(x=x,y=y),type="probs")
  apply(res,MARGIN=1,which.max)
}
x_grid<-seq(0,1,length=601)
y_grid<-seq(0,1,length=601)
z_grid <- outer(x_grid,y_grid,FUN=pred_mult)

#pdf("Figure-boundary-softmax-NL-degree8.pdf", width = 10, height = 8)
pdf("../../../figures/chapter_3_figures/boundary-softmax-degree8.pdf", width = 8, height = 6)

image(x_grid,y_grid,z_grid,col=clr2,ylab=expression(x[2]),xlab=expression(x[1]),cex.lab=1.4)

points(x,y,pch=19,cex=2,col=clr1[z+1])
legend("topleft", inset=0.02, legend=c("class 1", "class 2","class 3","class 4"),
       col=clr1[c(1,3,2,4)], cex=0.9, pch=c(19,19))

dev.off()


