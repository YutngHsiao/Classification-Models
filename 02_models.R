library(caret)

data <- spambase
inTrain <- createDataPartition(y=data[,length(data)],p=.7,list=F)
Tv <- data1[inTrain,]
tv <- data1[-inTrain,]

f <- as.formula(paste0(names(Tv)[length(Tv)], "~", paste(names(Tv)[-length(Tv)], collapse = " + ")))

### ANN
library(nnet)
ann2 <-nnet(f,data=Tv,size=10,decay=0.1)
clas_ann2 <- table(actual=tv[,ncol(tv)], predicted=predict(ann2,newdata=tv,type="class"))
mis_ann2 <- (clas_ann2[1,2]+clas_ann2[2,1])/sum(clas_ann2)
###
#library(devtools)
#source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
#plot.nnet(ann2)

### SVM
library(e1071)
svm <- svm(f,data=Tv)
clas_svm <- table(actual=tv[,ncol(tv)], predicted=predict(svm,newdata=tv,type="class"))
mis_svm <- (clas_svm[1,2]+clas_svm[2,1])/sum(clas_svm)

### rf
library(randomForest)
rf <- randomForest(f,data=Tv)
clas_rf <- table(actual=tv[,ncol(tv)], predicted=predict(rf,newdata=tv,type="class"))
mis_rf <- (clas_rf [1,2]+clas_rf [2,1])/sum(clas_rf )

### FDA
fda <- fda(f,data=Tv)
clas_fda <- table(actual=tv[,ncol(tv)],predicted=predict(fda,newdata=tv,type="class"))
mis_fda <- (clas_fda[1,2]+clas_fda[2,1])/sum(clas_fda)

### MDA
mda<-mda(f,data=Tv)
clas_mda <- table(actual=tv[,ncol(tv)],predicted=predict(fda,newdata=tv,type="class"))
mis_mda <- (clas_mda[1,2]+clas_mda[2,1])/sum(clas_mda)

### KNN
knn<-knn(train=Tv,test=tv,cl = Tv[,length(Tv)],k = 5)
clas_knn <- table(predicted=knn,acttual=tv[,length(tv)])
mis_knn <- (clas_knn[1,2]+clas_knn[2,1])/sum(clas_knn)

### Dtree
library(rpart)
library(nutshell)
library(maptree)
stree <- rpart(f ,data=Tv)
p_stree <- draw.tree(stree,nodeinfo=T,cex=0.5,col=gray(0:8/8))
clas_stree <- table(actual=tv[,ncol(tv)],prediction=predict(stree,newdata=tv,type="class"))
mis_stree <- (clas_stree[1,2]+clas_stree[2,1])/sum(clas_stree)

### Performance list
Mis_classification <- cbind(c("ANN", "SVM", "Random Forest", "FDA", "MDA", "KNN", "Decision Tree"), 
      c(1-round(mis_ann2,2), 1-round(mis_svm,2), round(1-mis_rf,2), round(1-mis_fda,2), 
        1-round(mis_mda,2), 1-round(mis_knn,2), 1-round(mis_stree,2) ))

