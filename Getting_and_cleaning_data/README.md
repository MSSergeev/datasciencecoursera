Script 'run_analysis.R' forms tidy data set from the Samsung data, if it’s currently in your working directory.

It takes the following steps:

1. Function 'merge_sets' reads information from datasets for train and test part.
It forms two data sets: test_single_table and train_single_table (with first two columns — Participants and Activity and 561 rows - variables measurements).
Then it merges thous two sets into single set for both parts: test and train.

2. Function 'name_activities' extracts descriptive activity names from the file '/UCI HAR Dataset/activity_labels.txt' and names activities in data set with them.

3. Function 'name_variables' extracts descriptive variable names from the file '/UCI HAR Dataset/features.txt' and sets them as columns names in data set.

4. Function 'extract_mean_std' extracts only the measurements on the mean and standard deviation for each measurement. It uses grepl function which parses names(data_set) for "mean" and "std", excluding "meanFreq".

Then this function form new set (new_set) with only needed columns.

5. Function 'create_set_with_averages' splits data set (from function 'extract_mean_std') into number of smaller sets by participants and activity (one set for each pair participant-activity). Then it determines mean values for each measurement in this small sets and append them to final data set with tidy data.

6. Script saves data set with tidy data into file './tidy_set.txt' and then gives this data set as output.
