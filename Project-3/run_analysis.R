### LOAD THE DATASETS
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

### 1. COMBINE THE TRAIN AND TEST TOGETHER
tot_x <- rbind(X_train, X_test)
tot_y <- rbind(y_train, y_test)

### 2. EXTRACT ONLY THE MEAN AND STD OF EACH MEASUREMENTS
features <- read.table("features.txt")
colnames(features) <- c("col", "name")
meanstd <- grep("[Mm]ean|std", features$name)

wanted <- tot_x[, meanstd]
head(wanted)
wanted_features <- features[meanstd, ]

### 3. REPLACE ACITIVITY TO NAMES
tot_y$activity <- as.character(tot_y$activity)
tot_y$activity <-  sub("1", "WALKING", tot_y$activity)
tot_y$activity <-  sub("2", "WALKING_UPSTAIRS", tot_y$activity)
tot_y$activity <-  sub("3", "WALKING_DOWNSTAIRS", tot_y$activity)
tot_y$activity <-  sub("4", "SITTING", tot_y$activity)
tot_y$activity <-  sub("5", "STANDING", tot_y$activity)
tot_y$activity <-  sub("6", "LAYING", tot_y$activity)

### 4. LABEL THE DATASET WITH DESCRIPTIVE VARIABLES
colnames(wanted) <- wanted_features[["name"]]
head(wanted)
colnames(tot_y) <- c("activity")
names(wanted)<-gsub("Acc", "Accelerometer", names(wanted))
names(wanted)<-gsub("Gyro", "Gyroscope", names(wanted))
names(wanted)<-gsub("BodyBody", "Body", names(wanted))
names(wanted)<-gsub("Mag", "Magnitude", names(wanted))
names(wanted)<-gsub("^t", "Time", names(wanted))
names(wanted)<-gsub("^f", "Frequency", names(wanted))
names(wanted)<-gsub("tBody", "TimeBody", names(wanted))
names(wanted)<-gsub("-mean()", "Mean", names(wanted), ignore.case = TRUE)
names(wanted)<-gsub("-std()", "STD", names(wanted), ignore.case = TRUE)
names(wanted)<-gsub("-freq()", "Frequency", names(wanted), ignore.case = TRUE)
names(wanted)<-gsub("angle", "Angle", names(wanted))
names(wanted)<-gsub("gravity", "Gravity", names(wanted))

tot <- cbind(tot_y, wanted) ##### COMBINE y AND x TOGETHER


### 5. CREATE A TIDY DATA SET WITH THE AVERAGE FOR 
###    EACH ACTIVITY AND EACH SUBJECT
subject_train <- read.table("./train/subject_train.txt",  
                            col.names = c("subject"))
subject_test <- read.table("./test/subject_test.txt", 
                           col.names = c("subject"))

tot_sub <- rbind(subject_train, subject_test)
tot <- cbind(tot_sub, tot)
library(dplyr)
result <- tot %>% group_by(subject, activity) %>% summarize_all(mean)
write.table(result, "result.txt", row.names = FALSE)

### 6. CREATE A NEWLY UPDATED CODE BOOK
wanted_features$name <-gsub("Acc", "Accelerometer", wanted_features$name)
wanted_features$name <-gsub("Gyro", "Gyroscope", wanted_features$name)
wanted_features$name <-gsub("BodyBody", "Body", wanted_features$name)
wanted_features$name <-gsub("Mag", "Magnitude", wanted_features$name)
wanted_features$name <-gsub("^t", "Time", wanted_features$name)
wanted_features$name <-gsub("^f", "Frequency", wanted_features$name)
wanted_features$name <-gsub("tBody", "TimeBody", wanted_features$name)
wanted_features$name <-gsub("-mean()", "Mean", wanted_features$name, ignore.case = TRUE)
wanted_features$name <-gsub("-std()", "STD", wanted_features$name, ignore.case = TRUE)
wanted_features$name <-gsub("-freq()", "Frequency", wanted_features$name, ignore.case = TRUE)
wanted_features$name <-gsub("angle", "Angle", wanted_features$name)
wanted_features$name <-gsub("gravity", "Gravity", wanted_features$name)

write.table(wanted_features, "../code_book.txt", row.names = FALSE)
