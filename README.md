# TSA Claims Project

#### Introduction
TSA Claims analysis project. End goal of this project is to be able to predict whether or not a claim will be accepted, denied, or settled based on certain factors.

- Dataset from [here](https://www.kaggle.com/sreejay222/tsa-claim/data)
- Dataset is from 2002-2015, project will look at the [top 100 U.S. airports from 2016](http://www.fi-aeroweb.com/Top-100-US-Airports.html#PAX)

Progress:

- Dataset has been removed of all rows containing NA values
- Data frame containing only relevant variables has been created
- Dataset has been cleaned to only include the airports listed in the top 100 linked above (has also been subset into top 25 and top 50 csv files)
- Removed any row with status set to "canceled" or "pending response from claimant", as these two categories are not relevant
- Split data into training and validation set
- Performed initial random forest on training set, OOB estimate of 42%

To-do:

- Test number of trees in a certain range to try and get a lower error rate
- Predict on the validation set
- Graph


