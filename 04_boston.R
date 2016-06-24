set.seed(6)
library(MASS)
library(plyr)
library(Metrics)
data <- Boston
#apply(data,2,function(x) sum(is.na(x)))

index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]
fit <- glm(medv~., data=train)
pr <- predict(fit,test)
MSE <- sum((pr - test$medv)^2)/nrow(test)
RMSE <- sqrt(mean((pr-test$medv)^2))

library(neuralnet)
n <- names(train)
f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + ")))
ann_c <- neuralnet(f,data=train,hidden=c(7,3),linear.output=T)

plot(ann_c)

mean(data$medv)
output <- compute(ann_c, test[-14])
net.predict <- output$net.result
