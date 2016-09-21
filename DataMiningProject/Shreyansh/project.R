project <- read.csv("C:/Users/singhvi/Desktop/Data Mining/Project/DataMiningProject-master (1)/DataMiningProject-master/app_metadata_cleaned_removed_min_downloads_above_5m.csv")
data <- project
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
train <- sample(nrow(data),0.7*nrow(data))
project_training <- data[train,]
project_Validation <- data[-train,]

nrow(project_training)
ncol(project$CATEGORY)
length(project_training$CATEGORY)
length(project_training$spam)
library(tree)
library(ISLR)

tree.project <- tree(spam ~ CATEGORY+PRICE+CONTENT_RATING+DOWNLOAD_MAX+DOWNLOAD_MIN+TOTAL_REVIEWS+AVERAGE_RATING+X5RATING+X4RATING+X3RATING+X2RATING+X1RATING,data = project_training)
summary(tree.project) 
 
plot(tree.project)
text(tree.project, pretty=6)

tree.predict <- predict(tree.project, project_Validation, type = "class")
confmatrix <- table (tree.predict, project_Validation$spam)
confmatrix

accuracy <- (confmatrix[1,1]+confmatrix[2,2])/sum(confmatrix)
accuracy

set.seed(123)
cv.credit <- cv.tree(tree.project,FUN =prune.misclass, K=10)
names(cv.credit)

cv.credit

prune.credit <- prune.misclass(tree.project, best =5)
plot(prune.credit)
text(prune.credit, pretty=0)


#Under Sampling Data
#Taking all the observations with dependent variable = 1
train_under <- project_training[project_training$spam==1,]

#Randomly select observations with dependent variable = 0
zeroObs <- project_training[project_training$spam==0,]
set.seed(123457)
rearrangedZeroObs <-  zeroObs[sample(nrow(zeroObs), length(train_under$spam)),]

#Appending rows of randomly selected 0s in our undersampled data frame
train_under <- rbind(train_under, rearrangedZeroObs)

tree.project <- tree(spam ~ CATEGORY+PRICE+CONTENT_RATING+DOWNLOAD_MAX+DOWNLOAD_MIN+TOTAL_REVIEWS+AVERAGE_RATING+X5RATING+X4RATING+X3RATING+X2RATING+X1RATING,data = train_under)
summary(tree.project) 

plot(tree.project)
text(tree.project, pretty=6)

tree.predict <- predict(tree.project, project_Validation, type = "class")
confmatrix <- table (tree.predict, project_Validation$spam)
confmatrix

accuracy <- (confmatrix[1,1]+confmatrix[2,2])/sum(confmatrix)
accuracy

set.seed(123)
cv.credit <- cv.tree(tree.project,FUN =prune.misclass, K=10)
names(cv.credit)

cv.credit

prune.credit <- prune.misclass(tree.project, best =8)
plot(prune.credit)
text(prune.credit, pretty=0)

summary(prune.credit)


tree.predict1 <- predict(prune.credit, project_Validation, type = "class")
confmatrix1 <- table (tree.predict1, project_Validation$spam)
confmatrix1

accuracy1 <- (confmatrix1[1,1]+confmatrix1[2,2])/sum(confmatrix1)
accuracy1


train_over <- project_training[project_training$spam==1,]
train_1 <- train_over
for (i in seq(from=1, to=6, by=1)){
  train_over <- rbind(train_over, train_1)
}
train_over
train_oversampling <- rbind(project_training, train_over)

tree.project <- tree(spam ~ CATEGORY+PRICE+CONTENT_RATING+DOWNLOAD_MAX+DOWNLOAD_MIN+TOTAL_REVIEWS+AVERAGE_RATING+X5RATING+X4RATING+X3RATING+X2RATING+X1RATING,data = train_oversampling)
summary(tree.project) 

plot(tree.project)
text(tree.project, pretty=6)

tree.predict <- predict(tree.project, project_Validation, type = "class")
confmatrix <- table (tree.predict, project_Validation$spam)
confmatrix

accuracy <- (confmatrix[1,1]+confmatrix[2,2])/sum(confmatrix)
accuracy

set.seed(12345)
cv.credit <- cv.tree(tree.project,FUN =prune.misclass, K=10)
names(cv.credit)

cv.credit

prune.credit <- prune.misclass(tree.project, best =4)
plot(prune.credit)
text(prune.credit, pretty=0)

summary(prune.credit)

tree.predict1 <- predict(prune.credit, project_Validation, type = "class")
confmatrix1 <- table (tree.predict1, project_Validation$spam)
confmatrix1

accuracy1 <- (confmatrix1[1,1]+confmatrix1[2,2])/sum(confmatrix1)
accuracy1
