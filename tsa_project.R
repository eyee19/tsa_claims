#TSA Claims Project
getwd()
setwd("C:/Users/Everett/Desktop/R/tsa_project")
dat <- read.csv("tsa_claims.csv")
names(dat)

dat[dat==""] <- NA #replacing blank cells with NA value
dat2 <- na.omit(dat) #removing any rows with NA values

names(dat2)

finalDat <- dat2[c(5:12)] #selecting relevant variables
names(finalDat)
summary(finalDat)
table(finalDat$Airport.Code)
length(unique(finalDat[["Airport.Code"]]))
barplot(table(finalDat$Airport.Code))
barplot(table(finalDat$Claim.Type))
barplot(table(finalDat$Item))

plot(finalDat$Claim.Amount)
mean(finalDat$Claim.Amount)

test <- finalDat[(finalDat$Airport.Name == "Newark International Airport"),] 

