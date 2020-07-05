#loading required libraries
library(dplyr)


setwd("C:/Users/TECNORED/Downloads/UCI HAR Dataset")

# reading "train data"
a_train <- read.table("./train/X_train.txt")
b_train <- read.table("./train/Y_train.txt")
Sub_train <- read.table("./train/subject_train.txt")

# reading "test data:
a_test <- read.table("./test/X_test.txt")
b_test <- read.table("./test/Y_test.txt")
Sub_test <- read.table("./test/subject_test.txt")

# reading data description
var_names <- read.table("./features.txt")

# reading activity labels
activity_labels <- read.table("./activity_labels.txt")

# 1. Merging training and testing sets to create one data set
a_total <- rbind(a_train, a_test)
b_total <- rbind(b_train, b_test)
Sub_total <- rbind(Sub_train, Sub_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
sel_var <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
a_total <- a_total[,sel_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(b_total) <- "activity"
b_total$activitylabel <- factor(b_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- b_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(a_total) <- var_names[sel_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(a_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydataset.txt", row.names = FALSE, col.names = TRUE)
