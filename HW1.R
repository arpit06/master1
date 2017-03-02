setwd("C:/Users/Arpit/Desktop/UMD_All_Material/COURSEWORK/Spring,17/DataMining/Datafiles")

#1a
Airline <- read.csv(file = "AirlineData.csv", header = TRUE)
attach(Airline)
is.factor(SW)
is.factor(VACATION)
is.factor(SLOT)
is.factor(GATE)
bfit <- lm(FARE~COUPON+NEW+VACATION+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+SLOT+GATE+DISTANCE+PAX)
summary(bfit)

#1c
newdata <- data.frame(COUPON=1, NEW=3, VACATION = "No", SW = "No", HI=6000, S_INCOME=2000, 
                      E_INCOME=2000, S_POP=4000000, E_POP=7150000, SLOT= "Free", GATE= "Constrained", 
                      DISTANCE=1000, PAX=6000)
pred <- predict(bfit,newdata = newdata,interval = "confidence")
pred

#2a
pairs(~HI+DISTANCE+PAX+FARE)
#2b
plot(DISTANCE,FARE,col=ifelse(SW == "No",'blue','red'))
legend('topleft', "SWYes -> Red
SWNo -> Blue")
#2c
cor <- cor(Airline[c(5:6,9:13,16:17)],Airline[c(5:6,9:13,16:17)])
View(cor)

#3
lm.SW <- lm(FARE~SW)
summary(lm.SW)

#4
bfit <- lm(FARE~COUPON+NEW+VACATION+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+SLOT+GATE+DISTANCE+PAX+SW:VACATION)
summary(bfit)

#5
bfit <- lm(FARE~VACATION+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+DISTANCE+PAX)
summary(bfit)
bfit <- lm(FARE~VACATION+SW+HI+S_POP+E_POP+DISTANCE+PAX)
summary(bfit)