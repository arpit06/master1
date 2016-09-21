install.packages("shiny")
install.packages("GGally")

library(shiny)

getwd();
setwd("C:/Users/gupta/DataMiningProject")
data<-read.csv(file="app_metadata_cleaned.csv", header=TRUE)
summary(data)

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

library(mice)

num.vars <- sapply(data, is.numeric)

data[num.vars] <- lapply(data[num.vars], scale)

Data <- data

Data$APP_ID <- NULL
Data$APP_NAME <- NULL
Data$DOWNLOADS <- NULL
Data$CURRENT_VERSION <- NULL
Data$LASTUPDATED <- NULL
Data$DEVELOPER_SITE <- NULL
Data$DEVELOPER_CONTACT <- NULL
Data$DEVELOPER_NAME <- NULL
Data$MIN_REQUIRED_ANDROID <- NULL
set.seed(123457)

library(dummies)

Data <- dummy.data.frame(Data, sep = ".", names = c("CATEGORY","CONTENT_RATING","MIN_REQ_ANDROID_FIRST"))

train <- sample(nrow(Data), .7 * nrow(Data))
df_train <- Data[train,]
df_validation <- Data[-train, ]

train_input <- as.matrix(df_train[,-15])
train_output <- as.vector(df_train[,15])
validate_input <- as.matrix(df_validation[,-15])

set.seed(12345)


data_matrix<-data.matrix(Data)
data_heatmap <- heatmap(data_matrix, Rowv=NA, Colv=NA, col = heat.colors(256), scale="column", margins=c(5,10))

#hv <- heatmap(data_matrix, col = cm.colors(256), scale = "column", margins = c(5,10),xlab = "specification variables", ylab = "Attributes")

library(GGally)
ggcorr(data)
str(Data)
fit<-lm(as.numeric(spam)~PRICE+DOWNLOAD_MIN+SIZE_MEGABYTES+TOTAL_REVIEWS, data=Data)
summary(fit)

fitg<-glm(as.numeric(spam)~PRICE+DOWNLOAD_MIN+SIZE_MEGABYTES+TOTAL_REVIEWS, data=Data)
summary(fitg)
