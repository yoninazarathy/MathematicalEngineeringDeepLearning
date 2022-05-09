# MathematicalEngineeringDeepLearning
Material for The Mathematical Engineering of Deep Learning. See the actual book content on [deeplearningmath.org](https://deeplearningmath.org) or (when it is out) purchase the book from CRC press.

This repository contains general supporting material for the book.

Below is a detailed list of the source code used for creating figures and tables in the book. We use [Julia](https://julialang.org/), [Python](https://www.python.org/), or [R](https://www.r-project.org/) and the code is sometimes in stand alone files, sometimes in [Jupyter](https://jupyter.org/) notebooks, sometimes as [R Markdown](https://rmarkdown.rstudio.com/), and sometimes in [Google Colab](https://research.google.com/colaboratory/). Many of our static illustrations were created using [TikZ](https://texample.net/tikz/examples/) by [Ajay Hemanth](https://www.linkedin.com/in/ajayhemanth/) and Vishnu Prasath with the [source of their illustrations](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ) also available so you can adapt it for purposes. 

### Chapter 1
| Figure  | Topic       | Source Code  |
| ------- | ----------- | -----------  |
| 1.1     | Fast.ai example | [Python Google Colab](https://colab.research.google.com/drive/1YOjnlAqY71PspLn0QzoYl5SmcEmXr4GP?usp=sharing) |  
| 1.3     | Architectures   | [TikZ(a)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/in_out_neural_network.tikz), [TikZ(b)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/convolution_nn.tex), [TikZ(c)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/recursive_graph.tikz), [TikZ(d)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/circuit_diagram.tikz), [TikZ(e)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/encoder_decoder.tikz), [TikZ(f)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/predicted_lables.tikz) |  
| 1.4     | Neurons         | [TikZ(b)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/dendrites_with_synaptic_weights_axons.tex), [TikZ(d)](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/simple_neural_network.tikz) |  
| 1.5     | Data on earth   | [Julia](Julia/data_world_in_zb.ipynb) |  

### Chapter 2
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 2.1    | Supervised Learning | [TikZ](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/training_prediction.tex) |  
| 2.2    | Unsupervised Learning | [TikZ](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/clustering_reduction.tex) |  
| 2.3    | Simple regression | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Simple_Regression.R) |  
| 2.4    | Breast Cancer ROC curves | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Breast_Cancer_ROC_curves.R) |  
| 2.5    | Least Squares | [TikZ](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/plot_rectangles.tex) |  
| 2.6    | Loss functions | [Julia](Julia/LossFunctions.ipynb) |  
| Table 2.1 | Linear MNIST classification | [Julia](Julia/LinearMNIST_3_ways.ipynb) |
| 2.7    | Gradient Descent Learning Rate  | [Python](Python/Learning-Rate-Matters-GD-linear.ipynb) |  
| 2.8    | Loss Landscape  | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Loss_Landscape.R) |  
| 2.9    | Generalization and Training | [TikZ](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/error_modelcomplexity.tex) or [Julia](Julia/Expected_Performance_Curves.ipynb) |  
| 2.10    | Polynomial fit | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Polynomial_fit.R) |  
| 2.11   | K-fold cross validation | [TikZ](https://github.com/ajayhemanth/The-Mathematical-Engineering-of-Deep-Learning---TikZ/blob/main/source_tikz/kfold_cross_validation.tex) |  
| 2.12   | K-means clustering | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/kmeans-clustering.R) |  
| 2.13   | K-means image segmentation | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/K-means-image-segmentation.R) |  
| 2.14   | Breast Cancer PCA | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Breast_Cancer_PCA.R) |  
| 2.15   | SVD Compression | [Julia](Julia/SVD_compression.ipynb) |

### Chapter 3 (Figures under construction)
| Figure | Topic           | Source Code          |
| ------ | --------------- | -----------          |
| 3.1    | Logistic regression model curves | [R(a)]() [R(b)]() |        
| 3.2    | Linear decision boundary for logistic regression | [R]()   |  
| 3.3    | Components of an artificial neuron | [TikZ]() |
| 3.4    | Loss landscape of MSE vs. CE on logistic regression | [Python]() |
| 3.5    | Evolution of gradient descent learning in logistic regression | [R]() |
| 3.6    | Multinomial regression for classification | [R]() |
| 3.7    | Shallow multi-output neural network with softmax | [TikZ]() |
| 3.8    | Feature engineering in simple logistic regression | [R]() |
| 3.9    | Non-linear classification decision boundaries with feature engineering in logistic regression | [R]() |
| 3.10   | Non-linear classification decision boundaries with feature engineering in multinomial regression | [R]() |
| 3.11 | Single hidden layer autoencoder | [TikZ]() |
| 3.12 | Autoencoder projections of MNIST including using PCA | [R]() |
| 3.13 | Reconstruction of MNIST using autoencoders | [R]() |
| 3.14 | Denoising autoencoder | [TikZ]() |
| 3.15 | Denoising autoencoder used for MNIST | [R]() |


### Chapter 4 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 4.1    | Convexity and local/global extrema   |    [Python]()  |  
| 4.2    | Saddle points   |  [Python]()  | 
| 4.3    | Various parameters of gradient descent |  [Python]()  | 
| 4.4    | Stochastic gradient descent |  [Python]()  | 
| 4.5    | Early stopping in deep learning |  [Python]()  | 
| 4.6    | Momentum and RMS Prop enhancing gradient descent |  [Python]()  | 
| 4.7    | Nesterov and other variations of gradient descent |  [Python]()  | 
| 4.8    | Performance of second order methods             |    | 
| 4.9    | Computational graph for automatic differentiation            |  [TikZ]()  | 

### Chapter 5 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 5.1    | Fully Connected Feedforward Neural Networks | [TikZ(a)](), [TikZ(b)]()   |  
| 5.2    | Arbitrary function approximation with neural nets  | [Julia]()   |  
| 5.3    | Binary classification with increasing depth |  [R]() |  
| 5.4    | A continuous multiplication gate with 4 hidden units | [TikZ]()  |  
| 5.5    | Several common scalar activation functions |  [Julia]()  |  
| 5.6    | Flow of information in general back propagation | [TikZ]()  |  
| 5.7    | Simple neural network hypothetical example | [TikZ]() |  
| 5.8    | Flow of information in standard neural network back propagation | [TikZ]() |  
| 5.9    | Computational graph for batch normalization | [TikZ]() |  
| 5.10    | The effect of dropout  | [TikZ]()                    |  
| 5.11    | TBD             |                    |  
| 5.12    | TBD             |                    |  

### Chapter 6 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 6.1    | TBD             |                    |  

### Chapter 7 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 7.1    | TBD             |                    |  

### Chapter 8 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 8.1    | TBD             |                    |  

### Chapter 9 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 9.1    | TBD             |                    |  

### Chapter 10 (Figures under construction)
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 10.1    | TBD             |                    |  