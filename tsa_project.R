#TSA Claims Project
getwd()
setwd("C:/Users/Everett/Desktop/R/tsa_project")
dat <- read.csv("tsa_claims_cleaned.csv") #removed case ID, date received and incident date columns
names(dat)
summary(dat)

summary(dat$Status)

barplot(table(dat$Status), ylab = "Number of Claims", col = "blue")

#Goals:
#Which airport has the most claims
#Which airline has the most claims
#Graph showing number of claims over time (hypothesis that holidays will have a lot of claims)
#KDEs for claim type, claim site, disposition
#Regression trees
#Prediction