#ML in 180 Minutes group/self exercise...

#Download training design matrix and labels 
A <- read.csv(url("https://raw.githubusercontent.com/yoninazarathy/MathematicalEngineeringDeepLearning/master/ML180Minutes/A_3vs8_matrix_train.csv"))
y <- read.csv(url("https://raw.githubusercontent.com/yoninazarathy/MathematicalEngineeringDeepLearning/master/ML180Minutes/y_3vs8_vector_train.csv"))

#Download testing design matrix (each row is an image) for the digit "3" (positive)
A3test <- read.csv(url("https://raw.githubusercontent.com/yoninazarathy/MathematicalEngineeringDeepLearning/master/ML180Minutes/A_3_test.csv"))

#Download testing design matrix (each row is an image) for the digit "8" (negative)
A8test <- read.csv(url("https://raw.githubusercontent.com/yoninazarathy/MathematicalEngineeringDeepLearning/master/ML180Minutes/A_8_test.csv"))

#Task 1: Finding the least squares beta based on A and y. 
  #Taks 1a: Do this via the pseudoinverse, or GLM, or similar.
  #Task 1b: Do this via an iterative gradient descent implementation
#Task 2: Evaluate the accuracy of the estimator(s) from task 1 on the accuracy