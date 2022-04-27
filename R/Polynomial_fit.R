set.seed(11)
x <- seq(0,1,length=10)
y <- sin(2*pi*x)-cos(2*pi*x)+rnorm(10,0,0.2)
plot(y~x,type="p")
curve(sin(2*pi*x)-cos(2*pi*x),col="green",0,1,add=TRUE)
z <- sin(2*pi*x)+cos(2*pi*x)
mydata <- data.frame(y=y,x=x)

require(ggplot2)
ggplot(mydata, aes(x, y)) + 
  geom_point() 



model0 <- glm(y~1)
model1 <- glm(y~poly(x,1))
model2 <- glm(y~poly(x,2))
model3 <- glm(y~poly(x,3))
model4 <- glm(y~poly(x,4))
model5 <- glm(y~poly(x,5))
model6 <- glm(y~poly(x,6))
model7 <- glm(y~poly(x,7))
model8 <- glm(y~poly(x,8))
model9 <- glm(y~poly(x,9))

# Much better
model.list <- vector("list", length = 10)
model.list[[1]] <- glm(y~1)
for (i in 1:9){
  formula <- as.formula(paste("y ~ poly(x,",i,")",sep=""))
  model.list[[i+1]] <- glm(formula) 
}


z <- seq(0,1,length=10000)

my.formula <- y ~ 1
p0 <- ggplot(mydata, aes(x, y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, 
              formula = my.formula, 
              colour = "red")+
  labs(title=element_text("Polynomial fit with k=0"))+
  theme(legend.position = "none") + theme_bw()


my.formula <- y ~ poly(x, 1, raw = TRUE)

p1 <- ggplot(mydata, aes(x, y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, 
              formula = my.formula, 
              colour = "red")+
  labs(title=element_text("Polynomial fit with k=1"))+
  theme(legend.position = "none") + theme_bw()

my.formula <- y ~ poly(x, 3, raw = TRUE)

p3 <- ggplot(mydata, aes(x, y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, 
              formula = my.formula, 
              colour = "red")+
  labs(title=element_text("Polynomial fit with k=3"))+
  theme(legend.position = "none")+ theme_bw()


my.formula <- y ~ poly(x, 9, raw = TRUE)


p9 <- ggplot(mydata,aes(x, y=y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, 
              formula = my.formula, 
              colour = "red")+
  labs(title=element_text("Polynomial fit with k=9"))+
  theme(legend.position = "none") + theme_bw()
library(ggpubr)
ggarrange(p0,p1,p3,p9,ncol = 2, nrow = 2)
ggsave("polynomial_fit.pdf",device="pdf", width = 5, height = 5)



set.seed(1123)
testx <- seq(0,1,length=10000)
testy <- sin(2*pi*testx)-cos(2*pi*testx)+rnorm(10000,0,0.2)

RMSE <- function(model,dataXY){
  pred <- predict.glm(model,newdata=data.frame(x=dataXY$X))
  RMSE <- mean((pred-dataXY$Y)**2)
  return(RMSE)
}

data.train <- data.frame(X=x,Y=y)
data.test <- data.frame(X=testx,Y=testy)

RMSE.result <- matrix(NA,nrow=10,ncol=3)
for(i in 1:10){
  model <- model.list[[i]]
  RMSE.result[i,] <- c(i-1,RMSE(model,data.train),RMSE(model,data.test))
}


colnames(RMSE.result) <- c("M","Train","Test")



library(knitr)
kable(RMSE.result)

data.result <- as.data.frame(RMSE.result)
colnames(RMSE.result) <- c("M","Train","Test")
mydata <- data.frame(Model=rep(data.result$M,2),Performance=c(data.result$Train,data.result$Test),Group=rep(c("Train","Production"),each=10),color=rep(c("red","black"),each=10))

 
library(latex2exp)
linetype = c('solid', 'solid')
LegendTitle = ""
p <- ggplot(mydata, aes(Model,Performance, group = Group,color=color))+
  geom_line(aes(group = Group,color=color))+#,"red")) +
  scale_color_identity(labels = c(blue = "blue",red = "red"))+
  #scale_linetype_manual(name = LegendTitle, values = linetype) +
  scale_x_continuous(name="Model (k)",breaks=0:9,labels=0:9)+
  scale_y_continuous(name="Mean Square Error")+
  theme_bw() +
  annotate(geom="text", x=7.5, y=1, label=TeX("$E_{\\textrm{train}}",italic=TRUE), parse=TRUE
             ,color="red")+
  annotate("segment", x = 6.6, xend = 7, y = 1, yend = 1,
         colour = "red")+
  annotate(geom="text", x=7.6, y=0.95, label=TeX("$E_{\\textrm{unseen}}",italic=TRUE), parse=TRUE
           ,color="black")+
annotate("segment", x = 6.6, xend = 7, y = 0.95, yend = 0.95,
         colour = "black")
p

ggsave("Polynomial_plot.pdf",device="pdf", width = 5, height = 5)


