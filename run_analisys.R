# run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
setwd(".")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train_data <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train <- cbind(train_labels, train_subjects, train_data)
test <- cbind(test_labels, test_subjects, test_data)
all <- rbind(test, train)
activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")

# Uses descriptive activity names to name the activities in the data set
all[[1]] <-factor(all[[1]], levels = activities$V1, labels = activities$V2)

# Appropriately labels the data set with descriptive variable names. 
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
names(all)[1] <- c("activity")
names(all)[2] <- c("subject")
names(all)[3:563] <- as.character.factor(features$V2)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
all_mean_std<- all[,grep("activity|subject|mean()|std()", colnames(all)) ]

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
DT <- data.table(all)
tidy2<-DT[,lapply(.SD,mean),by="activity,subject"]
write.table(tidy2,file="tidy2.txt",sep=",",row.names = FALSE)
