# Getting_and_Cleaning_Data_Project


## Downloading the data first and setting directory so we don't need to repeat the process


```{r} 
dir <- "C:/Users/David/Downloads/John Hopkins/R/data"
if(!dir.exists("C:/Users/David/Downloads/John Hopkins/R/data")) dir.create("C:/Users/David/Downloads/John Hopkins/R/data")
setwd(currdir)

downloadurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "UCI HAR Dataset.zip"
download.file(downloadurl, zipfile)

if(file.exists(zipfile)) unzip(zipfile)
```


## Files data are concatenated and then stored in a vector

```{r}
basedir <- "UCI HAR Dataset"
featuresp <- paste(basedir, "features.txt", sep="/")
activitylabelp <- paste(basedir, "activity_labels.txt", sep="/")
testvariablesp <- paste(basedir, "test/X_test.txt", sep="/")
testactivityp <- paste(basedir, "test/y_test.txt", sep="/")
testsubjectp <- paste(basedir, "test/subject_test.txt", sep="/")
trainvariablesp <- paste(basedir, "train/X_train.txt", sep="/")
trainactivityp <- paste(basedir, "train/y_train.txt", sep="/")
trainsubjectp <- paste(basedir, "train/subject_train.txt", sep="/")

datavector <- c(featuresfile,
                 activitylabelsfile,
                 testvariablesfile,
                 testactivityfile,
                 testsubjectfile,
                 trainvariablesfile,
                 trainactivityfile,
                 trainsubjectfile
)
sapply(neededfiles, function(f) if(!file.exists(f)) stop(paste("Needed file ", f, " doesn't exist. Exitting ...", sep="")))

```


## Read featuresp

```{r}
features <- read.table(featuresp, col.names=c("rownumber","variablename"))
```

## Fix duplicates

```{r}allvariables <- 
  mutate(features, variablename = gsub("BodyBody", "Body", variablename))
```

## Filter the 66 variables - mean() and std()

```{r}
neededvariables <- filter(allvariables, grepl("mean\\(\\)|std\\(\\)", variablename))
```

##Remove special characters, covert to lower case

```{r}
allvariables <- mutate(allvariables, variablename = gsub("-", "", variablename),
                       variablename = gsub("\\(", "", variablename),
                       variablename = gsub("\\)", "", variablename),
                       variablename = tolower(variablename))


neededvariables <- mutate(neededvariables, variablename = gsub("-", "", variablename),
                          variablename = gsub("\\(", "", variablename),
                          variablename = gsub("\\)", "", variablename),
                          variablename = tolower(variablename))
```

## Read activitylabelsfile

```{r}
activitylabels <- read.table(activitylabelsfile, col.names=c("activity", "activitydescription"))
```

## Read in test data stats

```{r}
testvalues <- read.table(testvariablesfile, col.names = allvariables$variablename)
testneededvalues <- testvalues[ , neededvariables$variablename]
```

## Read in test activities

```{r}
testactivities <- read.table(testactivityfile, col.names=c("activity"))
```


## Read in test subjects

```{r}
testsubjects <- read.table(testsubjectfile, col.names=c("subject"))
```


## Add a readable activity description

```{r}
testactivitieswithdescr <- merge(testactivities, activitylabels)
```


## Put the test data together

```{r}
testdata <- cbind(testactivitieswithdescr, testsubjects, testneededvalues)
```

## Read in train variables

```{r}
trainvalues <- read.table(trainvariablesfile, col.names = allvariables$variablename)
trainneededvalues <- trainvalues[ , neededvariables$variablename]
```

## Read in train activities

```{r}
trainactivities <- read.table(trainactivityfile, col.names=c("activity"))
```


## Read in train subjects

```{r}
trainsubjects <- read.table(trainsubjectfile, col.names=c("subject"))
```


## Add a readable activity description

```{r}
trainactivitieswithdescr <- merge(trainactivities, activitylabels)
```


## Put the train data together

```{r}
##    Combining values, activities, subjects
traindata <- cbind(trainactivitieswithdescr, trainsubjects, trainneededvalues)
```


## Combine the testdata and traindata
## Additionally make subject a factor

```{r}
alldata <- rbind(testdata, traindata) %>% select( -activity )
alldata <- mutate(alldata, subject = as.factor(alldata$subject))
```

## Write the data out

```{r}
write.table(alldata, "Mean_And_StdDev_For_Activity_Subject.txt")
```


## Create a second, independent tidy data set with the average of each 

```{r}
allgroupeddata <- group_by(alldata,activitydescription,subject)
```
## Get the average of each variable
```{r}
summariseddata <- summarise_each(allgroupeddata, funs(mean))
```
## Write the data out
```{r}
write.table(summariseddata, "Average_Variable_By_Activity_Subject.txt", row.names = FALSE)
```




