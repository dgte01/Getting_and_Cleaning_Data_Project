## Downloading the data and preparing the data
## Use the directory ".data' as working directory
dir <- "C:/Users/David/Downloads/John Hopkins/R/data"
if(!dir.exists("C:/Users/David/Downloads/John Hopkins/R/data")) dir.create("C:/Users/David/Downloads/John Hopkins/R/data")
setwd(currdir)

downloadurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "UCI HAR Dataset.zip"
download.file(downloadurl, zipfile)

if(file.exists(zipfile)) unzip(zipfile)

####
## Files are downloaded and the following files exist
##
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


