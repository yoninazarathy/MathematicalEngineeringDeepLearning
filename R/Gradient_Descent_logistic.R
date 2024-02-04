source("Function-for-Gradient-Descent-Logistic.R")

###
##Load the data
###
load("../data/Breast_cancer.RData")
data <- Breast_cancer_data
dim(data)
data <- data %>% mutate(diagnosis_0_1 = ifelse(diagnosis == "M", 1, 0))
set.seed(101)
## select only 10 variables
data <- data[,-c(1,2)]
var <- c(1,2,5,6,9,10,11,12,15,16,31)
data <- data[,var]
### Slpit the data 80% 20 %
training <- createDataPartition(data$diagnosis_0_1, p=0.8, list=FALSE)
train <- data[ training, ]
test <- data[ -training, ]
### add one in first column for the bias/intercept on test set
test <- cbind(rep(1,nrow(test)),test) 
### check names of features and outcome
colnames(train)
Y <- as.matrix(train[,11]) # outcome for train data
#Predictor variables for train data
X <- as.matrix(train[,-11])
X <- cbind(rep(1,nrow(X)),X) #Add ones to X
###############################################################
#### Check result with glm function from R which use second order mothod for optimistation
data10 <- as.data.frame(cbind(X[,-1],Y))
colnames(data10)[11] <- "diagnosis_0_1"
model.10 <- glm(diagnosis_0_1~.,family=binomial,data=data10)
cross.entropy.glm <- loss.f(model.10$coefficients,X,Y)
cross.entropy.glm
## converge in 8 iteration with Fisher Scoring
##############################################################


#####
## Gradient descent
#####
scaled.theta <- gradient.descent(x=X, y=Y,alpha = 15, threshold = 1e-9,num.iterations=20000,datatest = test,scaled = TRUE)
scaled.theta$loss_train[scaled.theta$Niter]
#unscaled.theta <- gradient.descent(x=X, y=Y, alpha=0.1,num.iterations=10000,datatest = test,scaled = NULL)
scaled.theta$Niter
scaled.theta$loss_train[scaled.theta$Niter]


#####################################
### For comparison with glm function
####################################
unscaled.result <- back_transform(X,scaled.theta$theta.opt)
#res.theta <- cbind(unscaled.theta$theta.opt,unscaled.result,model.10$coefficients)
res.theta <- cbind(unscaled.result,model.10$coefficients)
colnames(res.theta)<- c("GD scaled","GLM")
head(res.theta)

################
##### Plot loss 
###############
# we plot until 40 iterations
Niter <- 40
mydata <- data.frame(Iteration=1:Niter,Performance=c(scaled.theta$loss_train[1:Niter],scaled.theta$loss_test[1:Niter]),Group=rep(c("Train","Test"),each=Niter),color=rep(c("red","black"),each=Niter))
library(latex2exp)
linetype = c('solid', 'solid')
LegendTitle = ""
p <- ggplot(mydata, aes(Iteration,Performance, group = Group,color=Group,linetype=Group))+
  geom_line()+ #,"red")) +
 # scale_color_identity(labels = c(blue = "blue",red = "red"))+
  scale_y_continuous(name="Cross Entropy")+
  scale_linetype_manual(values = c(rep("solid", 2))) +
  scale_color_manual(values = c("black", "red")) +
  theme_bw()+
  theme(legend.position = c(0.85, 0.90),
        legend.background = element_rect(fill = "white", color = "black"))+
  theme(text = element_text(size = 15))+
  theme(legend.title=element_blank())
  p

### old code manual position of legend 
if(F){  
  annotate(geom="text", x=35, y=0.55, label=TeX("$\\textrm{Train}",italic=TRUE), parse=TRUE
           ,color="red",size = 6)+
  annotate("segment", x = 30, xend = 32, y = 0.55, yend = 0.55,
           colour = "red")+
  annotate(geom="text", x=35, y=0.50, label=TeX("$\\textrm{Test}",italic=TRUE), parse=TRUE
           ,color="black",size = 6)+
  annotate("segment", x = 30, xend = 32, y = 0.5, yend = 0.5,
           colour = "black")
}

#ggsave("Cross-entropy-Logistic.pdf",device="pdf", width = 5, height = 5)
ggsave("../../../figures/chapter_3_figures/loss_gd.pdf",device="pdf", width = 5, height = 5)


################
##### F1 score
###############
mydata <- data.frame(Iteration=1:Niter,Performance=c(scaled.theta$F1_train[1:Niter],scaled.theta$F1_test[1:Niter]),Group=rep(c("Train","Production"),each=Niter),color=rep(c("red","black"),each=Niter))


library(latex2exp)
linetype = c('solid', 'solid')
LegendTitle = ""
p <- ggplot(mydata, aes(Iteration,Performance, group = Group,color=color))+
  geom_line(aes(group = Group,color=color))+#,"red")) +
  scale_color_identity(labels = c(blue = "blue",red = "red"))+
  scale_y_continuous(name="F1 score")+
  theme_bw()  +
  theme(text = element_text(size = 15))#+
 # annotate(geom="text", x=60, y=0.85, label=TeX("$\\textrm{Train}",italic=TRUE), parse=TRUE
 #          ,color="red")+
#  annotate("segment", x = 40, xend = 50, y = 0.85, yend = 0.85,
#           colour = "red")+
#  annotate(geom="text", x=60, y=0.83, label=TeX("$\\textrm{Test}",italic=TRUE), parse=TRUE
#           ,color="black")+
#  annotate("segment", x = 40, xend = 50, y = 0.83, yend = 0.83,
#           colour = "black")
p

#ggsave("F1-score-Logistic.pdf",device="pdf", width = 5, height = 5)
ggsave("../../../figures/chapter_3_figures/F1_perf_gd.pdf",device="pdf", width = 5, height = 5)








