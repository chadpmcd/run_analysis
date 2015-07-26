#run_analysis.R

#This program does the following:
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard 
#	deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, 
#	independent tidy data set with the average of each variable 
#	for each activity and each subject.



if (!(require("plyr")) == TRUE) {
	install.packages("plyr")
	require("plyr")
}

if (!(require("dplyr")) == TRUE) {
	install.packages("dplyr")
	require("dplyr")
}

#Data Description
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#Data for the project: 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

dataURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


#Function for pulling a zip file from a url to a local temp dir, unzipping it, and deleting the zip file
get.zip <- function(x) {
	tempdir <- tempdir()
	tempZip <- paste(tempdir,"temp.zip", sep="\\")
	download.file(x, tempZip)
	unzip(paste(tempdir,"temp.zip", sep="\\"),exdir=tempdir)
	file.remove(tempZip)	
	filelist <- list.files(tempdir, recursive=TRUE)
	return(c(tempdir,(paste(tempdir,filelist,sep="\\"))))
}


filelist <- get.zip(dataURL)

#Test files
test_set_file <- filelist[grep("*/X_test.txt",filelist)]
test_label_file <- filelist[grep("*/y_test.txt",filelist)]
test_subject_file <- filelist[grep("subject_test.txt",filelist)]

#Train files 
train_set_file <- filelist[grep("*/X_train.txt",filelist)]
train_label_file <- filelist[grep("*/y_train.txt",filelist)]
train_subject_file <- filelist[grep("subject_train.txt",filelist)]

#Common files
features_file <- filelist[grep("features.txt",filelist)]
activity_labels_file <- filelist[grep("activity_labels.txt",filelist)]


#Read files into dataframes
#Test data
test_set <- read.table(test_set_file)
test_label <- read.table(test_label_file)
test_subject <- read.table(test_subject_file)

#Train data
train_set <- read.table(train_set_file)
train_label <- read.table(train_label_file)
train_subject <- read.table(train_subject_file)

#Common data
features <- read.table(features_file)
activity_labels <- read.table(activity_labels_file)

#Translate activity labels
test_activity_label <- join(test_label, activity_labels)
train_activity_label <- join(train_label, activity_labels)


#Set column names
colnames(test_activity_label) <- c("activity_ID", "activity")
colnames(train_activity_label) <- c("activity_ID", "activity")
colnames(test_set) <- features[[2]]
colnames(train_set) <- features[[2]]
colnames(test_subject) <- "subject"
colnames(train_subject) <- "subject"


#add subjects
test_set_subject <- cbind(test_subject, test_set)
train_set_subject <- cbind(train_subject, train_set)

#add activity labels
test_set_full <- cbind(test_activity_label, test_set_subject)
train_set_full <- cbind(train_activity_label, train_set_subject)


#Create full merged data set
data_set_full <- rbind(test_set_full, train_set_full)

#Get list of mean and standard deviation columns 
#(not including angle() variables because they are already averages
mean_std_cols <- as.character(features[grep("mean|std", features[[2]]),2]) 

#Rename variables
names(data_set_full) <- gsub("Freq", "Frequency", names(data_set_full))
names(data_set_full) <- gsub("^t", "Time", names(data_set_full))
names(data_set_full) <- gsub("^f", "Frequency", names(data_set_full))
names(data_set_full) <- gsub("Acc", "Accelerometer", names(data_set_full))
names(data_set_full) <- gsub("Mag", "Magnitude", names(data_set_full))
names(data_set_full) <- gsub("\\()", "", names(data_set_full))
names(data_set_full) <- gsub("Gyro", "Gyroscope", names(data_set_full))
names(data_set_full) <- gsub("-", "_", names(data_set_full))

#Rename variables
mean_std_cols <- gsub("Freq", "Frequency", mean_std_cols)
mean_std_cols <- gsub("^t", "Time", mean_std_cols)
mean_std_cols <- gsub("^f", "Frequency", mean_std_cols)
mean_std_cols <- gsub("Acc", "Accelerometer", mean_std_cols)
mean_std_cols <- gsub("Mag", "Magnitude", mean_std_cols)
mean_std_cols <- gsub("\\()", "", mean_std_cols)
mean_std_cols <- gsub("Gyro", "Gyroscope", mean_std_cols)
mean_std_cols <- gsub("-", "_", mean_std_cols)

#add activity and subject
mean_std_cols <- c("activity", "subject", mean_std_cols)

#Create a new data set with only the mean and std columns
mean_std_set <- data_set_full[,mean_std_cols]


#Average of each variable for each subject
var_means <- ddply(mean_std_set, .(activity,subject), numcolwise(mean))

#Write out the "wide" tidy data
write.table(var_means, file = "variable_means.txt", row.name = FALSE)

