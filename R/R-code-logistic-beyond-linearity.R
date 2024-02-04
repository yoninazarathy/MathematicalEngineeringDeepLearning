pres <- c(rep(0, 7), 1, 0, 0, 1,1,1, 0, rep(1, 11), 
          0, 1,1,1, 0, 1, rep(0, 7))#,rep(0,6))#,1)
prcp <- 10*c(1, 1.4, 1.5, 1.7, 2, 2.1, 2.8, 3, 3.2, 3.3,
          3.5, 3.8, 4, 4.1, 4.4, 4.7, 4.8, 4.9, 5, 5.1, 
          5.3, 5.4, 5.5, 6, 6.1, 6.1, 6.3, 6.4, 6.8, 6.9, 7,
          7.4, 7.9, 8.5, 8.6, 8.7, 8.8, 9)#,14,13,11,15,0.2,0.1,7.5)

model.data <- data.frame(pres, prcp)


glm.model1 <- glm(pres ~ prcp , data = model.data, 
                  family = "binomial")
summary(glm.model1)$coef
glm.model2 <- glm(pres ~ prcp + I((prcp)^2), data = model.data, 
                  family = "binomial")

summary(glm.model2)$coeff



predicted.values.1 <- predict.glm(glm.model1, type = "response")
predicted.values.2 <- predict.glm(glm.model2, type = "response")
plot(pres~prcp,xlab="precipitation",ylab="presence")
points(predicted.values.1~prcp, col ="blue", type = "l")
points(predicted.values.2~prcp, col ="red", type = "l")

library(scales)
library(tidyverse)



#### create a theme
post_theme <- theme_bw() +
  theme(legend.position = "center",
        plot.title = element_text(hjust = 0, size = rel(1.5), face = "bold"),
        plot.margin = unit(c(1, 1, 1, 1), units = "lines"),
        axis.title.x = element_text(color = "Black", size = 16),
        axis.title.y = element_text( color = "Black", size = 16),
        axis.text.x = element_text( color = "Black", size = 16),
        axis.text.y = element_text(color = "Black", size = 16),
        legend.title = element_text(color = "Black", size = 16),
        legend.text = element_text( color = "Black", size = 16))




model.data %>% ggplot(mapping = aes(x = prcp, y = pres)) +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_hline(yintercept = 1, linetype = "dotted") +
  geom_smooth(mapping = aes(color = "Logistic Regression"), method = "glm", formula = y ~ x+I(x^2), method.args = list(family = binomial(link = "logit")), se = TRUE,col="blue") +
  geom_smooth(mapping = aes(color = "Logistic Regression"), method = "glm", formula = y ~ x, method.args = list(family = binomial(link = "logit")),se=FALSE,col="red") +
  geom_jitter(width = 0, height = 0.02,size = 2, alpha = 0.50)+#,position="jitter") +
  scale_y_continuous(breaks = seq(-1, 1, 0.20))+#, labels = percent_format(accuracy = 1)) +
  scale_color_manual(values = c("#0072b2","#d55e00")) +
  #labs(x = expression(x[1]), y=bquote("Predicted probability:" ~ hat(y)), color = "") +
  labs(x = expression(x[1]), y=bquote(~ hat(y)), color = "") +
  
  post_theme

ggsave("Figure-logistic-polynomial-line.pdf",device="pdf", width = 8, height = 8)
ggsave("../../../figures/chapter_3_figures/Figure-logistic-polynomial-line.pdf", width = 10, height = 8)

