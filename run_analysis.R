## R script file for Course Project of Getting and cleaning data course
## on coursera.
## The script loads desired raw data, processes it to create and save a tidy
## data set, and creates and saves another tidy data set which is kind of
## aggregate/summary dataset of the downloaded data.
## For more information, please read the README.md and CodeBook.md file.

## Function for downloading the data for the project. 
## You can choose the exact directory of the data with the dataDir argument.
downloadProjectData <- function(dataDir = ".") {
        zipFileName <- "UCI HAR Dataset.zip"
        
        ## splitting the url because i like the code to fit in 80 columns
        zipFileUrlPart1 <- "http://archive.ics.uci.edu"
        zipFileUrlPart2 <- "/ml/machine-learning-databases/00240/"
        
        ## getting this all together
        ## using gsub to change spaces for the url %20 equivalent
        completeZipFileUrl <- paste0(zipFileUrlPart1,
                                     zipFileUrlPart2,
                                     gsub(" ", "%20", zipFileName))
        
        ## downloading (for Windows OS)
        download.file(completeZipFileUrl, 
                      destfile = zipFileName)
        
        ## unzip the file into chosen directory
        unzip(zipFileName, exdir = dataDir)
        
        ## get rid of zip file
        file.remove(zipFileName)
        
        ## this is from the discussion forums, but very helpful thing
        sink("./data/download_metadata.txt")
        print("Download date:")
        print(Sys.time() )
        print("Download URL:")
        print(completeZipFileUrl)
        print("Downloaded file Information")
        print(file.info(zipFileName))
        sink()
}

## Function to load the project's raw data, so we can operate on it later.
## Returns the data as list of data frames.
getRawProjectData <- function(projectDataDir = ".") {
        ## get the features.txt data
        features <- read.table(paste0(projectDataDir, "/features.txt"), 
                               colClasses = c("numeric", "character"))
        
        ## get the X_test.txt data
        xTest <- read.table(paste0(projectDataDir, "/test/X_test.txt"),
                            colClasses = "numeric")
        
        ## get the Y_test.txt data
        yTest <- read.table(paste0(projectDataDir, "/test/Y_test.txt"), 
                            colClasses = "numeric")
        
        ## get the subject_test.txt data
        subjectTest <- read.table(paste0(projectDataDir, 
                                       "/test/subject_test.txt"), 
                                  colClasses = "numeric")
        
        ## get the X_train.txt data
        xTrain <- read.table(paste0(projectDataDir, "/train/X_train.txt"),
                             colClasses = "numeric")
        
        ## get the Y_train.txt data
        yTrain <- read.table(paste0(projectDataDir, "/train/Y_train.txt"),
                             colClasses = "numeric")
        
        ## get the subject_train.txt data
        subjectTrain <- read.table(paste0(projectDataDir, 
                                       "/train/subject_train.txt"), 
                                   colClasses = "numeric")
        
        ## get the activity_labels.txt data
        activityLabels <- read.table(paste0(projectDataDir, 
                                            "/activity_labels.txt"), 
                                     colClasses = c("numeric", "character"))
        
        ## return the data as list
        list( xTest = xTest, yTest = yTest, subjectTest = subjectTest,
              xTrain = xTrain, yTrain = yTrain, subjectTrain = subjectTrain,
              activityLabels = activityLabels, features = features)
}

## Function to truncate project's data, that is, to get rid of the columns we
## do not want to have
truncateData <- function(dataList) {
        ## leave only the features we want, which are the features that describe
        ## mean or standard deviation
        dataList$features <- dataList$features[ grep("mean\\(\\)|std\\(\\)", 
                                                     dataList$features$V2) , ]
        
        ## remove unwanted features from data
        dataList$xTest <- dataList$xTest[ , dataList$features$V1 ]
        dataList$xTrain <- dataList$xTrain[ , dataList$features$V1 ]
        
        dataList
}

## Function to merge data from the exercise into one piece, that is: merge
## test and train data, include subject column, include label (Y_*.txt) column,
## change labels from numerical to factor (character) values and add proper
## column names.
mergeData <- function(dataList) {
        ## library for plyr functions
        library(plyr)
        
        ## X_test data with subject ids and numeric labels, give proper column
        ## names at the same time
        xTestIndexedLabeled <- mutate(dataList$xTest, 
                                      activity_id = unlist(dataList$yTest), 
                                      subject_id = unlist(dataList$subjectTest))
        
        ## X_train data with subject ids and numeric labels, give proper column
        ## names at the same time
        xTrainIndexedLabeled <- mutate(dataList$xTrain, 
                                       activity_id = unlist(dataList$yTrain), 
                                       subject_id = 
                                               unlist(dataList$subjectTrain))
        
        ## merge the sets
        xMerged <- rbind(xTrainIndexedLabeled, xTestIndexedLabeled)
        
        ## assign column names in the way we do not need to worry about
        ## column order mixes (not sure if it may happen though)
        ## and name them properly
        colnames(xMerged) <- sapply(colnames(xMerged), 
                            function(x) {
                                    if( grepl("^V[0-9]+$", x) == T ) {
                                            x <- gsub("[a-zA-Z]", "", x)
                                            x <- as.numeric(x)
                                            x <- dataList$features[
                                                    dataList$features$V1 == x, 
                                                    "V2"
                                                    ]
                                            x <- gsub("-", "", x)
                                            x <- gsub("mean\\(\\)", "Mean", x)
                                            x <- gsub("std\\(\\)", "Std", x)
                                            x <- strsplit(gsub("([[:upper:]])", 
                                                               " \\1", x), 
                                                          " ")
                                            x <- unlist(x)
                                            x <- paste(x, collapse = "_")
                                            x <- tolower(x)
                                    }
                                    x
                            })
        
        ## set the column names for activity names so it joins with data set
        ## easily
        colnames(dataList$activityLabels) <- c("activity_id", "activity_name")
        
        ## merge the labels with their names
        xMerged <- join(xMerged, dataList$activityLabels)
        
        ## get rid of activity_id column since we do not need it anymore
        xMerged <- subset(xMerged, select = -activity_id)
}

## Function to prepare aggregated data set with averages of each variable
## for each activity and each subject
prepareAggregatedData <- function(unaggregatedDataSet) {
        aggregatedDataSet <- aggregate(. ~ activity_name + subject_id, 
                  data = unaggregatedDataSet, 
                  FUN = mean)
        
        ## add the "averaged" text to each column except first two
        colnames(aggregatedDataSet)[c(-1, -2)] <- 
                sapply(colnames(aggregatedDataSet)[c(-1, -2)],
                       function(x) {
                               x <- paste0(x, "_averaged")
                       })
        
        aggregatedDataSet
}

## I want my data to be in the "data" folder
dataDir <- "./data"

## Path to the unzipped project raw data folder file
projectDataDir <- paste0(dataDir, "/UCI HAR Dataset")

## I assume the data should be in the "data" subdirectory of the working dir
## if it does not, download the data
if(!file.exists(projectDataDir)) {
        print("Could not find the data folder.\nTrying to download...")
        downloadProjectData(dataDir)
}

## lets get the data
dataList <- getRawProjectData(projectDataDir)

## lets truncate the data
truncatedDataList <- truncateData(dataList)        

## lets merge the data into one piece
## this will create a tidy data set
tidyDataSet <- mergeData(truncatedDataList)
        
## save to a file
write.table(tidyDataSet, "TidyDataSet.txt", row.names = F)
        
## get the aggregated data set
aggregatedDataSet <- prepareAggregatedData(tidyDataSet)

## save it to a file
write.table(aggregatedDataSet, "AggregatedTidyDataSet.txt", row.names = F)

## little cleanup after, leave functions and tidy data sets
## not sure if it's a good practice though
rm(list = c("dataDir", "dataList", "projectDataDir", "truncatedDataList"))

## finito!

