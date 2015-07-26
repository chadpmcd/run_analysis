# run_analysis.R Readme

## Summary
This program does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Packages
- Check to see if the required packages (plyr, dplyr) can be loaded and if not, they are installed from source and then loaded

## Pull data
- The run_analysis script pulls down the data from a zip file online (URL: "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
- Run the get.zip function which creates a temp dir, downloads the zip file into the temp dir, unzips it, and returns the location and list of files.

## Sort and reads files
- Grab the files that will be needed for analysis based on name (used the features_info and README.txt from the data set to determine the correct files)
- Read the files into dataframes

## Join the activity labels to activity text
- Join the data for the numerical labels and the text based labels for both the test and train label data

## Renamed columns
- Give descriptive names to the columns for all datasets

## Create merged set of data and rename variables to be more readable
- Cbind the subject data to the test and train datasets
- Cbind the activity data to the test and train datasets
- Rbind the test and train data sets together to create one dataset
- Create a list of the mean, std (standard deviation), activity, and subject columns
- Rename the variables in the main dataset and in the list of columns to be more human readable

## Create a subset of data
- Subset the full data set and create a subset data.frame with only the mean, std, activity, and subject columns

## Create a new data set with means of each numerical column
- use ddply to group by activity and subject and run a mean on all the other columnns

## Write mean data out to file
- Write to file using write.table to variable_means.txt

## Note
See codebook.txt for detailed notes on variable names and contents
