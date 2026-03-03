# MathematicalEngineeringDeepLearning
Material for The Mathematical Engineering of Deep Learning. See the actual book content on [deeplearningmath.org](https://deeplearningmath.org) or purchase the book from [CRC Press](https://www.routledge.com/Chapman--HallCRC-Data-Science-Series/book-series/CHDSS) / [Amazon](https://www.amazon.com.au/Mathematical-Engineering-Learning-Chapman-Science-ebook/dp/B0DGW9RW1M/).

This repository contains general supporting material for the book.

Below is a detailed list of the source code used for creating figures and tables in the book. We use [Julia](https://julialang.org/), [Python](https://www.python.org/), or [R](https://www.r-project.org/) and the code is sometimes in stand alone files, sometimes in [Jupyter](https://jupyter.org/) notebooks, sometimes as [R Markdown](https://rmarkdown.rstudio.com/), and sometimes in [Google Colab](https://research.google.com/colaboratory/). Many of our static illustrations were created using [TikZ](https://texample.net/tikz/examples/) by [Ajay Hemanth](https://www.linkedin.com/in/ajayhemanth/) and Vishnu Prasath. The TikZ source files are in the [`tikz/`](tikz/) directory of this repository.

### Chapter 1
| Figure  | Topic       | Source Code  |
| ------- | ----------- | -----------  |
| 1.1     | Fast.ai example | [Python Google Colab](https://colab.research.google.com/drive/1YOjnlAqY71PspLn0QzoYl5SmcEmXr4GP?usp=sharing) |
| 1.3     | Architectures   | [TikZ(a)](tikz/figure1-3-a-in_out_neural_network.tex), [TikZ(c)](tikz/figure1-3-c-conv-nn-simple.tex), [TikZ(d)](tikz/figure1-3-d-recursive_graph.tex) |
| 1.4     | Neurons         | [TikZ(b)](tikz/figure1-4-b-dendrites_with_synaptic_weights_axons.tex) |
| 1.5     | Data on earth   | [Julia](Julia/data_world_in_zb.ipynb) |

### Chapter 2
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 2.1    | Supervised Learning | [TikZ](tikz/figure2-1-training_prediction.tex) |
| 2.2    | Unsupervised Learning | [TikZ](tikz/figure2-2-clustering_reduction.tex) |
| 2.3    | Simple regression | [R](R/Simple_Regression.R) |
| 2.4    | Breast Cancer ROC curves | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Breast_Cancer_ROC_curves.R) |
| 2.5    | Least Squares | [TikZ](tikz/figure2-5-plot_sum_squares.tex) |
| 2.6    | Loss functions | [Julia](Julia/LossFunctions.ipynb) |
| Table 2.1 | Linear MNIST classification | [Julia](Julia/LinearMNIST_3_ways.ipynb) |
| 2.7    | Gradient Descent Learning Rate  | [Python](Python/Learning-Rate-Matters-GD-linear.ipynb) |
| 2.8    | Loss Landscape  | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Loss_Landscape.R) |
| 2.9    | Generalization and Training | [TikZ](tikz/figure2-9-error_modelcomplexity.tex) or [Julia](Julia/Expected_Performance_Curves.ipynb) |
| 2.10   | Polynomial fit | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Polynomial_fit.R) |
| 2.11   | K-fold cross validation | [TikZ](tikz/figure2-11-kfold_cross_validation.tex) |
| 2.12   | K-means clustering | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/kmeans-clustering.R) |
| 2.13   | K-means image segmentation | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/K-means-image-segmentation.R) |
| 2.14   | Breast Cancer PCA | [R](https://github.com/yoninazarathy/MathematicalEngineeringDeepLearning/blob/master/R/Breast_Cancer_PCA.R) |
| 2.15   | SVD Compression | [Julia](Julia/SVD_compression.ipynb) |

### Chapter 3
| Figure | Topic           | Source Code          |
| ------ | --------------- | -----------          |
| 3.1 and 3.2    | Logistic regression model curves and boundary | [R](R/R-code-logistic-smooth-link.R)  |
| 3.3    | Components of an artificial neuron | [TikZ](tikz/figure3-3-logistic_architecture.tex) |
| 3.4    | Loss landscape of MSE vs. CE on logistic regression | [Python](Python/loss_landscapes_logistic.py) |
| 3.5    | Evolution of gradient descent learning in logistic regression | [R(a,b) First file](R/Gradient_Descent_logistic.R), [R(a,b) Second file](R/Function-for-Gradient-Descent-Logistic.R) |
| 3.6    | Shallow multi-output neural network with softmax | [TikZ](tikz/figure3-6-softmax_layer.tex) |
| 3.7    | Multinomial regression for classification | [R](R/Figure-softmax-boundary-4-classes.R) |
| Table 3.1 | Different approaches for creating an MNIST digit classifier. | [Julia]() |
| 3.8    | Feature engineering in simple logistic regression | [R](R/R-code-logistic-beyond-linearity.R) |
| 3.9    | Non-linear classification decision boundaries with feature engineering in logistic regression | [R](R/R-code-Figure-versatile-Boundaries.R) |
| 3.10   | Non-linear classification decision boundaries with feature engineering in multinomial regression | [R](R/Figure-softmax-boundary-4-classes.R) same as 3.7 |
| 3.11 | Single hidden layer autoencoder | [TikZ](tikz/figure3-11-bottleneck_autoencoder.tex) |
| 3.12 | Autoencoder projections of MNIST including using PCA | [R](R/R-code-section-autoencoder.R) [TikZ](tikz/figure3-12-autoencoder_reconstruction.tex) |
| 3.13 | Manifolds and autoencoders | [R](R/simple-autoencoder-experiment.R) [TikZ](tikz/figure3-13-pca-ae-manifolds.tex) |
| 3.14 | MNIST using autoencoders | [R](R/R-code-section-autoencoder.R) same as 3.12 |
| 3.15 | Denoising autoencoder | [TikZ](tikz/figure3-15-reconstructing_input.tex) |
| 3.16 | Interpolations with autoencoders | [R](R/R-code-section-autoencoder.R) same as 3.12, [TikZ](tikz/figure3-16_interpolation.tex) |


### Chapter 4
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 4.1    | Convexity and local/global extrema   |    [Python](Python/Convexity_and_local_extrema.py)  |
| 4.2    | Gradient descent with fixed or time dependent learning rate |  [Python](Python/GD-with-timde-dependent-alpha.py)  |
| 4.3    | Stochastic gradient descent |  [Python](Python/Stochastic-gradient-descent.py)  |
| 4.4    | Early stopping in deep learning |  [Julia]()  |
| 4.5    | Non-convex loss landscapes |  [Python](Python/Momentum-enhanced-GD.py)  |
| 4.6    | Momentum enhancing gradient descent |  [Python](Python/Non-convex-landscapes.py)  |
| 4.7    | The computational graph for automatic differentiation |  [TikZ](tikz/figure4-7-computational_graph.tex)  |
| 4.8    | Line search concepts |  [Python](Python/Line-search-concepts.py)  |
| 4.9    | The zig-zagging property of line search | [Python](Python/The-zig-zagging-of-exact-line-search.py)  |
| 4.10    | Newton's method in one dimension | [Python](Python/Newton-method-in-one-dimension.py)  |


### Chapter 5
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 5.1    | Fully Connected Feedforward Neural Networks | [TikZ(a)](tikz/figure5-1-a-one_hidden_layer.tex), [TikZ(b)](tikz/figure5-1-b-deep_neural_network.tex)   |
| 5.2    | Arbitrary function approximation with neural nets  | [TikZ(a)](tikz/figure5-2-a-realvalue_function_approximation.tex), [Julia(b,c)]()   |
| 5.3    | Binary classification with increasing depth |  [R](R/Figure_expressivity.R) |
| 5.4    | A continuous multiplication gate with 4 hidden units | [TikZ](tikz/figure5-4-multiplication_gate.tex)  |
| 5.5    | A deep model with 10 layers | [TikZ](tikz/figure5-5-deep_polynomial_model.tex)  |
| 5.6    | Several common scalar activation functions |  [Julia(a,b)]()  |
| 5.7    | Flow of information in general back propagation | [TikZ](tikz/figure5-7-initial_gradient_values.tex)  |
| 5.8    | Simple neural network hypothetical example | [TikZ](tikz/figure5-8-scalar_hidden_units.tex) |
| 5.9    | Flow of information in standard neural network back propagation | [TikZ](tikz/figure5-9-advanced_gradient_values.tex) |
| 5.10   | Computational graph for batch normalization | [TikZ](tikz/figure5-10-batch_norm_comp_graph.tex) |
| 5.11   | The effect of dropout  | [TikZ](tikz/figure5-11-dropout.tex)                    |

### Chapter 6
| Figure | Topic           | Source Code          |
| ------ | --------------- | -----------          |
| 6.2    | VGG19 architecture | [TikZ](tikz/figure6-2-vgg19.tex)        |
| 6.3    | Convolutions | [TikZ(a)](tikz/figure6-3-a-convolution.tex), [TikZ(b)](tikz/figure6-3-b-element-of-convolution.tex) |
| 6.6    | Convolution padding | [TikZ](tikz/figure6-6-padding.tex) |
| 6.7    | Convolution stride | [TikZ](tikz/figure6-7-stride.tex) |
| 6.8    | Convolution dilation | [TikZ](tikz/figure6-8-dilation.tex) |
| 6.9    | Convolution input channels | [TikZ](tikz/figure6-9-input-channels.tex) |
| 6.10   | Convolution output channels | [TikZ](tikz/figure6-10-output-channels.tex) |
| 6.11   | Pooling | [TikZ(a)](tikz/figure6-11-a-max-pooling.tex), [TikZ(b)](tikz/figure6-11-b-average-pooling.tex) |
| 6.13   | Inception module | [TikZ](tikz/figure6-13-inception-module.tex) |
| 6.14   | Resnets | [TikZ](tikz/figure6-14-resnet.tex) |
| 6.17   | Siamese network | [TikZ]() |


### Chapter 7
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 7.1    | Sequence RNN tasks | [TikZ(a)](tikz/figure7-1-a-look-ahead-prediction.tex), [TikZ(b)](tikz/figure7-1-b-recurrent-sentiment.tex), [TikZ(c)](tikz/figure7-1-c-basic-encoder-decoder.tex), [TikZ(d)](tikz/figure7-1-d-image-to-text.tex) |
| 7.2    | Sequence RNN input output paradigms | [TikZ(a)](tikz/figure7-2-a-one-to-many.tex), [TikZ(b)](tikz/figure7-2-b-many-to-one.tex), [TikZ(c)](tikz/figure7-2-c-many-to-many-1.tex), [TikZ(d)](tikz/figure7-2-d-many-to-many-2.tex) |
| 7.3    | RNN recursive graph and unfolded graph | [TikZ](tikz/figure7-3-unrolling-rnn.tex) |
| 7.4    | RNN unit | [TikZ](tikz/figure7-4-rnn-unit.tex) |
| 7.5    | RNN language prediction training | [TikZ](tikz/figure7-5-rnn-simple-example.tex) |
| 7.6    | Backpropagation  through time | [TikZ](tikz/figure7-6-back-prop-through-time.tex) |
| 7.7    | Alternative RNN configurations | [TikZ(a)](tikz/figure7-7-a-bidirectional-rnn.tex), [TikZ(b)](tikz/figure7-7-b-stacked-rnn.tex) |
| 7.8    | LSTM and GRU | [TikZ(a)](tikz/figure7-8-a-lstm.tex), [TikZ(b)](tikz/figure7-8-b-gru.tex) |
| 7.9    | Encoder decoder architectures | [TikZ(a)](tikz/figure7-9-a-encoder-decoder-basic.tex), [TikZ(b)](tikz/figure7-9-b-encoder-decoer-enriched.tex) |
| 7.10   | Encoder decoder with attention | [TikZ](tikz/figure7-10-encoder-decoder-attention.tex) |
| 7.11   | Attention weights | [TikZ](tikz/figure7-11-attention-matrix.tex) |
| 7.12   | Flow of information with self attention | [TikZ](tikz/figure7-12-self-attention.tex)  |
| 7.13   | Multi-head self attention | [TikZ](tikz/figure7-13-Multi-head-self-attention.tex) |
| 7.14   | Positional embedding | [Julia(a,b)]() |
| 7.15   | Transformer blocks | [TikZ(a)](tikz/figure7-15-a-transformer-block.tex), [TikZ(b)](tikz/figure7-15-b-transformer-decoder-block.tex) |
| 7.16   | Transformer encoder decoder architecture | [TikZ](tikz/figure7-16-transformer-encoder-decoder.tex) |
| 7.17   | Transfomer auto-regressive application | [TikZ](tikz/figure7-17-transformer-encoder-decoder-unrolling.tex) |


### Chapter 8
| Figure | Topic           | Source Code        |
| ------ | --------------- | -----------        |
| 8.1   | Generative modelling | [TikZ](tikz/figure8-1-general-generative-diff-gan.tex)  |
| 8.2   | Variational autoencoder | [TikZ](tikz/figure8-2-vae-encoder-decoder.tex) |
| 8.4   | Diffusion encoder and decoder | [TikZ](tikz/figure8-4-markovian-vae-latent-steps.tex) |
| 8.6   | GAN architectures | [TikZ](tikz/figure8-6-GAN-architecture.tex) |
| 8.7   | Separation of GAN distributions | [TikZ](tikz/figure8-7-GAN-Generator-Distributions-Signal.tex) |
| 8.8   | Wasserstein distance | [TikZ](tikz/figure8-8-DIFFERENT-LATEX-COMPILER-wgan-joint-distribution.tex) |
| 8.9   | Reinforcement learning | [TikZ](tikz/figure8-9-RL-agent-envior.tex) |
| Equation (8.72) | An MDP optimal policy  | [Julia]() |
| 8.10   | Applications of GNN | [TikZ(a)](tikz/figure8-10-a-social-networks-data.tex), [TikZ(b)](tikz/figure8-10-b-knowledge-graphs-data.tex), [TikZ(c)](tikz/figure8-10-c-molecules.tex) |
| 8.11   | Directed and undirected graphs | [TikZ(a)](tikz/figure8-11-a-undirected-graphs.tex), [TikZ(b)](tikz/figure8-11-b-directed-graphs.tex) |
| 8.12   | Transductive inductive learning | [TikZ(a)](tikz/figure8-12-a-big-graph-for-transductive-learning.tex), [TikZ(b)](tikz/figure8-12-b-several-small-graphs-for-inductive-learning.tex) |
| 8.13   | Types of GNN tasks | [TikZ(a)](), [TikZ(b)](), [TikZ(c)]() |
| 8.14   | Aggregation in message passing  | [TikZ(a)](tikz/figure8-14-a-message-passing-input-graph.tex), [TikZ(b)]() |
