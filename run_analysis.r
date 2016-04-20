# 1) Merges the training and the test sets to create one data set.

# test dataset
test <- read.table("X_test.txt")
test_activity_code <- read.table("y_test.txt") #read activity code into test$activity_code
test$activity_code <- test_activity_code[,1]
test_subject <- read.table("subject_test.txt")#read subject into test$subject
test$subject <- test_subject[,1]

# train dataset
train <- read.table("X_train.txt")
train_activity_code <- read.table("y_train.txt") #read activity code into train$activity_code
train$activity_code <- train_activity_code[,1]
train_subject <- read.table("subject_train.txt") #read subject into train$subject
train$subject <- train_subject[,1]

# combine dataset
data <- rbind(train, test)


# 4) Appropriately labels the data set with descriptive variable names.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.

# read features into data variables names
features <- read.table("features.txt", stringsAsFactors=FALSE)
features <- features[,2]
names(data) <- c(features,'activity_code','subject')

# features needed
featuresNum_need <- grep("mean|std|activity_code|subject", names(data))
data <- data[,featuresNum_need]


# 3) Uses descriptive activity names to name the activities in the data set

# read activity_labels
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c('id', 'activity')

# merge data and activity_labels tables
data <- merge(data, activity_labels, by.x='activity_code', by.y='id')


# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
data <- group_by(data, subject, activity)
data_tidy <- summarise_each(data, funs(mean), -activity_code) #summary, block 'activity code'

write.table(data_tidy, "data_tidy.txt", row.names=F)         
