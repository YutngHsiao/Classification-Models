library(boot)
library(plyr) 
library(caret)
library(neuralnet)
library(ggplot2)
library(MASS)

nonspam <- spambase[spambase$spam==0,1:57]
spam <- spambase[spambase$spam==1,1:57]
spammean <- colMeans(spam)
nonspammean <- colMeans(nonspam)
spammean <- log10(spammean)
nonspammean <- log10(nonspammean)
plot(spammean, type="o", col="blue",xlab="Variables V1 to V57", ylab="Mean Values of log10")
lines(nonspammean, type="o", col="red")
title(main="Mean comparism")
### NZV level
cut <- 99/1

sample <- preProcess(spambase[, -58], method=c("BoxCox", "center", "scale"))
sample <- predict(sample, spambase[, -58])
nzv <- nearZeroVar(sample, freqCut = cut, saveMetrics=TRUE)
sample <- sample[,nzv$nzv==FALSE]
sample <- round(sample,2)
spam <- spambase[,58]
sample <- cbind(sample, spam)
#fit <- glm(spam ~.,sample, family = "binomial")
set.seed(666)
inTrain=createDataPartition(y=sample$spam,p=.7,list=F)
Tv <-sample[inTrain,]
tv <-sample[-inTrain,]
###
n <- names(Tv)
f <- as.formula(paste0(n[length(n)], "~", paste(n[-length(n)], collapse = " + ")))

ann <- neuralnet(f, data = Tv, hidden = c(3,2), stepmax =5000, learningrate=.1, threshold = .1, err.fct = "ce", linear.output = FALSE)

plot(ann, rep="best")

net.predict <- compute(ann, Tv[-ncol(Tv)])$net.result
ann_result <- ifelse(net.predict>0.5, 1, 0)
mis_test <- mean(Tv$spam != annpv5_test)
mis_test

ci <- confidence.interval(ann, alpha = 0.05)
ci

### Cross Validation

library(plyr) 
set.seed(450)
cv.error <- NULL
k <- 10

pbar <- create_progress_bar('text')
pbar$init(k)

for(i in 1:k){
  index <- sample(1:nrow(Sampledata5V),round(0.7*nrow(Sampledata5V)))
  train.cv <- Sampledata5V[index,]
  test.cv <- Sampledata5V[-index,]
  nn <- neuralnet(formula = spam ~ v19+v50+v52+v53+v57, data = train.cv, hidden = 2, err.fct = "ce", linear.output = FALSE)
  pr.nn <- compute(nn, test.cv[-6])$net.result
  pr.nn <- ifelse(net.predict>0.5, 1, 0)
  cv.error[i] <- mean(Tv$spam != annpv5_test)
  pbar$step()
}

mean(cv.error)
cv.error

boxplot(cv.error,xlab='Misclassification Rate',col='cyan',
        border='blue',names='CV Misclassification Rate',
        main='CV error (MSE) for MLP network 5 inputs 1 layer 2 nodes',horizontal=TRUE)

for(i in 1:k){
  index <- sample(1:nrow(Tv),round(0.9*nrow(Tv)))
  train.cv <- Sampledata5V[inTrain,]
  test.cv <- Sampledata5V[-inTrain,]
  
  nn <- neuralnet(formula = spam ~ v19+v50+v52+v53+v57, data = Tv, hidden = 2, err.fct = "ce", linear.output = FALSE)
  
  pr.nn <- compute(nn,Tv[-6])
  pr.nn <- pr.nn$net.result
  test.cv.r <- Tv$spam
  
  cv.error[i] <- sum((test.cv.r - pr.nn)^2)/nrow(Tv)
  
  pbar$step()
}

sum((Tv$spam - net.predict)^2)/nrow(Tv)
net.predict
mean(cv.error)
cv.error

boxplot(misc,xlab='MSE CV',col='cyan',
        border='blue',names='CV error (MSE)',
        main='CV error (MSE) for MLP network 5 inputs 1 layer 2 nodes',horizontal=TRUE)