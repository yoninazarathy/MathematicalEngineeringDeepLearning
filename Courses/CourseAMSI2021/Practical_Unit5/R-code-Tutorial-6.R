
## ---------------------------------------------------------------------------------------------------------------------------------------
library(keras)


## ----cache=TRUE,cache.path='cache/'-----------------------------------------------------------------------------------------------------
CIFAR10 <- dataset_cifar10()


## ---------------------------------------------------------------------------------------------------------------------------------------
x_train <- CIFAR10$train$x/255
x_test  <- CIFAR10$test$x/255
y_train <- keras::to_categorical(CIFAR10$train$y, num_classes = 10)
y_test  <- keras::to_categorical(CIFAR10$test$y,  num_classes = 10)
label_name = c("flyer", "car", "bird", "cat", "deer", "dog", "frog ", "horse", "ship", "truck")
label_name
dim(x_train)
dim(x_test)
table(CIFAR10$train$y)


## ---------------------------------------------------------------------------------------------------------------------------------------
ind.select.train <- which(CIFAR10$train$y==0|CIFAR10$train$y==3|CIFAR10$train$y==9)
ind.select.test <- which(CIFAR10$test$y==0|CIFAR10$test$y==3|CIFAR10$test$y==9)
length(ind.select.train)
length(ind.select.test)
x_train.filter <- x_train[ind.select.train,,,]
x_test.filter <- x_test[ind.select.test,,,]
y_train.filter <- CIFAR10$train$y[ind.select.train,]
y_test.filter <- CIFAR10$test$y[ind.select.test,]
y_train.filter.cat <- y_train[ind.select.train,c(1,4,10)]
y_test.filter.cat  <-  y_test[ind.select.test,c(1,4,10)]


## ---------------------------------------------------------------------------------------------------------------------------------------
trainLength <- 8000
validateLength <- 4000
trainRange <- 1:trainLength
validateRange <- (trainLength+1):(trainLength+validateLength)

x_train.filter.small <- x_train.filter[1:trainLength,,,]
y_train.filter.small <- y_train.filter.cat[1:trainLength,]
x_val.filter.small <- x_train.filter[(trainLength+1):(trainLength+validateLength),,,]
y_val.filter.small <- y_train.filter.cat[(trainLength+1):(trainLength+validateLength),]


## ---------------------------------------------------------------------------------------------------------------------------------------
img_width <- 32
img_height <- 32

model <- keras_model_sequential()

model %>%
    layer_conv_2d(filter = 8, kernel_size = c(3,3), strides=c(1,1),padding="same", activation="relu",
    input_shape = c(img_height, img_width, 3)) %>%
    layer_batch_normalization() %>%
    layer_max_pooling_2d(pool_size = c(2,2)) %>%
    layer_conv_2d(filter = 4, kernel_size = c(3,3), strides=c(1,1),padding="valid", activation="relu") %>%
    layer_batch_normalization() %>%
    layer_max_pooling_2d(pool_size = c(2,2)) %>%
    layer_flatten() %>%
    layer_dense(units = 80, activation = "relu")   %>%
    layer_dropout(rate = 0.5) %>% 
    layer_dense(units = 40, activation = "relu")  %>%
    layer_dropout(rate = 0.5) %>%
    layer_dense(units = 3, activation = "softmax")

summary(model)    


## ----eval=FALSE-------------------------------------------------------------------------------------------------------------------------

# if you want to visualise your network you should install this library 
#devtools::install_github("andrie/deepviz")


## ----eval=TRUE--------------------------------------------------------------------------------------------------------------------------
library(deepviz)
model %>% plot_model()

# To DO 
#model 2


summary(model2)    


## ---------------------------------------------------------------------------------------------------------------------------------------
model2 %>% compile(
  loss = 'categorical_crossentropy',
  metrics = 'accuracy',
  optimizer = optimizer_adam(lr = 0.001)
)


## ---------------------------------------------------------------------------------------------------------------------------------------
epochs <- 20
batch.size <- 50

start.time <-  Sys.time()

history.model2 <- model2 %>% fit(
  x=x_train.filter.small, y=y_train.filter.small, validation_data = list(x_val.filter.small,y_val.filter.small),
  epochs = epochs, batch_size = batch.size, verbose=FALSE
)
end.time <- Sys.time()
(running.time <- end.time - start.time)


## ---------------------------------------------------------------------------------------------------------------------------------------
plot(history.model2 )


## ---------------------------------------------------------------------------------------------------------------------------------------
model.acc <- model2 %>% tensorflow::evaluate(x_test.filter,y_test.filter.cat)


## ---------------------------------------------------------------------------------------------------------------------------------------
class.name <- c("airplane","cat","truck")
pred<- model2 %>% keras::predict_classes(x_test.filter)
pred.class <- factor(pred,labels=class.name)
true.class <- factor(y_test.filter,labels=class.name)
table(pred.class,true.class)
(ACC <- sum(diag(table(pred.class,true.class)))/3000)


### Build your new model  


## ----echo=FALSE-------------------------------------------------------------------------------------------------------------------------
model3 %>% compile(
  loss = 'categorical_crossentropy',
  metrics = 'accuracy',
  optimizer = optimizer_adam(lr = 0.001)
)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------------------------
epochs <- 40
batch.size <- 50

start.time <-  Sys.time()

history.model3 <- model3 %>% fit(
  x=x_train.filter.small, y=y_train.filter.small, validation_data = list(x_val.filter.small,y_val.filter.small),
  epochs = epochs, batch_size = batch.size, verbose=FALSE
)
end.time <- Sys.time()

(running.time <- end.time - start.time)


## ---------------------------------------------------------------------------------------------------------------------------------------
plot(history.model3 )


## ---------------------------------------------------------------------------------------------------------------------------------------
(model.acc <- model3 %>% tensorflow::evaluate(x_test.filter,y_test.filter.cat))


## ---------------------------------------------------------------------------------------------------------------------------------------
class.name <- c("airplane","cat","truck")
pred<- model3 %>% keras::predict_classes(x_test.filter)
pred.class <- factor(pred,labels=class.name)
true.class <- factor(y_test.filter,labels=class.name)
table(pred.class,true.class)
(ACC <- sum(diag(table(pred.class,true.class)))/3000)

