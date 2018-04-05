#TSA Claims Project
getwd()
setwd("C:/Users/Everett/Desktop/R/tsa_project")
dat <- read.csv("tsa_claims.csv")
names(dat)

dat[dat==""] <- NA #replacing blank cells with NA value
dat2 <- na.omit(dat) #removing any rows with NA values

names(dat2)

finalDat <- dat2[c(4:12)] #selecting relevant variables
write.csv(finalDat, file = "finalDat.csv")
names(finalDat)
summary(finalDat)
as.data.frame(table(finalDat$Airport.Name)) #486 entries in the airport names column
length(unique(finalDat[["Airport.Name"]])) #however this shows that there are only 411 unique names

#finalDat$Claim.Amount <- as.numeric(finalDat$Claim.Amount)
#finalDat$Close.Amount <- as.numeric(finalDat$Close.Amount)
#summary(finalDat$Claim.Amount[which(finalDat$Status == "Denied")])
#summary(finalDat$Close.Amount[which(finalDat$Status == "Denied")])

barplot(table(finalDat$Claim.Type))
barplot(table(finalDat$Item))

plot(finalDat$Claim.Amount)
mean(finalDat$Claim.Amount)

#### Top 25 ####
top25 <- read.csv("top25.csv")
counts25 <- table(top25$Airport.Code)
barplot(counts25, horiz=TRUE, las=1) #barplot of top 25 airports based on number of claims per airport in data

### Random Forest ####
forest <- read.csv("top50.csv")
str(forest)
as.data.frame(table(forest$Airline.Name))

set.seed(100)
datasetSize <- floor(nrow(forest)/2)
split <- sample(1:nrow(forest), size = datasetSize)
training <- forest[split,] #training set
validation <- forest[-split,] #testing set

library(randomForest)
rf_classifier = randomForest(Status ~ Airport.Name + Claim.Type + Claim.Site + Airport.Name, data = forest, ntree = 500, mtry = 2, importance = TRUE)
#100 Trees 42.01% OOB
#500 Trees 42.03%
rf_classifier
varImpPlot(rf_classifier)

### Graphs/Plots ###
library(ggplot2)

ggplot(forest, aes(Status)) + geom_bar(stat = "count", fill = "red", width = 0.5) #Status histogram
