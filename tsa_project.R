#TSA Claims Project
getwd()
setwd("C:/Users/Everett/Desktop/R/tsa_project")
dat <- read.csv("tsa_claims.csv")
names(dat)

dat[dat==""] <- NA #replacing blank cells with NA value
dat2 <- na.omit(dat) #removing any rows with NA values

names(dat2)

finalDat <- dat2[c(4:12)] #selecting relevant variables
names(finalDat)

barplot(table(finalDat$Airport.Code))
barplot(table(finalDat$Claim.Type))
barplot(table(finalDat$Item))

#random forest
#support vector machine

