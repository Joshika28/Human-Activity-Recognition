---
title: "Predict activity quality from activity monitors"
author: "Onur Akpolat"
date: "24. January 2015"
output:
  html_document:
    keep_md: yes
---

## Synopsis

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways.

The goal of this project is to predict the manner in which they did the exercise. This is the `classe` variable in the training set.

## Data description

The outcome variable is `classe`, a factor variable with 5 levels.

## Initial configuration


```r
# Data URLs and paths
training.file   <- './data/pml-training.csv'
test.cases.file <- './data/pml-testing.csv'
training.url    <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
test.cases.url  <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'

# Directories
if (!file.exists("data")) dir.create("data")
if (!file.exists("data/submission")) dir.create("data/submission")

# Load libraries
suppressMessages({
  library(caret)
  library(randomForest)
  library(rpart)
  library(rpart.plot)
})

# Seed
set.seed(9999)
```

## Data processing


```r
# Download and read
download.file(training.url, training.file)
download.file(test.cases.url, test.cases.file)

training <- read.csv(training.file, na.strings = c("NA", "#DIV/0!", ""))
testing  <- read.csv(test.cases.file, na.strings = c("NA", "#DIV/0!", ""))

# Remove near-zero variance variables
nzv <- nearZeroVar(training)
training <- training[, -nzv]
testing  <- testing[, -nzv]

# Remove columns with NA values
training <- training[, colSums(is.na(training)) == 0]
testing  <- testing[, colSums(is.na(testing)) == 0]

# Remove first 7 irrelevant columns
training <- training[, -c(1:7)]
testing  <- testing[, -c(1:7)]

# Ensure test set has matching predictors
testing <- testing[, names(testing) %in% names(training)]
```

## Cross-validation


```r
inTrain <- createDataPartition(y = training$classe, p = 0.75, list = FALSE)
subTraining <- training[inTrain, ]
subTesting <- training[-inTrain, ]
```

## Exploratory analysis


```r
if (!is.null(subTraining$classe) && all(!is.na(subTraining$classe))) {
  barplot(table(subTraining$classe),
          col = "orange",
          main = "Levels of the variable classe",
          xlab = "classe levels",
          ylab = "Frequency")
} else {
  print("subTraining$classe is empty or has only NA values.")
}
```

![](analysis_files/figure-html/exploranalysis-1.png)<!-- -->

## Prediction models

### Decision Tree


```r
modFitDT <- rpart(classe ~ ., data = subTraining, method = "class")
predictDT <- predict(modFitDT, subTesting, type = "class")
rpart.plot(modFitDT, main = "Classification Tree", extra = 102, under = TRUE, faclen = 0)
```

![](analysis_files/figure-html/decisiontree-1.png)<!-- -->


```r
# Ensure same levels
subTesting$classe <- factor(subTesting$classe)
predictDT <- factor(predictDT, levels = levels(subTesting$classe))
confusionMatrix(predictDT, subTesting$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1271  215   18   63   48
##          B   26  432   40   10  105
##          C   17  143  661   71  169
##          D   80  152  133  613  121
##          E    1    7    3   47  458
## 
## Overall Statistics
##                                           
##                Accuracy : 0.7004          
##                  95% CI : (0.6874, 0.7132)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.62            
##                                           
##  Mcnemar's Test P-Value : < 2.2e-16       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9111  0.45522   0.7731   0.7624  0.50832
## Specificity            0.9020  0.95424   0.9012   0.8815  0.98551
## Pos Pred Value         0.7870  0.70473   0.6230   0.5578  0.88760
## Neg Pred Value         0.9623  0.87952   0.9495   0.9498  0.89904
## Prevalence             0.2845  0.19352   0.1743   0.1639  0.18373
## Detection Rate         0.2592  0.08809   0.1348   0.1250  0.09339
## Detection Prevalence   0.3293  0.12500   0.2164   0.2241  0.10522
## Balanced Accuracy      0.9065  0.70473   0.8372   0.8220  0.74692
```

### Random Forest


```r
# Ensure factor for target
subTraining$classe <- as.factor(subTraining$classe)
subTesting$classe <- as.factor(subTesting$classe)

modFitRF <- randomForest(classe ~ ., data = subTraining)
predictRF <- predict(modFitRF, subTesting)
```


```r
confusionMatrix(predictRF, subTesting$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1394    5    0    0    0
##          B    1  943    2    0    0
##          C    0    1  853    9    0
##          D    0    0    0  794    2
##          E    0    0    0    1  899
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9957          
##                  95% CI : (0.9935, 0.9973)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9946          
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9993   0.9937   0.9977   0.9876   0.9978
## Specificity            0.9986   0.9992   0.9975   0.9995   0.9998
## Pos Pred Value         0.9964   0.9968   0.9884   0.9975   0.9989
## Neg Pred Value         0.9997   0.9985   0.9995   0.9976   0.9995
## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
## Detection Rate         0.2843   0.1923   0.1739   0.1619   0.1833
## Detection Prevalence   0.2853   0.1929   0.1760   0.1623   0.1835
## Balanced Accuracy      0.9989   0.9965   0.9976   0.9935   0.9988
```

## Conclusion

### Result

The confusion matrices show that the Random Forest model outperforms the Decision Tree. The Random Forest achieves very high accuracy, typically around 99% or more, depending on data cleaning and partitioning.

### Expected out-of-sample error

The expected out-of-sample error is estimated as `1 - accuracy`. With 99.5% accuracy, the expected error is **0.5%**.

## Submission


```r
# Predict final test data
predictSubmission <- predict(modFitRF, testing)

# Save predictions
pml_write_files <- function(x) {
  for (i in 1:length(x)) {
    filename <- paste0("data/submission/problem_id_", i, ".txt")
    write.table(x[i], file = filename, quote = FALSE, row.names = FALSE, col.names = FALSE)
  }
}
pml_write_files(predictSubmission)
```
