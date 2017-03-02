getwd()
#1.
#1a.
Voter <- read.csv(file = "VoterPref.csv", header = TRUE)
attach(Voter)
PREF<-PREFERENCE=='Against'
Voter<-cbind(Voter, PREF)

View(Voter)


#for(i in 1:nrow(Voter)){
#  if(PREFERENCE[i]=="Against")
#    Voter$x[i] = 1
#  else
#    Voter$x[i] = 0
#}

#1b.
set.seed(123457)

#1c.
train_ind<-sample(nrow(Voter),0.7*nrow(Voter))
train <- Voter[train_ind,]
test <- Voter[-train_ind,]
nrow(train)
nrow(test)
View(test)

#2.
#2a.
boxplot(INCOME~PREFERENCE, data = train, main = "Income Preference", xlab="PREFERENCE", ylab="INCOME")
boxplot(AGE~PREFERENCE, data = train, main = "Age Preference", xlab="PREFERENCE", ylab="AGE")

#2b.
t <- table(train$PREFERENCE)
prop.table(t)

#2c.
t1 <- table(train$PREFERENCE,train$GENDER)
t1
prop.table(t1)

#3
#3a.
fit <- lm(as.numeric(PREF)~AGE+INCOME+factor(GENDER), data = train)
summary(fit)
predicted_train <- predict(fit, newdata = train)
actual <- as.numeric(train$PREF)
Metrics <- c("AE","RMSE","MAE")
x1 <- mean(actual-predicted_train)
x2 <- sqrt(mean((actual-predicted_train)^2))
x3 <- mean(abs(actual-predicted_train))
Values <- c(x1,x2,x3)
X <- data.frame(Metrics,Values)
X

fit <- lm(as.numeric(PREF)~AGE+INCOME+factor(GENDER), data = train)
summary(fit)
predicted_test <- predict(fit, newdata = test)
actual <- as.numeric(test$PREF)
Metrics <- c("AE","RMSE","MAE")
x1 <- mean(actual-predicted_test)
x2 <- sqrt(mean((actual-predicted_test)^2))
x3 <- mean(abs(actual-predicted_test))
Values <- c(x1,x2,x3)
X <- data.frame(Metrics,Values)
X

#3b.
Training data set

#3c.
t1 <- ifelse(predicted_train > 0.5,1,0)
t1
t_train <- table(as.numeric(train$PREF),t1)
t_train
prop.table(t_train)

t2 <- ifelse(predicted_test > 0.5,1,0)
t2
t_test <- table(as.numeric(test$PREF),t2)
t_test
prop.table(t_test)


#4.
#4a.
fit1 <- glm(as.numeric(PREF)~AGE+INCOME+factor(GENDER), family = "binomial", data = train)
summary(fit1)

#4d.
predicted_train_logistic <- predict(fit1, newdata = train, type = "response")
predicted_train_logistic
t3 <- ifelse(predicted_train_logistic > 0.5,1,0)
t3
table(as.numeric(train$PREF),t3)

predicted_test_logistic <- predict(fit1, newdata = test, type = "response")
predicted_test_logistic
t4 <- ifelse(predicted_test_logistic > 0.5,1,0)
t4
table(as.numeric(test$PREF),t4)


#4f.
p(Against) = 1/(1+e(-logit))
logit = 0.13300 + 0.23953(AGE) -0.13184(INCOME) - 0.53005(M=1,F=0)
logit <- 0.13300 + 0.23953*36 -0.13184*70 - 0
logit
a <- 1 + exp(-logit)
1/a

df <- data.frame(AGE = 36,INCOME = 70,GENDER = "F")
predicted_prob <- predict(fit1, newdata = df, type= "response")
predicted_prob
