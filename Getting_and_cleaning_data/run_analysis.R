get_tidy_set <- function() {
    ### Function which will merge sets from original files ###
    merge_sets <- function() {
        ### Importing test stats: ###
        test_part <- read.table("./UCI HAR Dataset/test/subject_test.txt")
        test_activity_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
        test_measurements <- read.table("./UCI HAR Dataset/test/X_test.txt")
        ### Importing training stats: ###
        train_part <- read.table("./UCI HAR Dataset/train/subject_train.txt")
        train_activity_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
        train_measurements <- read.table("./UCI HAR Dataset/train/X_train.txt")
        
        ### Forming single set for test stats such that:
        ### the first column is a list of participants (test part),
        ### the second column is a list of activity labels (for test participants)
        ### and rest columns are data set with measurements
    
        test_single_table <- cbind(test_part,test_activity_labels,test_measurements)
        
        ### Forming single set for train stats such that:
        ### the first column is a list of participants (train part),
        ### the second column is a list of activity labels (for train participants)
        ### and rest columns are data set with measurements
        
        train_single_table <- cbind(train_part,train_activity_labels,train_measurements)
        
        ### Forming one data set by merging training and test data sets:
        
        single_data_set <- rbind(train_single_table,test_single_table)
        single_data_set
    }
    ### Function which will replace atcivity ID's with descriptive activity names ###
    name_activities <- function(data_set) {
        activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
        for (i in 1:length(data_set[,2])) {
            data_set[i,2] = activity_names[data_set[i,2],2]
        }
        data_set
    }
    ### Function 'name_variables' will extract descriptive variable names ###
    ### from 'features.txt' and set them as columns names in data set     ###
    name_variables <- function(data_set2) {
        variable_names <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
        list_of_names <- c("Participants","Activity",variable_names[,2])
        names(data_set2) <- list_of_names
        data_set2
    }
    
    ### Extract only the measurements on the mean and standard deviation for each measurement:
    extract_mean_std <- function(data_set3) {
        ### Get list of columns with the mean of measurements (not meanFreq) ###
        mean_in <- grepl("mean",names(data_set3),fixed=TRUE)
        meanFreq_in <- grepl("meanFreq",names(data_set3),fixed=TRUE)
        for (i in 1:length(mean_in)) {
            if (meanFreq_in[i]) { mean_in[i] = FALSE }
        }
        ### Get list of columns with the standard deviation for measurements ###
        std_in <- grepl("std",names(data_set3))
        ### Create list of columns with the standard deviation
        ### and the mean for measurements with the first and the second columns (paticipant&activity)
        list_of_needed_columns <- (std_in | mean_in | c(TRUE,TRUE,seq(from=FALSE,to=FALSE,length.out = 561)))
        ### Create set with only needed columns:
        new_set = data_set3[list_of_needed_columns]
        new_set
    }
    ### Create a set with the average of each variable for each activity and each participant:
    create_set_with_averages <- function(data_set4) {
        ### Create new data frame which will contain tidy data ###
        tidy_df <- data.frame(matrix(0,nrow = 0,ncol = 68))
        ### Create temporary data frame to count means of measurements which will
        ### then be moved to tidy_df
        temp_string <- data.frame(matrix(0,nrow = 1,ncol = 68))
        ### Cycles to form and count means of measurements for each participant
        ### and each activity:
        for (i in levels(as.factor(data_set4[,1]))) {
            temp_string[1] = i
            for (j in levels(as.factor(data_set4[,2]))) {
                temp_string[2] = j
                ### Get data for participant 'i' and activity 'j' from data_set4 (list of columns 
                ### with the standard deviation and the mean for measurements
                ### with the first and the second columns (paticipant&activity))
                temp_df <- data_set4[data_set4$Participants==i & data_set4$Activity==j,]
                temp_string[3:ncol(data_set4)] <- colMeans(temp_df[,3:ncol(data_set4)])
                tidy_df <- rbind(tidy_df,temp_string)
            }
        }
        ### Set needed names for tidy data set:
        names(tidy_df) = names(data_set4)
        tidy_df
    }
    
    final_set <- merge_sets()
    final_set <- name_activities(final_set)
    final_set <- name_variables(final_set)
    final_set <- extract_mean_std(final_set)
    final_set <- create_set_with_averages(final_set)
    write.table(final_set, file = "./tidy_set.txt", row.names = FALSE)
    final_set
}