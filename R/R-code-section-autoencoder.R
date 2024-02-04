library(ruta)
library(rARPACK)
library(ggplot2)
###############
### Function plot required for reproducing Figure 3.12
###############
plot_digit <- function(digit, ...) {
  image(keras::array_reshape(digit, c(28, 28), "F")[, 28:1], xaxt = "n", yaxt = "n", col=gray(1:256 / 256), ...)
}

plot_sample <- function(digits_test, model1,model2,model3, sample) {
  sample_size <- length(sample)
  layout(
    matrix(c(1:sample_size, (sample_size + 1):(4 * sample_size)), byrow = F, nrow = 4)
  )
  
  
  for (i in sample) {
    par(mar = c(0,0,0,0) + 1)
    plot_digit(digits_test[i, ])
    plot_digit(model1[i, ])
    plot_digit(model2[i, ])
    plot_digit(model3[i, ])
  }
}




#######################
#### Load MNIST DATA
#######################


mnist = keras::dataset_mnist()

# Normalization to the [0, 1] interval
x_train <- keras::array_reshape(
  mnist$train$x, c(dim(mnist$train$x)[1], 784)
)
x_train <- x_train / 255.0
x_test <- keras::array_reshape(
  mnist$test$x, c(dim(mnist$test$x)[1], 784)
)
x_test <- x_test / 255.0

if(T){
network <- input() + dense(30, "tanh") + output("sigmoid")
network1 <- input() + dense(50, "tanh") +dense(10, "linear")+dense(50, "tanh") +output("sigmoid")
}

if(F){
network <- input() + dense(15, "tanh") + output("sigmoid")
network1 <- input() + dense(15, "tanh") +dense(2, "linear")+dense(15, "tanh") +output("sigmoid")
}




### model simple
network.simple <- autoencoder(network)#, loss = "binary_crossentropy")
model = train(network.simple, x_train, epochs = 10)
decoded.simple <- reconstruct(model, x_test)


### model deep
my_ae2 <- autoencoder(network1)#, loss = "binary_crossentropy")
model2 = train(my_ae2, x_train, epochs = 10)

decoded2 <- reconstruct(model2, x_test)

#### Linear interpolation between two digits
digit_A = x_train[which(mnist$train$y==3)[1],]#MNIST digit with 3 (This is the first digit in the train set that has 3)
digit_B = x_train[which(mnist$train$y==3)[10],]#another MNIST digit with 3 (This is the 10[th] digit in the train set that has 3)
latent_A = encode(model2,matrix(digit_A,nrow=1))
latent_B = encode(model2,matrix(digit_B,nrow=1))
lambda = 0.5
latent_interpolation = lambda*latent_A + (1-lambda)*latent_B
rought_interpolation = lambda*digit_A + (1-lambda)*digit_B

output_interpolation = decode(model2,latent_interpolation)
#save to csv file
digit3 <- data.frame(A=as.vector(digit_A),B=as.vector(digit_B),Interpol=as.vector(output_interpolation))
write.csv(digit3,file="data_digit3_interpol.csv",row.names = FALSE)



digit3.l <- data.frame(A=as.vector(digit_A),B=as.vector(digit_B),Interpol.linear=as.vector(rought_interpolation))
write.csv(digit3.l,file="data_digit3_interpol_bad.csv",row.names = FALSE)

plot_digit(digit_A)
plot_digit(digit_B)
plot_digit(as.vector(output_interpolation))

pdf("Figure-interpolation.pdf", width = 10, height = 6)

par(mar = c(0,0,0,0) + 1,mfrow=c(1,3))
plot_digit(digit_A)
plot_digit(as.vector(output_interpolation))
plot_digit(digit_B)
dev.off()

pdf("Figure-linear_interpolation.pdf", width = 10, height = 6)

par(mar = c(0,0,0,0) + 1,mfrow=c(1,3))
plot_digit(digit_A)
plot_digit(as.vector(rought_interpolation))
plot_digit(digit_B)
dev.off()





#### Plot reconstruction MNIST test with PCA, shallow and Deep AE 
pdf("../../../figures/chapter_3_figures/Figure-autoencoder-MNIST-reconstruction.pdf", width = 10, height = 6)

mus = colMeans(x_train)
x_train_c =  sweep(x_train, 2, mus)
x_test_c =  sweep(x_test, 2, mus)
digitSVDS = svds(x_train_c, k = 30)

ZpcaTEST = x_test_c %*% digitSVDS$v # PCA projection of test data
Rpca.10 = sweep( ZpcaTEST %*% t(digitSVDS$v), 2, -mus)

set.seed(9)
set.test <- sample(1:1000,9,replace=FALSE)
plot_sample(x_test,Rpca.10,decoded.simple,decoded2, set.test)
dev.off()




######################################################
## Plot projection on reduced space RS (2 dimension)
######################################################


#############
## Shallow with 2 
#############

network_shallow <- input() + dense(2, "tanh") +output("linear")
my_shallow <- autoencoder(network_shallow)#, loss = "binary_crossentropy")
model.shallow = train(my_shallow , x_train, epochs = 10)

decoded_shallow <- reconstruct(model, x_test)
project.autoencode.shallow <- encode(model.shallow,x_test)
project.autoencode.shallow.T <- encode(model.shallow,x_train)

##### plot simple autoencode test set
dat.auto <- data.frame(RS1=project.autoencode.shallow[,1],RS2=project.autoencode.shallow[,2],digit=as.factor(mnist$test$y))
p <- ggplot(data = dat.auto, aes(x = RS1, y = RS2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p
ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-shallow-Test.pdf", width = 8, height = 8)



dat.auto <- data.frame(RS1=project.autoencode.shallow.T[,1],RS2=project.autoencode.shallow.T[,2],digit=as.factor(mnist$train$y))
p <- ggplot(data = dat.auto, aes(x = RS1, y = RS2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p
ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-shallow-Train.pdf", width = 8, height = 8)





project.autoencode <- encode(model2,x_test)
project.autoencode.T <- encode(model2,x_train)

dim(project.autoencode)

##### plot deep one
dat.auto <- data.frame(RS1=project.autoencode[,1],RS2=project.autoencode[,2],digit=as.factor(mnist$test$y))
p <- ggplot(data = dat.auto, aes(x = RS1, y = RS2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p
ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-deep-Test.pdf", width = 8, height = 8)

##########3

##### plot deep one  on train
dat.auto <- data.frame(RS1=project.autoencode.T[,1],RS2=project.autoencode.T[,2],digit=as.factor(mnist$train$y))
p <- ggplot(data = dat.auto, aes(x = RS1, y = RS2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p
ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-deep-Train.pdf", width = 8, height = 8)

##########3


##################
#########PCA
##################
mus = colMeans(x_train)
x_train_c =  sweep(x_train, 2, mus)
x_test_c =  sweep(x_test, 2, mus)
digitSVDS = svds(x_train_c, k = 2)

ZpcaTEST = x_test_c %*% digitSVDS$v # PCA projection of test data
Rpca = sweep( ZpcaTEST %*% t(digitSVDS$v), 2, -mus) # PCA reconstruction
dim(ZpcaTEST)

ZpcaTrain = x_train_c %*% digitSVDS$v # PCA projection of test data
Rpca = sweep( ZpcaTrain %*% t(digitSVDS$v), 2, -mus) # PCA reconstruction
dim(ZpcaTrain)


##### plot simple autoencode

dat.auto <- data.frame(PC1=ZpcaTEST[,1],PC2=ZpcaTEST[,2],digit=as.factor(mnist$test$y))
p <- ggplot(data = dat.auto, aes(x = PC1, y = PC2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p

ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-PCA-Test.pdf", width = 8, height = 8)


dat.auto <- data.frame(PC1=ZpcaTrain[,1],PC2=ZpcaTrain[,2],digit=as.factor(mnist$train$y))
p <- ggplot(data = dat.auto, aes(x = PC1, y = PC2, color = digit))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) 
p

ggsave("../../../figures/chapter_3_figures/Figure-autoencoder-reduced-space-PCA-Train.pdf", width = 8, height = 8)







