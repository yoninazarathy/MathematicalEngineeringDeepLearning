###
library(dplyr)
library(caret)
### Sigmoid function
sigmoid <- function(z)
{
  g <- 1/(1+exp(-z))
  return(g)
}

#Cost Function
loss.f <- function(theta,X,Y)
{
  m <- nrow(X)
  g <- sigmoid(X%*%matrix(theta,ncol=1))
  g[g==1]<- 1-0.0000001
  g[g==0]<- 0.0000001
  J <- (1/m)*sum((-Y*log(g)) - ((1-Y)*log(1-g)))
  return(J)
}

class.pred <- function(theta,X){
  m <- nrow(X)
  g <- sigmoid(X%*%matrix(theta,ncol=1))
  pred <- ifelse(g < 0.5, 0, 1)
  pred <- factor(pred,levels = c(0,1))
  return(pred)
}


# Gradient of the loss function
grad <- function(x, y, theta) {
  gradient <- (1 / nrow(y)) * (t(x) %*% (1/(1 + exp(-x %*% t(theta))) - y))
  return(t(gradient))
}






gradient.descent <- function(x, y, alpha=0.1,lambda=0, num.iterations=500, threshold=1e-6,datatest,scaled=TRUE) {
  
  y_true_test <- as.matrix(datatest[,dim(datatest)[2]])
  
  
  x_test <- as.matrix(datatest[,-dim(datatest)[2]])
  x <- apply(x, 2, as.numeric)
  
  if(!is.null(scaled)){
    scaleX <-scale(x[,-1]) 
    x <- cbind(rep(1,nrow(x)),scaleX)
    x_test <- cbind(rep(1,nrow(x_test)),scale(x_test[,-1],center=attr(scaleX,"scaled:center"),scale=attr(scaleX,"scaled:scale")))
  }
  
  num.features <- ncol(x)
  
  # Initialize the parameters
  theta <- matrix(rep(0.1, num.features), nrow=1)
  loss_train <- loss.f(theta,X=x,Y=y)
  loss_test <- loss.f(theta,X=x_test,Y=y_true_test)
  y_pred_train <- class.pred(theta,X=x)
  y_pred_test <- class.pred(theta,X=x_test)
  resulttrain <- confusionMatrix(y_pred_train, factor(y))
  resulttest <- confusionMatrix(y_pred_test, factor(y_true_test))
  
  F1_train <- resulttrain$byClass[7] 
  F1_test <- resulttest$byClass[7] 
  theta.path <- theta
  for (i in 1:num.iterations) {
    gradtheta <- grad(x, y, theta)
    theta <- theta - alpha * (gradtheta+lambda*theta)
    loss_train <- c(loss_train,loss.f(theta,X=x,Y=y))
    loss_test <- c(loss_test,loss.f(theta,X=x_test,Y=y_true_test))
    y_pred_train <- class.pred(theta,X=x)
    y_pred_test <- class.pred(theta,X=x_test)
    
    resulttrain <- confusionMatrix(y_pred_train, factor(y))
    resulttest <- confusionMatrix(y_pred_test, factor(y_true_test))
    
    F1_train <- c(F1_train,resulttrain$byClass[7] )
    F1_test <- c(F1_test,resulttest$byClass[7] )
    
    if(all(is.na(theta))) break
    theta.path <- rbind(theta.path, theta)
    if(i > 2) if(sqrt(sum((theta - theta.path[i-1,])**2)) < threshold) break 
    if(i > 2) if(mean(gradtheta**2)< 1e-10) break 
    
  }
  result <- list(theta.path=theta.path,F1_train=F1_train,F1_test=F1_test,loss_test=loss_test,loss_train=loss_train,theta.opt=theta.path[nrow(theta.path),],Niter=i)
}

#####
## Function to come back to unscaled logistic model
#####


back_transform <- function(X,theta){
  sd.X <- apply(X,2,FUN=function(x) sd(x))
  mean.X <- colMeans(X)
  theta.unscaled <- rep(0,length(theta))
  theta.unscaled[-1] <- theta[-1]/sd.X[-1]
  theta.unscaled[1] <- theta[1]-sum(mean.X[-1]*theta.unscaled[-1])
  return(theta.unscaled)
}

