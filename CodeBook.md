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