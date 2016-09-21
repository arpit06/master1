library(dummies)
library(GGally)
DM <- read.csv(file = "app_metadata_cleaned_removed_min_downloads_above_5m.csv", header = TRUE)
attach(DM)

set.seed(12345)
df <- data.frame(CATEGORY,PRICE, CONTENT_RATING,DOWNLOAD_MIN,MIN_REQ_ANDROID_FIRST,TOTAL_REVIEWS,AVERAGE_RATING)

data <- df
num.vars <- sapply(data, is.numeric)
data[num.vars] <- lapply(data[num.vars], scale)
df <- data

df_new <- dummy.data.frame(df, names = c("CATEGORY","CONTENT_RATING","MIN_REQ_ANDROID_FIRST"), sep = ".")
df_new <- cbind(df_new, spam)
ggcorr(DM)

train_ind<-sample(nrow(df_new),0.7*nrow(df_new))
train <- df_new[train_ind,]
test <- df_new[-train_ind,]
nrow(train)
nrow(test)
#View(test)


bfit <- glm(as.numeric(spam)~., data = train, family = "binomial")
summary(bfit)

predict_train <- predict(bfit, newdata = train[,1:45])
t3 <- ifelse(predict_train > 0.5,1,0)
t3
Confusion_train <- table(as.numeric(train$spam),t3)
Confusion_train
actual <- as.numeric(train$spam)
Metrics <- c("AE","RMSE","MAE")
x1 <- mean(actual-predict_train)
x2 <- sqrt(mean((actual-predict_train)^2))
x3 <- mean(abs(actual-predict_train))
Values <- c(x1,x2,x3)
X <- data.frame(Metrics,Values)
X

predict_test <- predict(bfit, newdata = test[,1:45])
t4 <- ifelse(predict_test > 0.5,1,0)
t4
confusion_test <- table(as.numeric(test$spam),t4)
confusion_test
actual_test <- as.numeric(test$spam)
Metrics <- c("AE","RMSE","MAE")
x1_test <- mean(actual_test-predict_test)
x2_test <- sqrt(mean((actual_test-predict_test)^2))
x3_test <- mean(abs(actual_test-predict_test))
Values <- c(x1_test,x2_test,x3_test)
X_test <- data.frame(Metrics,Values)
X_test

#Under Sampling Data
#Taking all the observations with dependent variable = 1
train_under <- train[train$spam==1,]

#Randomly select observations with dependent variable = 0
zero_spam <- train[train$spam==0,]
set.seed(123457)
rearrangedZero_spams <-  zero_spam[sample(nrow(zero_spam), length(train_under$spam)),]

train_under <- rbind(train_under, rearrangedZero_spams)

bfit_under <- glm(as.numeric(spam)~., data = train_under, family = "binomial")
summary(bfit_under)

predict_train_under <- predict(bfit_under, newdata = train_under[,1:44])
t3_under <- ifelse(predict_train_under > 0.5,1,0)
t3_under
Confusion_train_under <- table(as.numeric(train_under$spam),t3_under)
Confusion_train_under

pt = -2
Accuracy_test_under <- rep(0,20)
predict_test_under <- predict(bfit_under, newdata = test[,1:44])
for (i in 1:40){
  pt = pt +.1
  print(pt) 
  print(i)
  t4_under <- ifelse(predict_test_under > i,1,0)
  confusion_test_under <- table(as.numeric(test$spam),t4_under)
  confusion_test_under
  Accuracy_test_under[i] <- (confusion_test_under[1,1] + confusion_test_under[2,2])/(confusion_test_under[1,1] + confusion_test_under[1,2]
                                                                                     + confusion_test_under[2,1] + confusion_test_under[2,2])
  Accuracy_test_under[i]
  print (Accuracy_test_under[i])
}

plot(c(1,20),c(0,1),type="n", xlab="k",ylab="Accuracy")
lines(Accuracy_test_under,col="red")

library(ROCR)
#
pred <- prediction( predict_train_under, train_under$spam)
perf <- performance( pred, "tpr", "fpr" )

t4_under <- ifelse(predict_test_under > .2459,1,0)
confusion_test_under <- table(as.numeric(test$spam),t4_under)
confusion_test_under
Sensitivity_test_under <- (confusion_test_under[2,2])/(confusion_test_under[2,1]+confusion_test_under[2,2])
Sensitivity_test_under

#
pred_val <- prediction( predict_test_under, test$spam)
perf_val <- performance( pred_val, "tpr", "fpr" )

plot( perf , col="red")
plot (perf_val, add = TRUE, col="green")

perf <- performance( pred, "acc")
perf_val <- performance( pred_val, "acc")
plot( perf , show.spread.at=seq(0, 1, by=0.1), col="red")
plot( perf_val , add= TRUE, show.spread.at=seq(0, 1, by=0.1), col="green")

ind = which.max(slot(perf,"y.values")[[1]])
acc=slot(perf,"y.values")[[1]][ind]
cutoff = slot(perf,"x.values")[[1]][ind]
print(c(accuracy= acc, cutoff= cutoff))


############oversampling data######################
train_over <- train[train$spam==1,]
train_1 <- train_over
for (i in seq(from=1, to=6, by=1)){
  train_over <- rbind(train_over, train_1)
}
train_over
train_oversampling <- rbind(train, train_over)

bfit_over <- glm(as.numeric(spam)~., data = train_oversampling, family = "binomial")
summary(bfit_over)

predict_train_over <- predict(bfit_over, newdata = train_oversampling[,1:44])
t3_over <- ifelse(predict_train_over > 0.5,1,0)
t3_over
Confusion_train_over <- table(as.numeric(train_oversampling$spam),t3_over)
Confusion_train_over

pt = -1
Accuracy_test_over <- rep(0,40)
predict_test_over <- predict(bfit_over, newdata = test[,1:44])
for (i in 1:40){
  pt = pt +.1
  print(pt) 
  print(i)
  t4_over <- ifelse(predict_test_over > pt,1,0)
  confusion_test_over <- table(as.numeric(test$spam),t4_over)
  confusion_test_over
  Accuracy_test_over[i] <- (confusion_test_over[1,1] + confusion_test_over[2,2])/(confusion_test_over[1,1] + confusion_test_over[1,2]
                                                                                  + confusion_test_over[2,1] + confusion_test_over[2,2])
  Accuracy_test_over[i]
  print (Accuracy_test_over[i])
}

plot(c(1,20),c(0,1),type="n", xlab="k",ylab="Accuracy")
lines(Accuracy_test_over,col="red")

library(ROCR)
#
pred_over <- prediction( predict_train_over, train_oversampling$spam)
perf_over <- performance( pred_over, "tpr", "fpr" )

t4_over <- ifelse(predict_test_over > .39896,1,0)
confusion_test_over <- table(as.numeric(test$spam),t4_over)
confusion_test_over
Accuracy_test_over <- (confusion_test_over[1,1] + confusion_test_over[2,2])/(confusion_test_over[1,1] + confusion_test_over[1,2]
                                                                             + confusion_test_over[2,1] + confusion_test_over[2,2])
Sensitivity_test_over <- (confusion_test_over[2,2])/(confusion_test_over[2,1]+confusion_test_over[2,2])
Sensitivity_test_over

#
pred_val_over <- prediction( predict_test_over, test$spam)
perf_val_over <- performance( pred_val_over, "tpr", "fpr" )

plot( perf_over , col="red")
plot (perf_val_over, add = TRUE, col="green")

ind_over = which.max(slot(perf_over,"y.values")[[1]])
acc_over = slot(perf_over,"y.values")[[1]][ind_over]
cutoff_over = slot(perf_over,"x.values")[[1]][ind_over]
print(c(accuracy= acc_over, cutoff= cutoff_over))


###################Bagging + Random Forest + Boosting#####################

Data <- dummy.data.frame(df, sep = ".", names = c("CATEGORY","CONTENT_RATING","MIN_REQ_ANDROID_FIRST"))

colnames(Data)[which(names(Data) == "MIN_REQ_ANDROID_FIRST.Varies with device")] <- "MIN_REQ_ANDROID_FIRST.Varieswithdevice"
colnames(train_under)[which(names(train_under) == "MIN_REQ_ANDROID_FIRST.Varies with device")] <- "MIN_REQ_ANDROID_FIRST.Varieswithdevice"
colnames(train_oversampling)[which(names(train_oversampling) == "MIN_REQ_ANDROID_FIRST.Varies with device")] <- "MIN_REQ_ANDROID_FIRST.Varieswithdevice"
colnames(test)[which(names(test) == "MIN_REQ_ANDROID_FIRST.Varies with device")] <- "MIN_REQ_ANDROID_FIRST.Varieswithdevice"


Data <- cbind(Data, spam)

train_rf_ind <- sample(nrow(Data), .7 * nrow(Data))
train_rf <- Data[train_rf_ind,]
validation_rf <- Data[-train_rf_ind, ]

library(MASS)
library(tree)
library(randomForest)
set.seed(1)
bag.boston=randomForest(factor(spam)~.,data = train_rf[,-1],mtry=44,importance=TRUE)
bag.boston
yhat.bag = predict(bag.boston,newdata=validation_rf)
boston.test=validation_rf$spam
t<- table(boston.test,yhat.bag)
t
Accuracy_test_bag <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_bag
Sensitivity_test_bag <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_bag

importance(bag.boston)
varImpPlot(bag.boston)

##################### Bagging Undersampled data##################

set.seed(1)
bag.boston=randomForest(factor(spam)~.,data = train_under[,-1],mtry=44,importance=TRUE)
bag.boston
yhat.bag = predict(bag.boston,newdata=test)
boston.test=test$spam
t<- table(boston.test,yhat.bag)
t
Accuracy_test_bag <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_bag
Sensitivity_test_bag <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_bag

importance(bag.boston)
varImpPlot(bag.boston)

############################### Bagging Oversampled Data########################

set.seed(1)
bag.boston=randomForest(factor(spam)~.,data = train_oversampling[,-1],mtry=44,importance=TRUE)
bag.boston
yhat.bag = predict(bag.boston,newdata=test)
boston.test=test$spam
t<- table(boston.test,yhat.bag)
t
Accuracy_test_bag <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_bag
Sensitivity_test_bag <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_bag

importance(bag.boston)
varImpPlot(bag.boston)

################### Random Forest #########################
train_rf$spam <- as.factor(train_rf$spam)
set.seed(1)
rf.boston=randomForest(spam~.,data = train_rf[,-1],mtry=7,importance=TRUE)
rf.boston
yhat.rf = predict(rf.boston,newdata=validation_rf)
boston.test=Data[-train_rf_ind,"spam"]

t<- table(boston.test,yhat.rf)
t
Accuracy_test_rf <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_rf
Sensitivity_test_rf <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_rf

importance(bag.boston)
varImpPlot(bag.boston)

################### Random Forest for Undersampled dataset #########################
train_under$spam <- as.factor(train_under$spam)
set.seed(1)
rf.boston=randomForest(spam~.,data = train_under[,-1],mtry=7,importance=TRUE)
rf.boston
yhat.rf = predict(rf.boston,newdata=test)
boston.test= test$spam

t<- table(boston.test,yhat.rf)
t
Accuracy_test_rf <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_rf
Sensitivity_test_rf <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_rf

importance(bag.boston)
varImpPlot(bag.boston)

################### Random Forest  for Oversampled Dataset #########################
train_oversampling$spam <- as.factor(train_oversampling$spam)
set.seed(1)
rf.boston=randomForest(spam~.,data = train_oversampling[,-1],mtry=7,importance=TRUE)
rf.boston
yhat.rf = predict(rf.boston,newdata=test)
boston.test= test$spam

t<- table(boston.test,yhat.rf)
t
Accuracy_test_rf <- (t[1,1] + t[2,2])/(t[1,1] + t[1,2] + t[2,1] + t[2,2])
Accuracy_test_rf
Sensitivity_test_rf <- (t[2,2])/(t[2,1]+t[2,2])
Sensitivity_test_rf

importance(bag.boston)
varImpPlot(bag.boston)

################ Boosting - AdaBoost #####################
library(gbm)
set.seed(1)
boost.boston=gbm(factor(spam)~.,data=train_rf,n.trees=5000,interaction.depth=4, dist="adaboost")
boost.boston
summary(boost.boston)
par(mfrow=c(1,2))

confusion <- function(a, b){
  tbl <- table(a, b)
  mis <- 1 - sum(diag(tbl))/sum(tbl)
  list(table = tbl, misclass.prob = mis)
}
gbm.perf(boost.boston)

prediction <- predict.gbm(boost.boston, newdata = validation_rf, n.trees = 5000, type = "response")  

CM1 <- table(prediction, validation_rf$spam)
CM1

prediction
plot(boost.boston,i="TOTAL_REVIEWS")


yhat.boost=predict(boost.boston,newdata=validation_rf,n.trees=5000)
mean((yhat.boost-boston.test)^2)
boost.boston=gbm(spam~.,data=train_rf,distribution="gaussian",n.trees=5000,interaction.depth=4,shrinkage=0.2,verbose=F)
yhat.boost=predict(boost.boston,newdata=validation_rf,n.trees=5000)
CM1 <- table(yhat.boost, validation_rf$spam)
CM1
mean((yhat.boost-boston.test)^2)


for (i in 1:nrow(validation_rf)){ 
  if(prediction[i] > 0.25) 
    df_validation$z[i] = 1
  else 
    df_validation$z[i] = 0 
} 

confusion_Matrix_Testing <- table(validation_rf$spam, yhat.boost)
confusion_Matrix_Testing

