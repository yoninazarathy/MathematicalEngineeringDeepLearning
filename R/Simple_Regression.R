library(MASS)
library(tidyverse)
library(caret)
data("Boston", package = "MASS")

ind <- which(Boston$medv==50)
Boston.s <- Boston[-ind,]




train.data  <- Boston.s
model.lm <- lm(medv~lstat,data=train.data)
model.quad <- lm(medv~lstat+I(lstat^2),data=train.data)

library(latex2exp)
model1 <- lm(medv~rm,data=train.data)
predict_medv <- predict(model1, interval="prediction")
new_train.data <- cbind(train.data, predict_medv)

p1 <- ggplot(train.data, aes(rm, medv)) +
  geom_point(size=2) + stat_smooth(method = "lm", col = "red") +
  xlab(TeX(r'(\textit{Average number of rooms per dwelling} ($rm$))')) + ylab(TeX(r'(\textit{House prices in \$1000} ($medv$))'))+
  theme(legend.position = 'bottom')  + theme_bw()
 

p1 + theme(axis.text = element_text(size = 30))+ theme(axis.title = element_text(size = 20))   

ggsave("Figure2-1-a.pdf",device="pdf", width = 8, height = 8)


p2 <- ggplot(train.data, aes(lstat, medv) ) +
  geom_point(size=2) +
  stat_smooth(method = lm, formula = y ~ poly(x, 2, raw = TRUE))+
  stat_smooth(method = lm, formula = y ~ x,col='red')+
  xlab(TeX(r'(\textit{Lower status of the population in %} ($lstat$))')) + ylab(TeX(r'(\textit{House prices in \$1000} ($medv$))'))+
  theme(legend.position = 'bottom')  + theme_bw()
p2 + theme(axis.text = element_text(size = 30))+ theme(axis.title = element_text(size = 20))   


ggsave("Figure2-1-b.pdf",device="pdf", width = 8, height = 8)
