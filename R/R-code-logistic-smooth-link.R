library(scales)
library(tidyverse)
load("../data/Breast_cancer.RData")
head(Breast_cancer_data[,c(2:6)])
data <- Breast_cancer_data
dim(data)
data <- data %>% mutate(diagnosis_0_1 = ifelse(diagnosis == "M", 1, 0))
breast_cancer_glm <- glm(diagnosis_0_1 ~ area_mean, data, family = "binomial")

#### create a theme
post_theme <- theme_bw() +
  theme(legend.position = "center",
        plot.title = element_text(hjust = 0, size = rel(1.5), face = "bold"),
        plot.margin = unit(c(1, 1, 1, 1), units = "lines"),
        axis.title.x = element_text(color = "Black", size = 20),
        axis.title.y = element_text( color = "Black", size = 20),
        axis.text.x = element_text( color = "Black", size = 20),
        axis.text.y = element_text(color = "Black", size = 20),
        legend.title = element_text(color = "Black", size = 20),
        legend.text = element_text( color = "Black", size = 20))

#############################
#### Plot univariate logistic 
# variable area_mean
############################

data %>% filter(area_mean<2000)  %>% ggplot(mapping = aes(x = area_mean, y = diagnosis_0_1)) +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_hline(yintercept = 1, linetype = "dotted") +
    geom_smooth(mapping = aes(color = "Logistic Regression"), method = "glm", formula = y ~ x, method.args = list(family = binomial(link = "logit")), se = TRUE) +
   geom_jitter(width = 0, height = 0.02,size = 2, alpha = 0.50)+#,position="jitter") +
  scale_y_continuous(breaks = seq(-1, 1, 0.20))+#, labels = percent_format(accuracy = 1)) +
  scale_color_manual(values = c("#d55e00", "#0072b2")) +
  #labs(x = expression(x[1]), y=bquote("Predicted probability:" ~ hat(y)), color = "") +
  labs(x = expression(x[1]), y=bquote(~ hat(y)), color = "") +
  post_theme

ggsave("../../../figures/chapter_3_figures/logistic-1-feature.pdf", width = 8, height = 6)
ggsave("Figure-LINK-UNIVARIATE.pdf",device="pdf", width = 8, height = 8)




#######################
##### Figure bivariate 
#######################

# with area_mean and texture_mean

data1 <- data #%>% filter(area_mean<2000) 
glm.fit3 <- glm(diagnosis_0_1 ~ area_mean+texture_mean, data = data1, family = "binomial")


library(lattice)
#pdf("Figure-LINK-BIVARIATE.pdf", width = 10, height = 10)
pdf("../../../figures/chapter_3_figures/logistic-2-features.pdf", width = 6, height = 4)

   p <- expand.grid(area_mean = seq(100, 1900, length.out = 50),
                texture_mean = seq(10, 40, length.out = 50)) %>% 
      mutate(pihat_logistic = predict.glm(glm.fit3, newdata = data.frame(area_mean, texture_mean), type = "response")) %>% 
      wireframe(pihat_logistic ~ area_mean + texture_mean, data = ., cex.lab=10,drape = TRUE,colorkey = FALSE, lwd=0.002,
                scales = list(arrows = FALSE, col="black",axis=list(text=list(cex=20))), screen = list(z = -10, x = -60), col.regions = colorRampPalette(c("#0072b2", "#d55e00"))(100), 
   #             zlab =list(expression(~~~~~~~~~~~~~~Predicted~probability:~ hat(y)), rot = 90), xlab = expression(x[1]), ylab = expression(x[2]),
   zlab =list(expression(~~~~~~~hat(y)), rot = 90), xlab = expression(x[1]), ylab = expression(x[2]),
   
               par.settings = list(axis.line = list(col = "transparent"),ticks=TRUE))
p
dev.off()

scales=list(arrows=FALSE, axis=list(text=list(cex=2)))
####
##  Boundary decision 
#### 

#pdf("Figure-boundary-logistic.pdf", width = 10, height = 8)
pdf("../../../figures/chapter_3_figures/boundary-logistic.pdf", width = 8, height = 6)
breast_cancer_glm3 <- glm(diagnosis_0_1 ~ area_mean+texture_mean, data = data1, family = "binomial")
  
  pred_1 <- function(x,y){
    predict(breast_cancer_glm3,newdata=data.frame(texture_mean=y,area_mean=x),type="response")>.5
  }
  clr1 <- c(rgb(1,0,0,1),rgb(0,0,1,1))
  clr2 <- c(rgb(1,0,0,.2),rgb(0,0,1,.2))
  y_grid<-seq(min(data1$texture_mean),max(data1$texture_mean),length=501)
  x_grid<-seq(min(data1$area_mean),2000,length=501)
  z_grid <- outer(x_grid,y_grid,pred_1)
  image(x_grid,y_grid,z_grid,col=clr2,xlab=expression(x[1]),ylab=expression(x[2]),cex=10,cex.lab=1.5, cex.axis=1.5)
  output <- as.factor(data1$diagnosis)
  levels(output) <- c("1","2")
  points(data1$area_mean,data1$texture_mean,pch=19,cex=0.8,col=clr1[as.numeric(output)])
  curve((-breast_cancer_glm3$coefficients[1]-x*breast_cancer_glm3$coefficients[2])/breast_cancer_glm3$coefficients[3],0,2000,add=TRUE)
  legend("topright",inset=0.02, legend=c("y=0 (benign)", "y=1 (malignant)"),
         col=c("red", "blue"), cex=1, pch=c(19,19))#,title="Observed data")
 # legend("topright",inset=0.02,title=,legend=c("boundary decision"),col=c("black"),lty=c(1),border=F,bty="n")

dev.off()



 
  
  
  
  
 