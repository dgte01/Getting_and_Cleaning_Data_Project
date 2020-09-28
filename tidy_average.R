
features <- read.table(featuresp, col.names=c("rownumber","variablename"))

allvariables <- 
  mutate(features, variablename = gsub("BodyBody", "Body", variablename))


neededvariables <- filter(allvariables, grepl("mean\\(\\)|std\\(\\)", variablename))

allvariables <- mutate(allvariables, variablename = gsub("-", "", variablename),
                       variablename = gsub("\\(", "", variablename),
                       variablename = gsub("\\)", "", variablename),
                       variablename = tolower(variablename))

neededvariables <- mutate(neededvariables, variablename = gsub("-", "", variablename),
                          variablename = gsub("\\(", "", variablename),
                          variablename = gsub("\\)", "", variablename),
                          variablename = tolower(variablename))


activitylabels <- read.table(activitylabelsfile, col.names=c("activity", "activitydescription"))

read.table(testvariablesfile, col.names = allvariables$variablename)
testneededvalues <- testvalues[ , neededvariables$variablename]

testactivities <- read.table(testactivityfile, col.names=c("activity"))

testsubjects <- read.table(testsubjectfile, col.names=c("subject"))

testactivitieswithdescr <- merge(testactivities, activitylabels)


testdata <- cbind(testactivitieswithdescr, testsubjects, testneededvalues)

trainvalues <- read.table(trainvariablesfile, col.names = allvariables$variablename)
trainneededvalues <- trainvalues[ , neededvariables$variablename]

trainactivities <- read.table(trainactivityfile, col.names=c("activity"))

trainsubjects <- read.table(trainsubjectfile, col.names=c("subject"))

trainactivitieswithdescr <- merge(trainactivities, activitylabels)

traindata <- cbind(trainactivitieswithdescr, trainsubjects, trainneededvalues)


alldata <- rbind(testdata, traindata) %>% select( -activity )
alldata <- mutate(alldata, subject = as.factor(alldata$subject))

write.table(alldata, "Mean_And_StdDev_For_Activity_Subject.txt")

allgroupeddata <- group_by(alldata,activitydescription,subject)

summariseddata <- summarise_each(allgroupeddata, funs(mean))

write.table(summariseddata, "Average_Variable_By_Activity_Subject.txt", row.names = FALSE)
