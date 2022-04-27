load("Breast_cancer.RData")
head(Breast_cancer_data[,c(1:6)])
data <- Breast_cancer_data
dim(data)

require(FactoMineR)
library(ggplot2)
library(dplyr)


pca <- PCA(data[,-c(1,2)],ncp=2,graph=FALSE)
dat <- data.frame(data,pc1=pca$ind$coord[,1],pc2=pca$ind$coord[,2],diagnosis=as.factor(data[,2]))

p <- ggplot(data = dat, aes(x = pc1, y = pc2, color = diagnosis))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  geom_point(alpha = 0.8) + theme_bw()

p

dat <- dat %>% filter(pc1<7 & pc2<10) 

p1 <- ggplot(data = dat, aes(x = pc1, y = pc2))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  xlab(TeX(r'($pc_1$)')) + ylab(TeX(r'($pc_2$)'))+
  geom_point(alpha = 0.8,size=2.5) + theme_bw()
 
p1 + theme(axis.text = element_text(size = 20))+ theme(axis.title = element_text(size = 20))   






ggsave("breast-pca1-a.pdf",device="pdf", width = 8, height = 8)





p2 <- ggplot(data = dat, aes(x = pc1, y = pc2, color = diagnosis))+
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = 0, lty = 2) +
  xlab(TeX(r'($pc_1$)')) + ylab(TeX(r'($pc_2$)'))+
  geom_point(alpha = 0.8,size=2.5) + theme_bw()+
  theme(legend.position=c(0.15,0.85),legend.title=element_blank())
p3 <- p2 +  scale_color_discrete( labels = c("benign", "malignant"))

p3 + theme(legend.text=element_text(size=20),axis.text = element_text(size = 20))+ theme(axis.title = element_text(size = 20))   

ggsave("breast-pca1-b.pdf",device="pdf", width = 8, height = 8)


library(ggpubr)
ggarrange(p1,p2)
