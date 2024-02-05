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
NN1 <- glm(Y~X1+X2,data=data.glm,family=binomial)


step <- 0.01
x_min <- min(trainX[, 1]) - 0.2
x_max <- max(trainX[, 1]) + 0.2
y_min <- min(trainX[, 2]) - 0.2
y_max <- max(trainX[, 2]) + 0.2
grid <- as.matrix(expand.grid(seq(x_min, x_max, by = step), seq(y_min,
                                                                y_max, by = step)))
data.grid <- data.frame(X1=grid[,1],X2=grid[,2])
Z <- predict(NN1,newdata=data.grid,type="response")
Z <- ifelse(Z <0.5, 1, 2)

g1 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 2)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.text = element_blank(),
        axis.title = element_blank(), legend.position = "none")
g1

library(neuralnet)
nn1 <- neuralnet(Y~X1+X2,data=data.glm,hidden=4,linear.output=FALSE)
plot(nn1, rep="best")
pr.nn <- compute(nn1,data.grid)

Z <- pr.nn$net.result
Z.NN1 <- ifelse(Z <0.5, 1, 2)

g2 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z.NN1)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 2)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.text = element_blank(),
        axis.title = element_blank(), legend.position = "none")
g2

nn1 <- neuralnet(Y~X1+X2,data=data.glm,hidden=10,linear.output=FALSE)
plot(nn1, rep="best")
pr.nn <- compute(nn1,data.grid)


Z <- pr.nn$net.result
Z.NN1 <- ifelse(Z <0.5, 1, 2)

g3 <- ggplot() +
  geom_tile(aes(x = grid[, 1], y = grid[, 2], fill = as.character(Z.NN1)), alpha = 0.3, show.legend = F)+
  geom_point(data = train_data, aes(x = x, y = y, color = as.character(trainY)),size = 2)+
  theme_bw(base_size = 15) + coord_fixed(ratio = 0.8) +
  theme(axis.ticks = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.text = element_blank(),
        axis.title = element_blank(), legend.position = "none")
g3

pdf("Linear-bundary-Logistic.pdf",width = 8, height = 8)
print(g1)     # Plot 1 --> in the first page of PDF    # Plot 2 ---> in the second page of the PDF
dev.off() 

pdf("NN-4-class.pdf",width = 8, height = 8)
print(g2)     # Plot 1 --> in the first page of PDF    # Plot 2 ---> in the second page of the PDF
dev.off()

pdf("NN-10-class.pdf",width = 8, height = 8)
print(g3)     # Plot 1 --> in the first page of PDF    # Plot 2 ---> in the second page of the PDF
dev.off()
