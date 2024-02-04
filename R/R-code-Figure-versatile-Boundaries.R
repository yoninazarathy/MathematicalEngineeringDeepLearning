N <- 400 # number of points per class
D <- 2 # dimensionality
K <- 2 # number of classes
X <- data.frame() # data matrix (each row = single example)
Y <- data.frame() # class labels
set.seed(308)
for (j in (1:2)) {
  r <- seq(0.05, 1, length.out = N) # radius
  t <- seq((j - 1) * 4.7, j * 4.7, length.out = N) + rnorm(N,
                                                           sd = 0.3) # theta
  Xtemp <- data.frame(x = r * sin(t), y = r * cos(t))
  ytemp <- data.frame(matrix(j, N, 1))
  X <- rbind(scale(X), Xtemp)
  Y <- rbind(Y, ytemp)
}
data <- cbind(X, Y)
colnames(data) <- c(colnames(X), "label")
x_min <- min(X[, 1]) - 0.2
x_max <- max(X[, 1]) + 0.2
y_min <- min(X[, 2]) - 0.2
y_max <- max(X[, 2]) + 0.2




library(ggplot2)
ggplot(data) + geom_point(aes(x = x,y = y,color = as.character(label)), size = 1) +
  theme_bw(base_size = 15) +
  xlim(x_min, x_max) +
  ylim(y_min, y_max) +
  coord_fixed(ratio = 0.8) +
  theme(axis.ticks=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text=element_blank(),
        axis.title=element_blank(),
        legend.position = "none")



indexes <- sample(1:800, 600)
train_data <- data[indexes, ]
test_data <- data[-indexes, ]
trainX <- train_data[, c(1, 2)]
trainY <- train_data[, 3]
testX <- test_data[, c(1, 2)]
testY <- test_data[, 3]
trainY <- ifelse(trainY == 1, 0, 1)
testY <- ifelse(testY == 1, 0, 1)


data.glm <- data.frame(Y=trainY,X1=trainX[,1],X2=trainX[,2])
model.logistic <- glm(Y~X1+X2,data=data.glm,family=binomial)


## As a reminder we check the shape of our classifier


step <- 0.01
x_min <- min(trainX[, 1]) - 0.2
x_max <- max(trainX[, 1]) + 0.2
y_min <- min(trainX[, 2]) - 0.2
y_max <- max(trainX[, 2]) + 0.2
grid <- as.matrix(expand.grid(seq(x_min, x_max, by = step), seq(y_min,
                                                                y_max, by = step)))
data.grid <- data.frame(X1=grid[,1],X2=grid[,2])
Z <- predict(model.logistic,newdata=data.grid,type="response")
Z <- ifelse(Z <0.5, 1, 2)

g1 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 1)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]))+
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
       panel.grid.minor = element_blank(), legend.position = "none",axis.title=element_text(size=18,face="italic"))
  
g1

g1+ labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]))
g1+ theme(axis.title=element_text(size=12,face="italic"))

g1+ labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]))

ggsave("../../../figures/chapter_3_figures/figure3_9_a.pdf",device="pdf", width = 5, height = 5)





## Confusion matrix on test set 


colnames(testX) <- c("X1","X2")
y.test.pred <- predict(model.logistic,newdata=testX,type="response")
y.test.class.pred <- ifelse(y.test.pred <0.5, 0, 1)
confusion.matrix <- table(y.test.class.pred,testY)
confusion.matrix 


#Using Caret 


library(caret)
y.test.class.pred <- factor(y.test.class.pred)
testY <- factor(testY)
cm <- caret::confusionMatrix(y.test.class.pred,testY)
knitr::kable(cm$table, caption="Confusion Table")


## Accuracy 
acc <- sum(diag(confusion.matrix))/sum(confusion.matrix)
acc


## ROC Curve 


library(ROCit)
roc.model1 <- rocit(score=y.test.pred,class=testY)
plot(roc.model1)

## AUC


roc.model1$AUC
# Using Caret 
cm$overall[1]


## Beyond Linearity 


#model.logistic.nl1 <- glm(Y~poly(X1,1)+poly(X2,1),data=data.glm,family=binomial)
model.logistic.nl2 <- glm(Y~polym(X1, X2, degree=2, raw=TRUE),data=data.glm,family=binomial)
model.logistic.nl3 <- glm(Y~polym(X1, X2, degree=4, raw=TRUE),data=data.glm,family=binomial)
model.logistic.nl4 <- glm(Y~polym(X1, X2, degree=8, raw=TRUE),data=data.glm,family=binomial)



Z <- predict(model.logistic.nl2,newdata=data.grid,type="response")
Z <- ifelse(Z <0.5, 1, 2)

g2 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 1)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.text = element_blank(),
        axis.title = element_blank(), legend.position = "none")+
  theme(axis.title=element_text(size=18,face="italic"))

g2+ labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]),cex=2)

ggsave("../../../figures/chapter_3_figures/figure3_9_b.pdf",device="pdf", width = 5, height = 5)


Z <- predict(model.logistic.nl3,newdata=data.grid,type="response")
Z <- ifelse(Z <0.5, 1, 2)
g3 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 1)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]))+
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), legend.position = "none",axis.title=element_text(size=18,face="italic"))

g3
g3+ labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]),cex=2)
ggsave("../../../figures/chapter_3_figures/figure3_9_c.pdf",device="pdf", width = 5, height = 5)




Z <- predict(model.logistic.nl4,newdata=data.grid,type="response")
Z <- ifelse(Z <0.5, 1, 2)
g4 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 1)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  labs(x=expression(x[1]),cex=2) +labs(y=expression(x[2]))+
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), legend.position = "none",axis.title=element_text(size=18,face="italic"))

g4

ggsave("../../../figures/chapter_3_figures/figure3_9_d.pdf",device="pdf", width = 5, height = 5)


