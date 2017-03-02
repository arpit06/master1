setwd("C:/Users/Arpit/Desktop/UMD_All_Material/COURSEWORK/Spring,17/DataMining/Datafiles")
#1
#1a.
Voter <- read.csv(file = "VoterPref.csv", header = TRUE)
attach(Voter)

PREFERENCE <- factor(PREFERENCE,levels=c("For","Against"))
PREF <- as.numeric(PREFERENCE)-1
Voter<-cbind(Voter, PREF)
View(Voter)

#1b.
set.seed(123457)

#1c.
train_ind<-sample(nrow(Voter),0.7*nrow(Voter))
train <- Voter[train_ind,]
test <- Voter[-train_ind,]
nrow(train)
nrow(test)

#2.
#2a.
fit1 <- glm(as.numeric(PREF)~AGE+INCOME+factor(GENDER), family = "binomial", data = train)
summary(fit1)

Cutoff <- 0.5
predicted_train_logistic <- predict(fit1, newdata = train, type = "response")
predicted_train_logistic
t3 <- ifelse(predicted_train_logistic > Cutoff,1,0)
t3
confusion_logistic_train <- table(as.numeric(train$PREF),t3)
confusion_logistic_train

predicted_test_logistic <- predict(fit1, newdata = test, type = "response")
predicted_test_logistic
t4 <- ifelse(predicted_test_logistic > Cutoff,1,0)
t4
confusion_logistic_test <- table(as.numeric(test$PREF),t4)
confusion_logistic_test


#2b.
Sensitivity_logistic_train <- (confusion_logistic_train[2,2])/(confusion_logistic_train[2,1]+confusion_logistic_train[2,2])
Sensitivity_logistic_train

Accuracy_logistic_train <- (confusion_logistic_train[1,1] + confusion_logistic_train[2,2])/(confusion_logistic_train[1,1] + confusion_logistic_train[1,2]
+ confusion_logistic_train[2,1] + confusion_logistic_train[2,2])
Accuracy_logistic_train

Specificity_logistic_train <- (confusion_logistic_train[1,1])/(confusion_logistic_train[1,1]+confusion_logistic_train[1,2])
Specificity_logistic_train

Error_rate_logistic_train <- (confusion_logistic_train[1,2]+confusion_logistic_train[2,1])/ (confusion_logistic_train[1,1] + confusion_logistic_train[1,2]
+ confusion_logistic_train[2,1] + confusion_logistic_train[2,2])
Error_rate_logistic_train

PPV_logistic_train <- confusion_logistic_train[2,2]/(confusion_logistic_train[2,2]+confusion_logistic_train[1,2])
PPV_logistic_train

NPV_logistic_train <- confusion_logistic_train[1,1]/ (confusion_logistic_train[1,1]+confusion_logistic_train[2,1])
NPV_logistic_train

Sensitivity_logistic_test <- (confusion_logistic_test[2,2])/(confusion_logistic_test[2,1]+confusion_logistic_test[2,2])
Sensitivity_logistic_test

Accuracy_logistic_test <- (confusion_logistic_test[1,1] + confusion_logistic_test[2,2])/(confusion_logistic_test[1,1] + confusion_logistic_test[1,2]
+ confusion_logistic_test[2,1] + confusion_logistic_test[2,2])
Accuracy_logistic_test

Specificity_logistic_test <- (confusion_logistic_test[1,1])/(confusion_logistic_test[1,1]+confusion_logistic_test[1,2])
Specificity_logistic_test

Error_rate_logistic_test <- (confusion_logistic_test[1,2]+confusion_logistic_test[2,1])/ (confusion_logistic_test[1,1] + confusion_logistic_test[1,2]
+ confusion_logistic_test[2,1] + confusion_logistic_test[2,2])
Error_rate_logistic_test

PPV_logistic_train <- confusion_logistic_train[2,2]/(confusion_logistic_train[2,2]+confusion_logistic_train[1,2])
PPV_logistic_train

PPV_logistic_test <- confusion_logistic_test[2,2]/(confusion_logistic_test[2,2]+confusion_logistic_test[1,2])
PPV_logistic_test

NPV_logistic_train <- confusion_logistic_train[1,1]/ (confusion_logistic_train[1,1]+confusion_logistic_train[2,1])
NPV_logistic_train

NPV_logistic_test <- confusion_logistic_test[1,1]/ (confusion_logistic_test[1,1]+confusion_logistic_test[2,1])
NPV_logistic_test

#2c.
FPR_train <- 1 - Specificity_logistic_train
FPR_train
TPR_train <- Sensitivity_logistic_train
TPR_train

FPR_test <- 1 - Specificity_logistic_test
FPR_train
TPR_test <- Sensitivity_logistic_test
TPR_test


#2c.
cutoff <- seq(0, 1, length = 100)
fpr_train <- numeric(100)
tpr_train <- numeric(100)

roc.table <- data.frame(Cutoff = cutoff, FPR = fpr_train,TPR = tpr_train)
Actual <- train$PREFERENCE
Actual
for (i in 1:100) {
  roc.table$FPR[i] <- sum(predicted_train_logistic > cutoff[i] & Actual == "For")/sum(Actual == "For")
  roc.table$TPR[i] <- sum(predicted_train_logistic > cutoff[i] & Actual == "Against")/sum(Actual == "Against")
}

plot(TPR ~ FPR, data = roc.table, type = "o",xlab="1 - Specificity",ylab="Sensitivity",col="red")
abline(a = 0, b = 1, lty = 2,col="red")

cutoff <- seq(0, 1, length = 100)
FPR_test <- numeric(100)
TPR_test <- numeric(100)
Actual1 <- test$PREFERENCE
roc.table1 <- data.frame(Cutoff = cutoff, FPR = FPR_test,TPR = TPR_test)

for (i in 1:100) {
  roc.table1$FPR[i] <- sum(predicted_test_logistic > cutoff[i] & Actual1 == "For")/sum(Actual1 == "For")
  roc.table1$TPR[i] <- sum(predicted_test_logistic > cutoff[i] & Actual1 == "Against")/sum(Actual1 == "Against")
}
lines(TPR~FPR,data = roc.table1, type="o",col="green")
legend('bottomright', "Training -> Red 
Testing -> Green")

#2d.
library(ROCR)
pred_train <- prediction(predicted_train_logistic,train$PREF)
perf_train <- performance( pred_train, "acc")
plot( perf_train , show.spread.at=seq(0, 1, by=0.1), col="red")

pred_test <- prediction(predicted_test_logistic,test$PREF)
perf_test <- performance( pred_test, "acc")
plot( perf_test , show.spread.at=seq(0, 1, by=0.1), col="blue")

#2e.
MaxAcc_train <- max(perf_train@y.values[[1]])
MaxAcc_train
Cut_train <- perf_train@x.values[[1]][which.max(perf_train@y.values[[1]])]
Cut_train

#2f.
tt<-ifelse(predicted_test_logistic>0.4212197,1,0)
tt1<-table(as.numeric(test$PREF),tt)
tt1
accuracy_test<-(tt1[1,1]+tt1[2,2])/(tt1[1,1]+tt1[2,2]+tt1[1,2]+tt1[2,1])
accuracy_test

#3.
#3a.
cost <- matrix(c(0,1,4,0),nrow = 2, ncol = 2)
cost
miss_cost <- performance(pred_train, "cost", cost.fp = 4, cost.fn = 1)
cutoff_new <- pred_train@cutoffs[[1]][which.min(miss_cost@y.values[[1]])]
cutoff_new 

#3b.
t3_new <- ifelse(predicted_train_logistic > 0.8219539,1,0)
t3_new
confusion_logistic_train <- table(as.numeric(train$PREF),t3_new)
confusion_logistic_train
t4_new <- ifelse(predicted_test_logistic >0.8219539,1,0)
t4_new
confusion_logistic_test <- table(as.numeric(test$PREF),t4_new)
confusion_logistic_test

misclassification_cost_training <- confusion_logistic_train * cost
misclassification_cost_training
sum(misclassification_cost_training)
misclassification_cost_testing <- confusion_logistic_test * cost
misclassification_cost_testing
sum(misclassification_cost_testing)

t7 <- ifelse(predicted_train_logistic > 0.4625541,1,0)
t7
confusion_logistic_train_old <- table(as.numeric(train$PREF),t7)
confusion_logistic_train_old
t8 <- ifelse(predicted_test_logistic >0.4625541,1,0)
t8
confusion_logistic_test_old <- table(as.numeric(test$PREF),t8)
confusion_logistic_test_old
misclassification_cost_training_old <- confusion_logistic_train_old * cost
misclassification_cost_training_old
sum(misclassification_cost_training_old)
misclassification_cost_testing_old <- confusion_logistic_test_old * cost
misclassification_cost_testing_old
sum(misclassification_cost_testing_old)


#4.
#Training Data
actual <- train$PREF
df1 <- data.frame(predicted_train_logistic,actual)
df1S <- df1[order(-predicted_train_logistic),]
df1S$Gains <- cumsum(df1S$actual)
plot(df1S$Gains,type="n",main="Training Data Gains Chart",xlab="Number of Cases",ylab="Cumulative Success")
lines(df1S$Gains)
abline(0,sum(df1S$actual)/nrow(df1S),lty = 2, col="red")
#
# Testing Data
actual <- test$PREF
df1t <- data.frame(predicted_test_logistic,actual)
df1tS <- df1t[order(-predicted_test_logistic),]
df1tS$Gains <- cumsum(df1tS$actual)
plot(df1tS$Gains,type="n",main="Testing Data Gains Chart",xlab="Number of Cases",ylab="Cumulative Success")
lines(df1tS$Gains)
abline(0,sum(df1tS$actual)/nrow(df1tS),lty = 2, col="blue")





