library(dummies)
DM <- read.csv(file = "app_metadata_cleaned.csv", header = TRUE)
attach(DM)
data <- DM

data$CATEGORY <- as.factor(data$CATEGORY)
data$PRICE <- as.numeric(data$PRICE)
data$CONTENT_RATING <- as.factor(data$CONTENT_RATING)
data$DOWNLOAD_MIN <- as.numeric(data$DOWNLOAD_MIN)
data$DOWNLOAD_MAX <- as.numeric(data$DOWNLOAD_MAX)
data$SIZE_MEGABYTES <- as.numeric(data$SIZE_MEGABYTES)
data$MIN_REQ_ANDROID_FIRST <- as.factor(data$MIN_REQ_ANDROID_FIRST)
data$TOTAL_REVIEWS <- as.numeric(data$TOTAL_REVIEWS)
data$AVERAGE_RATING <- as.numeric(data$AVERAGE_RATING)
data$X5RATING <- as.numeric(data$X5RATING)
data$X4RATING <- as.numeric(data$X4RATING)
data$X3RATING <- as.numeric(data$X3RATING)
data$X2RATING <- as.numeric(data$X2RATING)
data$X1RATING <- as.numeric(data$X1RATING)
data$spam <- as.factor(data$spam)

set.seed(12345)

df <- data.frame(CATEGORY,PRICE, CONTENT_RATING,DOWNLOAD_MIN,DOWNLOAD_MAX,MIN_REQ_ANDROID_FIRST,TOTAL_REVIEWS,AVERAGE_RATING,spam)

df$CATEGORY <- as.factor(df$CATEGORY)
df$PRICE <- as.numeric(df$PRICE)
df$CONTENT_RATING <- as.factor(df$CONTENT_RATING)
df$DOWNLOAD_MIN <- as.numeric(df$DOWNLOAD_MIN)
df$DOWNLOAD_MAX <- as.numeric(df$DOWNLOAD_MAX)
df$SIZE_MEGABYTES <- as.numeric(df$SIZE_MEGABYTES)
df$MIN_REQ_ANDROID_FIRST <- as.factor(df$MIN_REQ_ANDROID_FIRST)
df$TOTAL_REVIEWS <- as.numeric(df$TOTAL_REVIEWS)
df$AVERAGE_RATING <- as.numeric(df$AVERAGE_RATING)
df$spam <- as.factor(df$spam)



data <- df

library(mice)


num.vars <- sapply(data, is.numeric)


data[num.vars] <- lapply(data[num.vars], scale)

Data <- data

set.seed(123457)

library(dummies)

Data <- dummy.data.frame(Data, sep = ".", names = c("CATEGORY","CONTENT_RATING","MIN_REQ_ANDROID_FIRST"))



train_ind <- sample(nrow(Data), .7 * nrow(Data))
train <- Data[train_ind,]
test <- Data[-train_ind, ]

bfit <- glm(spam~., data = train, family = "binomial")
summary(bfit)

predict_train <- predict(bfit, newdata = train[,1:47])
range(predict_train)
t3 <- ifelse(predict_train > 1,1,0)
t3
Confusion_train <- table(as.numeric(train$spam),t3)
actual <- as.numeric(train$spam)
Metrics <- c("AE","RMSE","MAE")
x1 <- mean(actual-predict_train)
x2 <- sqrt(mean((actual-predict_train)^2))
x3 <- mean(abs(actual-predict_train))
Values <- c(x1,x2,x3)
X <- data.frame(Metrics,Values)
X

predict_test <- predict(bfit, newdata = test[,1:47])
t4 <- ifelse(predict_test > 0.5,1,0)
t4
confusion_test <- table(as.numeric(test$spam),t4)
actual_test <- as.numeric(test$spam)
Metrics <- c("AE","RMSE","MAE")
x1_test <- mean(actual_test-predict_test)
x2_test <- sqrt(mean((actual_test-predict_test)^2))
x3_test <- mean(abs(actual_test-predict_test))
Values <- c(x1_test,x2_test,x3_test)
X_test <- data.frame(Metrics,Values)
X_test

Accuracy_train <- (Confusion_train[1,1] + Confusion_train[2,2])/(Confusion_train[1,1] + Confusion_train[1,2]
                                                                 + Confusion_train[2,1] + Confusion_train[2,2])
Accuracy_train

Error_rate_train <- (Confusion_train[1,2]+Confusion_train[2,1])/ (Confusion_train[1,1] + Confusion_train[1,2]
                                                                  + Confusion_train[2,1] + Confusion_train[2,2])
Error_rate_train


Accuracy_test <- (confusion_test[1,1] + confusion_test[2,2])/(confusion_test[1,1] + confusion_test[1,2]
                                                              + confusion_test[2,1] + confusion_test[2,2])
Accuracy_test

Error_rate_test <- (confusion_test[1,2]+confusion_test[2,1])/ (confusion_test[1,1] + confusion_test[1,2]
                                                               + confusion_test[2,1] + confusion_test[2,2])
Error_rate_test
