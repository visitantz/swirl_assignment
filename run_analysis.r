# 1) Merges the training and the test sets to create one data set.

# test dataset
test <- read.table("X_test.txt")
test_activity_code <- read.table("y_test.txt") #read activity code into test$activity_code
test$activity_code <- test_activity_code[,1]
test$dataset <- c('test') #add test$dataset for merging

# train dataset
train <- read.table("X_train.txt")
train_activity_code <- read.table("y_train.txt") #read activity code into train$activity_code
train$activity_code <- train_activity_code[,1]
train$dataset <- c('train') #add train$dataset for merging

# combine dataset
data <- rbind(train, test)


# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 4) Appropriately labels the data set with descriptive variable names.

# read features into data variables names
features <- read.table("features.txt", stringsAsFactors=FALSE)
features <- features[,2]
names(data) <- c(features,'activity_code','dataset')

# features needed
featuresNum_need <- grep("mean|std|activity_code|dataset", names(data))
data <- data[,featuresNum_need]


# 3) Uses descriptive activity names to name the activities in the data set

# read activity_labels
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c('id', 'activity')

# merge data and activity_labels tables
data <- merge(data, activity_labels, by.x='activity_code', by.y='id')
names(data)


# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
data <- group_by(data, dataset, activity)
data_tidy <- summarise_each(data, funs(mean), -activity_code)

write.table(data_tidy, "data_tidy.txt", row.names=F)         
