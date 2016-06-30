# Classification-Models ANN, Decision tree, etc.
This analysis represents an exploration of SPAM filtering algorithms which base on Artificial 
Neural Network and then determine whether an email is SPAM. As a result, more than 90% of 
SPAM can be successfully identified.

We can simulate the ANN network with different layers and nodes, finally the network model can be compared with the other classification methods: Decision tree, SVM, K-mean, etc. The effect of different pre-processing criterions can also be observed through the simulation.

# Data sources
SPAMbase, Boston

# Pre-process
Data pre-processing includes 4 steps:
1.  Data transformation: center, scale, and Box-Cox transformation
2.  Filtering highly correlated predictors
3.  Removing near zero-variance predictors
4.  Split dataset into training and testing sets

# Visulization
ANN network and Decision tree

#Conclusion
There are many rule-of-thumb methods for determining the correct number of neurons
using in hidden layers:
- The number of neurons should be between the size of the input layer and output.
- The number of neurons should be 2/3 the sum of input and output.
- The number of neurons should be less than twice the size of the input.

Iteration has positive trend with the complexity of network.  ANN tends 
to  stop at the  number of iteration where the validation performance reached a minimum.
The Delta Rule uses gradient descent learning to iteratively change network weights to 
minimize error. While the network is growing bigger, more iterations are required in 
order to satisfactorily minimize error. 

The significance of weights change with the number of neurons.


#DEMO
 https://jony0912.shinyapps.io/ANN_simulator/
