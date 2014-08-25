Project's code book
===========

This file has been created to describe script content, information about transformations performed with the raw data,
and provide information about the output data set.

### Output dataset description

The output data set is a whitespace-separated text file.

### Script content

There is only one script file in the project that does all the work. Reason for this is that there 
was no need for reusing the code more than once, as the task was to process only one set of
particular data. I haven't created any really reusable functions (all the code is adjusted to the
data set being processed, generalization was not one of my goals in this task) and no function is called
twice or more.

The script source is divided into few functions. Although the code is rather not reusable to other
datasets, I personally like to split code into many separate functions, because it makes code more
consistent and easier to read in my opinion.

The script performs the following jobs in order:
1. Check for existence of the data and download it if necessary.
2. Load the data from files.
3. Clean up and organize the data (more details on that below).
4. Create intermediate tidy data set.
5. Save this data set to the text file.
6. Create aggregated tidy data set.
7. Save the aggregated data set to the text file.

For more information about what is a "tidy data set" take a look at:
https://github.com/jukiewiczm/datasharing

### Transformations of the raw data

Note : for descriptive information about the raw data sets, refer to README.txt and features_info.txt
files that come with the raw data. 
Link to raw data http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The following transformations has been performed to the raw data sets:
* Get rid of unwanted variables in X_test and X_train data sets. The only variables wanted were the ones
related to the mean or standard deviation of particular measure. These were named as [variable-name]-mean()
or [variable-name]-std() in the raw data sets, where [variable-name] stands for particular variable name.
* Join the X_test data set with y_test and subject_test data sets to achieve all the test data in one piece
* Join the X_train data set with y_train and subject_train data sets for the same reason as above
* For both of the merged sets above, join the numeric value of Y with their descriptive correspondents
to obtain descriptive activity names.
* Assign proper column names to the X_test and X_train data sets. These were taken from the features.txt file.
* Process the column names to the correct and more readable form (the exact form was described above).
* Merge the two created data sets to obtain one data set with both the train and the test observations.
* 
