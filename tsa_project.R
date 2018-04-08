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
names(forest)
as.data.frame(table(forest$Airline.Name))

set.seed(100)
datasetSize <- floor(nrow(forest)/2)
split <- sample(1:nrow(forest), size = datasetSize)
training <- forest[split,] #training set
validation <- forest[-split,] #testing set

### Training ###
library(randomForest)
rf_classifier = randomForest(Status ~ Airport.Name + Claim.Type + Claim.Site + 
                               Airline.Name + Claim.Amount, data = training, ntree = 500, importance = TRUE)
#100 Tree 40.44% OOB
#200 40.36%
#300 40.31%
#400 40.01%
#500 39.77%
rf_classifier
varImpPlot(rf_classifier)
table(training$Status)

### Testing ###
prediction <- predict(rf_classifier, validation)
table(prediction)

rf_classifier_test = randomForest(Status ~ Airport.Name + Claim.Type + Claim.Site + 
                               Airline.Name + Claim.Amount, data = validation, ntree = 500, importance = TRUE)
rf_classifier_test #39.73% OOB, sliiiiightly better 
varImpPlot(rf_classifier_test)

### Graphs/Plots ###
library(ggplot2)
#Status histogram
ggplot(forest, aes(Status)) + geom_bar(stat = "count", fill = "red", width = 0.5) 

g <- ggplot(forest, aes(Airport.Code))
g + geom_bar(aes(fill=Status), width = 0.5) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Histogram on Claims per Airport", 
       subtitle="Airport Code Across Claim Status",
       x="IATA Airport Code", y="Claim Count")

ggsave("histClaimCode.png", width = 10, height = 5)

#Pie chart of status
table(forest$Status)
pie <- ggplot(forest, aes(x = "", fill = factor(Status))) + 
  geom_bar(width = 1) +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="Status", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of Status", 
       caption="Source: TSA")

pie + coord_polar(theta = "y", start=0)
ggsave("pie.png", width = 5, height = 5)

#World map
as.data.frame(table(forest$Airline.Name))
library(dplyr)

WorldData <- map_data('world')
WorldData %>% filter(region != "Antarctica") -> WorldData
WorldData <- fortify(WorldData)

df <- data.frame(region=c('Angola','Australia','Austria','Belgium','Canada','Chile','China','Colombia','Egypt',
                          'El Salvador','Fiji','France','Germany','Iceland','India','Ireland','Israel','Italy',
                          'Jamaica','Japan','Malaysia','Mexico','Netherlands','New Zealand','Pakistan','Panama',
                          'Philippines','Poland','Portugal','Russia','Saudi Arabia','Singapore','South Africa',
                          'South Korea','Spain','Sweden','Switzerland','Taiwan','Thailand','Turkey','UAE','United Kingdom'), 
                 value=c(1,107,24,10,359,9,105,7,7,2,10,240,257,16,31,59,40,49,52,44,19,90,74,30,15,3,3,16,186,
                         10,7,45,28,61,16,38,31,24,7,14,5,536), 
                 stringsAsFactors=FALSE)

p <- ggplot()
p <- p + geom_map(data=WorldData, map=WorldData,
                  aes(x=long, y=lat, group=group, map_id=region),
                  fill="white", colour="#7f7f7f", size=0.5)
p <- p + geom_map(data=df, map=WorldData,
                  aes(fill=value, map_id=region),
                  colour="#7f7f7f", size=0.5)
p <- p + coord_map("rectangular", lat0=0, xlim=c(-180,180), ylim=c(-60, 90))
p <- p + scale_fill_continuous(low="thistle2", high="darkred", 
                               guide="colorbar")
p <- p + scale_y_continuous(breaks=c())
p <- p + scale_x_continuous(breaks=c())
p <- p + labs(fill="legend", title="Claims per Airline by Country (-USA)", x="", y="")
p <- p + theme_bw()
p <- p + theme(panel.border = element_blank())
p 
ggsave("worldwithoutUSA.png", width = 10, height = 5)

#Bar chart for claim type
freqtable <- table(forest$Claim.Type)
df <- as.data.frame.table(freqtable)
head(df)
#1  Employee Loss (MPCECA)   146 Military Personnel and Civilian Employees' Claims Act of 1964
#2           Motor Vehicle     2
#3 Passenger Property Loss 29683
#4         Passenger Theft   168
#5         Personal Injury   108
#6         Property Damage 16048
# Plot
g <- ggplot(df, aes(Var1, Freq))
g + geom_bar(stat="identity", width = 0.5, fill="tomato2") + 
  labs(title="Bar Chart", 
       subtitle="Claim Type", x="Claim Type", y="Frequency") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

ggsave("claimtype.png", width = 10, height = 5)

#Bar chart for claim site
freqtable <- table(forest$Claim.Site)
df <- as.data.frame.table(freqtable)
head(df)
#1 Checked Baggage 38802
#2      Checkpoint  7208
#3   Motor Vehicle     1
#4           Other   144
# Plot
g <- ggplot(df, aes(Var1, Freq))
g + geom_bar(stat="identity", width = 0.5, fill="tomato2") + 
  labs(title="Bar Chart", 
       subtitle="Claim Site", x="Claim Site", y="Frequency") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

ggsave("claimsite.png", width = 10, height = 5)

