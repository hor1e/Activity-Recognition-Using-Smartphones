getwd()
setwd("C:/Users/Tdashi/OneDrive/Coursera/Getting and Cleaning Data")

#Read test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote = "\"")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", quote = "\"")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote = "\"")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote = "\"")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", quote = "\"")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote = "\"")

features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")

#Merging data to onedata
onedata <- rbind(x_test, x_train)

#Labeling subject and activity
subject_label <- rbind(subject_test, subject_train)
y_label <- rbind(y_test, y_train)
onedata$Subject <- subject_label
onedata$Activity <- y_label

#Making tidy data table
subject_list <- unique(subject_label)[,1]
active_list <- unique(y_label)[,1]
tidy_data <- data.frame()
Subject <- as.vector(NULL)
act_vec <- as.vector(NULL)

for(sub in subject_list){
    for(act in active_list){
        targetData <- onedata[onedata$Subject == sub & onedata$Activity == act, ]
        meanVector <- sapply(targetData[1:561], mean)
        Subject <- append(Subject, sub)
        act_vec <- append(act_vec, act)
        tidy_data <-rbind(tidy_data, meanVector)
    }
}

#Labbeling for tiny data
Activity <- as.vector(NULL)
for(k in act_vec){
  Activity <- append(Activity, as.character(activity_labels[k,2]))
}
colnames(tidy_data) <- features[,2]
tidy_data <- cbind(Activity, Subject, tidy_data)

#Outputting tidy data 
write.table(tidy_data, "output.txt", row.names=FALSE)