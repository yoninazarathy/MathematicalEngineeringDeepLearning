## ----setup, include=FALSE----------------------------------------------
knitr::opts_chunk$set(echo = TRUE,message = NA,comment = NA)
library(knitr)


## ----eval=FALSE--------------------------------------------------------
install.packages("keras")


## ----------------------------------------------------------------------
library(keras)
fashion <- dataset_fashion_mnist()


## ----------------------------------------------------------------------
class(fashion$train)
names(fashion$train)
class(fashion$train$x)
class(fashion$train$y)
dim(fashion$train$x)


## ----------------------------------------------------------------------
rotate <- function(x) t(apply(x, 2, rev))
# Function to plot image from a matrix x
plot_image <- function(x, title = "", title.color = "black") {
  image(rotate(x), axes = FALSE,
        col = grey(seq(0, 1, length = 255)),
        main = list(title, col = title.color))
}
plot_image(fashion$train$x[1,,])


## ----------------------------------------------------------------------
clothes.labels <-c( "T-shirt/top", "Trouser", "Pullover", "Dress", "Coat",
                    "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot")


## ----------------------------------------------------------------------
clothes.labels[as.numeric(fashion$train$y[1])+1]


## ----------------------------------------------------------------------
plot_image(fashion$train$x[1,,],clothes.labels[as.numeric(fashion$train$y[1])+1])



## ----echo=FALSE--------------------------------------------------------
plot_image(fashion$train$x[2,,],clothes.labels[as.numeric(fashion$train$y[2])+1])


## ----------------------------------------------------------------------
table(fashion$train$y)


## ----echo=FALSE--------------------------------------------------------
table(fashion$test$y)


## ----cache=TRUE,cache.path='cache/'------------------------------------
MNIST <- dataset_mnist()


## ----------------------------------------------------------------------
dim(MNIST$train$x)
dim(MNIST$train$y)
dim(MNIST$test$x)
dim(MNIST$test$y)


## ----------------------------------------------------------------------
MNIST$train$x <- MNIST$train$x/255
MNIST$test$x <- MNIST$test$x/255


## ----------------------------------------------------------------------
table(MNIST$train$y)

## ----------------------------------------------------------------------
table(MNIST$test$y)


## ----------------------------------------------------------------------
res.mean <- NULL
for(i in 0:9){
res.mean <- c(res.mean,mean(MNIST$train$x[which(MNIST$train$y==i),,]))  
}
res.mean.train <- res.mean
res.mean.train


## ----------------------------------------------------------------------
res.mean <- NULL
for(i in 0:9){
res.mean <- c(res.mean,mean(MNIST$test$x[which(MNIST$test$y==i),,]))  
}
res.mean.test <- res.mean
res.mean.test


## ----------------------------------------------------------------------
library(ggplot2)
data.res <- data.frame(meanPixel=c(res.mean.train,res.mean.test),set=rep(c("train","test"),each=10),digit=rep(0:9,2))
data.res$digit<-as.factor(data.res$digit)
ggplot(data=data.res,aes(x=digit,y=meanPixel,fill=set))+
  geom_bar(stat="identity", position=position_dodge())


## ----echo=FALSE--------------------------------------------------------
fashion$train$x <- fashion$train$x/255
fashion$test$x <- fashion$test$x/255


## ----echo=FALSE--------------------------------------------------------
res.mean <- NULL
for(i in 0:9){
res.mean <- c(res.mean,mean(fashion$train$x[which(fashion$train$y==i),,]))  
}
res.mean.train <- res.mean
res.mean.train


## ----echo=FALSE--------------------------------------------------------
res.mean <- NULL
for(i in 0:9){
res.mean <- c(res.mean,mean(fashion$test$x[which(fashion$test$y==i),,]))  
}
res.mean.test <- res.mean
res.mean.test


## ----echo=FALSE--------------------------------------------------------
library(ggplot2)
data.res <- data.frame(meanPixel=c(res.mean.train,res.mean.test),set=rep(c("train","test"),each=10),clothes=rep(clothes.labels,2))
data.res$clothes<-as.factor(data.res$clothes)
ggplot(data=data.res,aes(x=clothes,y=meanPixel,fill=set))+
  geom_bar(stat="identity", position=position_dodge()) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


## ----------------------------------------------------------------------
postiveTrain <- MNIST$train$x[which(MNIST$train$y==3),,]
dim(postiveTrain)[1]
negativeTrain <- MNIST$train$x[which(MNIST$train$y==8),,]
dim(negativeTrain)[1]


## ----------------------------------------------------------------------
vec.image1 <- c(postiveTrain[1,,])
vec.image1[1:20]
length(vec.image1)


## ----------------------------------------------------------------------
dim(postiveTrain)
matPosTrain <- matrix(NA,nrow=dim(postiveTrain)[1],ncol=dim(postiveTrain)[2]*dim(postiveTrain)[3])
for (i in 1:dim(postiveTrain)[1]){
  matPosTrain[i,] <- c(postiveTrain[i,,])
}
dim(matPosTrain)


## ----------------------------------------------------------------------
image(rotate(matPosTrain))


## ----------------------------------------------------------------------
dim(negativeTrain)
matNegTrain <- matrix(NA,nrow=dim(negativeTrain)[1],ncol=dim(negativeTrain)[2]*dim(negativeTrain)[3])
for (i in 1:dim(negativeTrain)[1]){
  matNegTrain[i,] <- c(negativeTrain[i,,])
}
dim(matNegTrain)


## ----------------------------------------------------------------------
A <- rbind(matPosTrain,matNegTrain)
dim(A)


## ----------------------------------------------------------------------
A <- cbind(rep(1,dim(A)[1]),A)
dim(A)


## ----------------------------------------------------------------------
library(MASS)
y <- matrix(rep(c(1,-1),times=c(dim(matPosTrain)[1],dim(matNegTrain)[1])),ncol=1)
A.inv <- ginv(A)
beta <- A.inv%*%y
beta[1:20]


## ----------------------------------------------------------------------
plot(beta,xlab="Index",ylab="value",type="h")


## ----------------------------------------------------------------------
classsify <- function(x,beta) ifelse(sum(c(1,x)*beta)>0,1,-1)


## ----------------------------------------------------------------------
classsify(postiveTrain[1,,],beta)
classsify(negativeTrain[1,,],beta)


## ----------------------------------------------------------------------
positiveTest <- MNIST$test$x[which(MNIST$test$y==3),,]
(nPosTest <- dim(positiveTest)[1])
negativeTest <- MNIST$test$x[which(MNIST$test$y==8),,]
(nNegTest <- dim(negativeTest)[1])


## ----------------------------------------------------------------------
res.pos <- NULL
for(i in 1:dim(positiveTest)[1]){
  res.pos <- c(res.pos,classsify(positiveTest[i,,],beta))
}
table(res.pos)
truePositives <- table(res.pos)[2]
truePositives


## ----------------------------------------------------------------------
res.neg <- NULL
for(i in 1:dim(negativeTest)[1]){
  res.neg <- c(res.neg,classsify(negativeTest[i,,],beta))
}
table(res.neg)
trueNegatives <- table(res.neg)[1]
trueNegatives


## ----echo=FALSE--------------------------------------------------------
(falsePositives = nNegTest - trueNegatives)
(falseNegatives = nPosTest - truePositives)


## ----echo=FALSE--------------------------------------------------------
(precision <- truePositives/(truePositives+falsePositives))


## ----echo=FALSE--------------------------------------------------------
(recall <- truePositives/(truePositives+falseNegatives))


## ----echo=FALSE--------------------------------------------------------
(F1 = 1/mean(c(1/precision,1/recall))) #This is the harmonic mean


## ----cache=TRUE,cache.path='cache/'------------------------------------
CIFAR10 <- dataset_cifar10()


## ----------------------------------------------------------------------
x_train <- CIFAR10$train$x/255
x_test  <- CIFAR10$test$x/255
y_train <- keras::to_categorical(CIFAR10$train$y, num_classes = 10)
y_test  <- keras::to_categorical(CIFAR10$test$y,  num_classes = 10)
label_name = c("flyer", "car", "bird", "cat", "deer", "dog", "frog ", "horse", "ship", "truck")
label_name
dim(x_train)
dim(x_test)
table(CIFAR10$train$y)


## ----------------------------------------------------------------------
library(EBImage)
pictures = c(9802, 5, 7, 10, 4, 28,1, 8, 9, 2)

fig_img  = list()
for (i in 1:10 ) {
  fig_mat  = CIFAR10$train$x[pictures[i], , , ]
  fig_img[[i]]  = normalize(Image(transpose(fig_mat), dim=c(32,32,3), colormode='Color'))
}
fig_img_comb = combine(fig_img[1:10])
fig_img_obj = tile(fig_img_comb,5)
plot(fig_img_obj, all=T)


## ----------------------------------------------------------------------
CIFAR10$train$y[1]
label_name[CIFAR10$train$y[1]+1]


## ----------------------------------------------------------------------
plot(normalize(Image(transpose(x_train[1,,,]), dim=c(32,32,3), colormode='Color')))


## ----------------------------------------------------------------------
temp <- x_train[1,,,]/255
image(rotate(temp[,,1]),axes=FALSE,col = rgb((0:10)/10,0,0))


## ----------------------------------------------------------------------
image(rotate(temp[,,2]),axes=FALSE,col = rgb(0,(0:10)/10,0))


## ----------------------------------------------------------------------
image(rotate(temp[,,3]),axes=FALSE,col = rgb(0,0,(0:10)/10))


## ----------------------------------------------------------------------
ind.frog <- which(CIFAR10$train$y==6)
length(ind.frog)


## ---- fig.show='animate', ffmpeg.format='gif',dev='jpeg'---------------
for (i in ind.frog[1:5]){
 plot(normalize(Image(transpose(x_train[i,,,]), dim=c(32,32,3), colormode='Color')))
  text(20,20,label_name[CIFAR10$train$y[i]+1],col="red",lty=2,lwd=10,cex=5)
  }


## ---- fig.show='animate', ffmpeg.format='gif',dev='jpeg',echo=FALSE----
for (i in 1:100){
 plot(normalize(Image(transpose(x_train[i,,,]), dim=c(32,32,3), colormode='Color')))
  text(20,20,label_name[CIFAR10$train$y[i]+1],col="red",lty=2,cex=5)
  }

