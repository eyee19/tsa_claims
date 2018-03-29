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
as.data.frame(table(finalDat$Airport.Name)) #486 entries in the airport names column
length(unique(finalDat[["Airport.Name"]])) #however this shows that there are only 411 unique names

finalDat$Claim.Amount <- as.numeric(finalDat$Claim.Amount)
finalDat$Close.Amount <- as.numeric(finalDat$Close.Amount)
summary(finalDat$Claim.Amount[which(finalDat$Status == "Denied")])
summary(finalDat$Close.Amount[which(finalDat$Status == "Denied")])

counts <- table(finalDat$Airport.Name)
barplot(counts, horiz=TRUE, las=1)

barplot(table(finalDat$Claim.Type))
barplot(table(finalDat$Item))

plot(finalDat$Claim.Amount)
mean(finalDat$Claim.Amount)

test <- finalDat[(finalDat$Airport.Name == "Newark International Airport" | finalDat$Airport.Name == "William P. Hobby"),] 

