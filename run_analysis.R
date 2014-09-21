## 1.Merges the training and the test sets to create one data set.
## Read Data
train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train, read.table("UCI HAR Dataset/train/y_train.txt"))
train <- cbind(train, read.table("UCI HAR Dataset/train/X_train.txt"))

test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test, read.table("UCI HAR Dataset/test/y_test.txt"))
test <- cbind(test, read.table("UCI HAR Dataset/test/X_test.txt"))

## Merge
data <- rbind(train, test)
featurelist <- read.table("UCI HAR Dataset/features.txt")
colnames(data) <- c("Subject", "Activity", as.character(featurelist[,2]))

## Remove unused variables
rm(train)
rm(test)


## 2. Extracts only the measurements on the mean and standard deviation for
#     each measurement.
featuresubset <- grep("(mean|std)\\(\\)", featurelist[,2])
data <- data[,featuresubset]

## 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
data$Activity <- activities[data$Activity, "V2"]


## 4. Appropriately labels the data set with descriptive variable names.
colnames(data) <- sub("[(][)]", "", colnames(data));
colnames(data) <- sub("-", "_", colnames(data));

## 5. Create a second, independent tidy data set with the average of each 
##    variable for each activity and each subject.
library(plyr);
tidy <- ddply(data, .(Subject, Activity), numcolwise(mean));

colnames(tidy) <- paste0("mean_", colnames(tidy));
colnames(tidy)[1] <- "Subject";
colnames(tidy)[2] <- "Activity";
