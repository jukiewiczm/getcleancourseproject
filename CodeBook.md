Project's code book
===========

This file has been created to describe script content, information about transformations performed with the raw data,
and provide information about the output data set.

### Output dataset description

Starter note : for descriptive information about the raw data sets, refer to README.txt and features_info.txt
files that come with the raw data. 
Link to raw data http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its 
embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The 
experiments have been video-recorded to label the data manually.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows 
of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated 
using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, 
therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time 
and frequency domain.

For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

Each feature vector is a row on the text file.

The output data set is a whitespace-separated text file.

#### Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

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
* Aggregate the data set to obtain a dataset with average of every measure variable for each activity and each subject.
* Correct the column names to inform that they describe the average from now on, that is, append "averaged" to every
measure variable.

With the transformations described, the tidy aggregate data set is obtained in the form described in the first section.
