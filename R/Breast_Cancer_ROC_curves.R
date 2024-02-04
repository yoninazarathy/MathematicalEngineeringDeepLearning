load("../data/Breast_cancer.RData")
head(Breast_cancer_data[,c(2:6)])
data <- Breast_cancer_data
dim(data)
data <- data %>% mutate(diagnosis_0_1 = ifelse(diagnosis == "M", 1, 0))

library(ROCR)
library(caret)
set.seed(101)
training <- createDataPartition(data$diagnosis_0_1, p=0.8, list=FALSE)
train <- data[ training, ]
test <- data[ -training, ]



trainfull <- train[,-c(1,2)]
uni.model <- glm(diagnosis_0_1~smoothness_worst,family=binomial,data=train)
full.model <- glm(diagnosis_0_1~.,family=binomial,data=trainfull)



p = predict(uni.model, train, type="response")
pr1 = prediction(p, train$diagnosis_0_1)
prf1 = performance(pr1, measure = "tpr", x.measure = "fpr")


p = predict(full.model, trainfull, type="response")
pr3 = prediction(p, trainfull$diagnosis_0_1)
prf3 = performance(pr3, measure = "tpr", x.measure = "fpr")





p = predict(uni.model, test, type="response")
pr1 = prediction(p, test$diagnosis_0_1)
prf1 = performance(pr1, measure = "tpr", x.measure = "fpr")

p = predict(full.model, test, type="response")
pr3 = prediction(p, test$diagnosis_0_1)
prf3 = performance(pr3, measure = "tpr", x.measure = "fpr")




auc1 = performance(pr1, measure = "auc")
auc1 = auc1@y.values[[1]]
auc3 = performance(pr3, measure = "auc")
auc3 = auc3@y.values[[1]]
print(paste("AUC uni test", auc1))
print(paste("AUC full test", auc3))


library(ROCit)
r1=rocit(predict(uni.model, test), test$diagnosis_0_1, method = "bin")

r3=rocit(predict(full.model, test), test$diagnosis_0_1, method = "bin")


pdf(file="ROC-curve-chapt2.pdf", height=10, width=10)
par(mar = c(5.1, 5.1, 4.1, 2.1))
plot(r1$TPR~r1$FPR, type = "l", xlab = "False Positive Rate", lwd = 2,
     ylab = "Sensitivity", col= "gold4",cex.lab=2,cex.axis = 2)
grid()
lines(r3$TPR~r3$FPR, lwd = 2, col = "orange")
segments(0,0,1,1, col = "2", lwd = 2)
segments(0,0,0,1, col = "darkgreen", lwd = 2)
segments(1,1,0,1, col = "darkgreen", lwd = 2)

legend("bottomright", c("Perfectly Separable", 
                        "Univariate", "Full model", "Chance Line"), cex=2,
       lwd = 2, col = c("darkgreen", "gold4",
                        "orange", "red"), bty = "n")

dev.off()

