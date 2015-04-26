##initialize plyr package
library(plyr);
library(dplyr);

##Check to see if file already exists in WD
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile="./data/Dataset.zip",method="auto")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

get_file_path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(get_file_path, recursive=TRUE)

##Set Test variables 
X_test_data  <- read.table(file.path(get_file_path, "test" , "X_test.txt" ),header = FALSE)
y_test_data  <- read.table(file.path(get_file_path, "test" , "Y_test.txt" ),header = FALSE)

##Set Training Variables
X_train_data <- read.table(file.path(get_file_path, "train", "X_train.txt"),header = FALSE)
y_train_data <- read.table(file.path(get_file_path, "train", "Y_train.txt"),header = FALSE)


##READ SUBJECT FILES
subject_train <- read.table(file.path(get_file_path, "train", "subject_train.txt"),header = FALSE)
subject_test  <- read.table(file.path(get_file_path, "test" , "subject_test.txt"),header = FALSE)

##MERGE FILES
subject <- rbind(subject_train, subject_test)
activity <- rbind(y_train_data, y_test_data)
features <- rbind(X_train_data, X_test_data)


names(subject) <- c("subject")
names(activity) <- c("activity")
feature_names <- read.table(file.path(get_file_path, "features.txt"),head=FALSE)
names(features) <- feature_names$V2

bind_data <- cbind(subject, activity)
DF1 <- cbind(features, bind_data)

sub_feature_names <- feature_names$V2[grep("mean\\(\\)|std\\(\\)", feature_names$V2)]

selected_names <- c(as.character(sub_feature_names), "subject", "activity" )
DF1 <- subset(DF1,select=selected_names)

actLabels <- read.table(file.path(get_file_path, "activity_labels.txt"),header = FALSE)

##Rename columns for easier reading
names(DF1)<-gsub("^t", "Time", names(DF1))
names(DF1)<-gsub("^f", "Frequency", names(DF1))
names(DF1)<-gsub("Acc", "Accelerometer", names(DF1))
names(DF1)<-gsub("Gyro", "Gyroscope", names(DF1))
names(DF1)<-gsub("Mag", "Magnitude", names(DF1))
names(DF1)<-gsub("BodyBody", "Body", names(DF1))

tidy_data <- aggregate(. ~subject + activity, DF1, mean)
tidy_data <- arrange(tidy_data, subject, activity)
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)