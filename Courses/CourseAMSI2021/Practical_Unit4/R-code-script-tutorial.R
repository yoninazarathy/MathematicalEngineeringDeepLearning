## ----setup, include=FALSE--------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,message = NA,comment = NA)
library(knitr)


## ----eval=FALSE------------------------------------------------------------------------------------------
install.packages(keras)


## ----pkg-req, cache=FALSE--------------------------------------------------------------------------------
library(dplyr)         
library(keras)         
library(dslabs)
library(tidyr)
library(stringr)
library(purrr)


## ----DL-prep-mnist-data----------------------------------------------------------------------------------
# Import MNIST training data
mnist <- dslabs::read_mnist()
mnist_x <- mnist$train$images
mnist_y <- mnist$train$labels
mnist_x_test <- mnist$test$images
mnist_y_test <- mnist$test$labels
dim(mnist_x)
dim(mnist_x_test)
length(mnist_y)
length(mnist_y_test)


## --------------------------------------------------------------------------------------------------------
colnames(mnist_x) <- paste0("V", 1:ncol(mnist_x))
mnist_x <- mnist_x / 255
colnames(mnist_x_test) <- paste0("V", 1:ncol(mnist_x))
mnist_x_test <- mnist_x_test / 255


## --------------------------------------------------------------------------------------------------------
# One-hot encode response
mnist_y <- to_categorical(mnist_y, 10)
dim(mnist_y)


## ----echo=FALSE------------------------------------------------------------------------------------------
k_clear_session()


## ----architecture----------------------------------------------------------------------------------------

model <- keras_model_sequential() %>%
  layer_dense(units = 128, input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 64) %>%
  layer_dense(units = 10)


## ----activation-arguments--------------------------------------------------------------------------------
model <- keras_model_sequential() %>%
  layer_dense(units = 128, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")


## ----backpropagation-------------------------------------------------------------------------------------
model <- keras_model_sequential() %>%
  
  # Network architecture
  layer_dense(units = 128, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax") %>%
  
  # Backpropagation
  compile(
    loss = 'categorical_crossentropy',
    optimizer = optimizer_rmsprop(),
    metrics = c('accuracy')
  )


## --------------------------------------------------------------------------------------------------------
summary(model)


## ----model-train, fig.height=5, fig.width=7, fig.cap="Training and validation performance over 25 epochs."----
# Train the model
set.seed(1)
fit1 <- model %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 25,
    batch_size = 128,
    validation_split = 0.2,
    verbose = FALSE
  )

# Display output
fit1
plot(fit1)


## --------------------------------------------------------------------------------------------------------
model%>% predict_classes(mnist_x_test[1:10,])


## --------------------------------------------------------------------------------------------------------
mnist_y_test[1:10]


## --------------------------------------------------------------------------------------------------------
pred <- model%>% predict_classes(mnist_x_test[,])
table(pred,mnist_y_test)
sum(diag(table(pred,mnist_y_test)))/10000


## ----message=FALSE---------------------------------------------------------------------------------------
library(caret)
confusionMatrix(factor(pred),factor(mnist_y_test))->res
res$table
res$overall[1]




## ----model-capacity--------------------------------------------------------------------------------------
compiler <- function(object) {
  compile(
    object,
    loss = 'categorical_crossentropy',
    optimizer = optimizer_rmsprop(),
    metrics = c('accuracy')
  )
}

trainer <- function(object) {
  fit(
    object,
    x = mnist_x,
    y = mnist_y,
    epochs = 25,
    batch_size = 128,
    validation_split = .2,
    verbose = FALSE
    )
}

# One layer models -------------------------------------------------------------
# small  model
`1 layer_small` <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# medium
`1 layer_medium` <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# large
`1 layer_large` <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()



## --------------------------------------------------------------------------------------------------------
models <- ls(pattern = "layer_") 
df <- models %>%
  map(get) %>%
  map(~ data.frame(
    `Validation error` = .$metrics$val_loss,
    `Training error`   = .$metrics$loss,
    epoch = seq_len(.$params$epoch)
    )) %>%
  map2_df(models, ~ mutate(.x, model = .y)) %>%
  separate(model, into = c("Middle layers", "Number of nodes"), sep = "_") %>%
  gather(Validation, Loss, Validation.error:Training.error) %>%
  mutate(
    Validation = str_replace_all(Validation, "\\.", " "),
    `Number of nodes` = factor(`Number of nodes`, levels = c("small", "medium", "large"))
    )

best <- df %>% 
  filter(Validation == "Validation error") %>%
  group_by(`Middle layers`, `Number of nodes`) %>% 
  filter(Loss == min(Loss)) %>%
  mutate(label = paste("Min validation error:", round(Loss, 4)))

ggplot(df, aes(epoch, Loss)) +
  geom_hline(data = best, aes(yintercept = Loss), lty = "dashed", color = "grey50") +
  geom_text(data = best, aes(x = 25, y = 0.95, label = label), size = 4, hjust = 1, vjust = 1) + 
  geom_point(aes(color = Validation)) +
  geom_line(aes(color = Validation)) +
  facet_grid(`Number of nodes` ~ `Middle layers`, scales = "free_y") +
  scale_y_continuous(limits = c(0, 1)) +
  theme(legend.title = element_blank(),
        legend.position = "top") +
  xlab("Epoch")




## ----batch-norm------------------------------------------------------------------------------------------
model_w_norm <- keras_model_sequential() %>%
  
  # Network architecture with batch normalization
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%

  # Backpropagation
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_rmsprop(),
    metrics = c("accuracy")
  )


## ----model-capacity-with-batch-norm, echo=TRUE, eval=TRUE------------------------------------------------
# One layer models -------------------------------------------------------------
# small  model
`1 layer_small` <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# medium
`1 layer_medium` <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# large
`1 layer_large` <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# Two layer models -------------------------------------------------------------
# small capacity model
`2 layer_small` <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 8, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# medium
`2 layer_medium` <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# large
`2 layer_large` <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# Three layer models -------------------------------------------------------------
# small capacity model
`3 layer_small` <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 8, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 4, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# medium
`3 layer_medium` <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

# large
`3 layer_large` <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  trainer()

models <- ls(pattern = "layer_") 
df_batch <- models %>%
  map(get) %>%
  map(~ data.frame(
    `Validation error` = .$metrics$val_loss,
    `Training error`   = .$metrics$loss,
    epoch = seq_len(.$params$epoch)
    )) %>%
  map2_df(models, ~ mutate(.x, model = .y)) %>%
  separate(model, into = c("Middle layers", "Number of nodes"), sep = "_") %>%
  gather(Validation, Loss, Validation.error:Training.error) %>%
  mutate(
    Validation = str_replace_all(Validation, "\\.", " "),
    `Number of nodes` = factor(`Number of nodes`, levels = c("small", "medium", "large")),
    `Batch normalization` = TRUE
    )


## ----model-capacity-with-batch-norm-plot, warning=FALSE,echo=TRUE, fig.width=12, fig.height=8, fig.cap="The effect of batch normalization on validation loss for various model capacities."----
df2 <- df %>%
  mutate(`Batch normalization` = FALSE) %>%
  bind_rows(df_batch) %>% 
  filter(Validation == "Validation error")

best <- df2 %>% 
  filter(Validation == "Validation error") %>%
  group_by(`Middle layers`, `Number of nodes`) %>% 
  filter(Loss == min(Loss)) %>%
  mutate(label = paste("Min validation error:", round(Loss, 4)))

ggplot(df2, aes(epoch, Loss, color = `Batch normalization`)) + 
  geom_text(data = best, aes(x = 25, y = 0.95, label = label), size = 4, hjust = 1, vjust = 1) + 
  geom_point() +
  geom_line() +
  facet_grid(`Number of nodes` ~ `Middle layers`, scales = "free_y") +
  scale_y_continuous(limits = c(0, 1)) +
  xlab("Epoch") +
  scale_color_discrete("Batch normalization") +
  theme(legend.position = "top")


## ----regularization-with-penalty, eval=TRUE--------------------------------------------------------------
model_w_reg <- keras_model_sequential() %>%
  
  # Network architecture with L1 regularization and batch normalization
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x),
              kernel_regularizer = regularizer_l2(0.001)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128, activation = "relu", 
              kernel_regularizer = regularizer_l2(0.001)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 64, activation = "relu", 
              kernel_regularizer = regularizer_l2(0.001)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%

  # Backpropagation
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_rmsprop(),
    metrics = c("accuracy")
  )





## ----dropout, eval=TRUE----------------------------------------------------------------------------------
model_w_drop <- keras_model_sequential() %>%
  
  # Network architecture with 20% dropout
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, activation = "softmax") %>%

  # Backpropagation
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_rmsprop(),
    metrics = c("accuracy")
  )


## ----model-with-regularization, echo=TRUE, eval=TRUE-----------------------------------------------------
fit_baseline <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    verbose = FALSE
  )

fit_norm <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    verbose = FALSE
  )

fit_reg <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compiler() %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    verbose = FALSE
  )

models <- ls(pattern = "fit_") 
df_reg <- models %>%
  map(get) %>%
  map(~ data.frame(
    `Validation error` = .$metrics$val_loss,
    `Training error`   = .$metrics$loss,
    epoch = seq_len(.$params$epoch)
    )) %>%
  map2_df(models, ~ mutate(.x, model = .y)) %>%
  mutate(Model = case_when(
    model == "fit_baseline" ~ "Baseline",
    model == "fit_norm"     ~ "Baseline + batch normalization",
    model == "fit_reg"      ~ "Baseline + batch normalization + dropout"
  )) %>%
  gather(Validation, Loss, Validation.error:Training.error)


## ----model-with-regularization-plot, echo=TRUE, fig.cap="The effect of regularization with dropout on validation loss."----
baseline <- df %>%
  filter(`Middle layers` == "3 layer", `Number of nodes` == "large") %>%
  mutate(Model = "Baseline") %>%
  select(epoch, Model, Validation, Loss)
batch <- df_batch %>%
  filter(`Middle layers` == "3 layer", `Number of nodes` == "large") %>%
  mutate(Model = "Baseline + batch normalization") %>%
  select(epoch, Model, Validation, Loss)
df_reg <- df_reg %>%
  select(-model) %>%
  filter(Model == "Baseline + batch normalization + dropout") %>%
  mutate(Validation = stringr::str_replace_all(Validation, "\\.", " ")) %>%
  bind_rows(batch, baseline)

best <- df_reg %>% 
  filter(Validation == "Validation error") %>%
  group_by(Model) %>% 
  filter(Loss == min(Loss)) %>%
  mutate(label = paste("Min validation error:", round(Loss, 4)))

ggplot(df_reg, aes(epoch, Loss)) + 
  geom_text(data = best, aes(x = 35, y = 0.49, label = label), size = 4, hjust = 1, vjust = 1) +
  geom_point(aes(color = Validation)) +
  geom_line(aes(color = Validation)) +
  facet_wrap(~ Model) +
  xlab("Epoch") +
  theme(legend.title = element_blank(),
        legend.position = "top")


## --------------------------------------------------------------------------------------------------------
fit_reg_init <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", kernel_initializer=initializer_random_normal(),input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 128, kernel_initializer=initializer_random_normal(),activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 64, kernel_initializer=initializer_random_normal(),activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, kernel_initializer=initializer_random_normal(),activation = "softmax") %>%
  compiler() %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    verbose = FALSE
  )
fit_reg_init
plot(fit_reg_init)


## ----echo=FALSE------------------------------------------------------------------------------------------
# set plot.keras_training_history in your global env to call user functions
plot.keras_training_history <- keras:::plot.keras_training_history
environment(plot.keras_training_history) <- globalenv()

# replace as.dataframe with custom function
as.data.frame.keras_training_history <- function (x, ...){

 if (tensorflow::tf_version() < "2.2") 
  x$metrics <- x$metrics[x$params$metrics]
 values <- x$metrics

 values[] <- lapply(values, `length<-`, x$params$epochs)
 df <- data.frame(epoch = seq_len(x$params$epochs), value = unlist(values), 
                  metric = rep(sub("^val_", "", names(x$metrics)), each = x$params$epochs),
                  data = rep(grepl("^val_", names(x$metrics)), each = x$params$epochs))
 rownames(df) <- NULL
 df$data <- factor(df$data, c(FALSE, TRUE), c("training", "validation"))
 df$metric <- factor(df$metric, unique(sub("^val_", "", names(x$metrics))))
 df
}


## ----adj-lrn-rate, fig.cap="Training and validation performance on our 3-layer large network with dropout."----
model_final <- keras_model_sequential() %>%
  layer_dense(units = 256, activation = "relu", kernel_initializer=initializer_random_normal(),input_shape = ncol(mnist_x)) %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 128, kernel_initializer=initializer_random_normal(),activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 64, kernel_initializer=initializer_random_normal(),activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, kernel_initializer=initializer_random_normal(),activation = "softmax") %>%
  compile(
    loss = 'categorical_crossentropy',
    optimizer = optimizer_rmsprop(),
    metrics = c('accuracy')
  ) 

model_final.fit <- model_final %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    callbacks = list(callback_early_stopping(patience = 5)),
    verbose = FALSE
  )

model_final.fit

# Optimal
min(model_final.fit$metrics$val_loss)
max(model_final.fit$metrics$val_acc)

plot(model_final.fit)



