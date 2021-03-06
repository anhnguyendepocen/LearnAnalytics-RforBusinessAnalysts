Getting started
================
Seth Mottaghinejad
2017-02-08

We begin by loading the required packages and loading the data into R.

Loading packages
----------------

We begin by loading the required libraries we will use throughout the course. We reload these libraries later when we run the functions inside them, but putting them at the top of the project gives us a chance to see all of them in one place, and install any libraries we don't already have using `install.packages`.

``` r
# let's set some options for how things look on the console
options(max.print = 1000, # limit how much data is shown on the console
    scipen = 999, # don't use scientific notation for numbers
    width = 90, # width of the screen should be 80 characters long
    digits = 3) # round all numbers to 3 decimal places when displaying them

library(tidyverse)
library(dplyr) # for fast data manipulation/processing/summarizing
options(dplyr.print_max = 20) # limit how much data `dplyr` shows by default
options(dplyr.width = Inf) # make `dplyr` show all columns of a dataset
library(stringr) # for working with strings
library(lubridate) # for working with date variables
Sys.setenv(TZ = "US/Eastern") # not important for this dataset
library(ggplot2) # for creating plots
library(ggrepel) # avoid text overlap in plots
library(tidyr) # for reshaping data
library(seriation) # package for reordering a distance matrix
library(zoo) # package with functions for rolling calculations

library(rgeos) # GIS package
library(maptools)

library(profr) # profiling tool
library(microbenchmark) # benchmarking tool
```

In the next chapter, we deal with our first challenge: loading the data into R.

Loading data into R
-------------------

The process of loading data into R can change based on the kind of data or where the data is stored. The standard format for data is **tabular**. A CSV file is an example of tabular data. We read flat files into R using `read_csv` which assumes by default that

-   a comma is used to separate entries
-   column headers are at the top
-   rows all have an equal number of entries, with two adjacent commas representing an empty cell
-   file only contains the data, with all other meta-data stored in a separate file referred to as the **data dictionary**

As a starting point, we can use the `readLines` function in R to print the first few lines of the data. The data is stored in the folder to which `data_dir` points.

``` r
cat(readLines(file.path(data_dir, 'yellow_tripsample_2016-01.csv'), n = 3)) # print the first 3 lines of the file
```

    ## pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount 2016-01-16 19:30:38,2016-01-16 19:44:42,1,2.2,-73.956298828125,40.78182220458986,1,-73.9823684692383,40.77283096313477,1,11.5,0.0,0.5,3.0,0.0,0.3,15.3 2016-01-16 22:21:42,2016-01-16 22:35:30,2,6.359999999999999,-73.97758483886719,40.74228668212891,1,-73.985595703125,40.685646057128906,1,19.5,0.5,0.5,5.2,0.0,0.3,26.0

If we examine the documentation for `read_csv` we would see that there are many arguments worth knowing about, such as

-   `n_max` for limiting the number of rows we read,
-   `na` for specifying what defines an NA in a `character` column,
-   `skip` for skipping a certain number of rows before we start reading the data

Time to run `read_csv`. Since the dataset we read is relatively large, we time how long it takes to load it into R. Once all the data is read, we have an object called `nyc_taxi` loaded into the R session. This object is an R `data.frame`. We can run a simple query on `nyc_taxi` by passing it to the `head` function.

``` r
library(lubridate)
most_recent_date <- ymd("2016-07-01") # the day of the months is irrelevant

read_each_month <- function(ii, ...) {
    file_date <- most_recent_date - months(ii)
    input_csv <- sprintf('yellow_tripsample_%s.csv', substr(file_date, 1, 7))
    nyc_taxi_monthly <- read_csv(file.path(data_dir, input_csv), ...)
    print(nrow(nyc_taxi_monthly))
    return(nyc_taxi_monthly)
}

col_types <- cols( # for now we keep the datetime columns as strings
    pickup_datetime       = col_character(),
    dropoff_datetime      = col_character()
    )

st <- Sys.time()
nyc_taxi <- bind_rows(lapply(1:6, read_each_month, progress = FALSE, col_types = col_types))
```

    ## [1] 1000000
    ## [1] 1000000
    ## [1] 1000000
    ## [1] 1000000
    ## [1] 1000000
    ## [1] 1000000

``` r
Sys.time() - st
```

    ## Time difference of 41 secs

``` r
print(class(nyc_taxi))
```

    ## [1] "tbl_df"     "tbl"        "data.frame"

It is important to know that `nyc_taxi` is no longer linked to the original CSV file: The CSV file resides somewhere on disk, but `nyc_taxi` is a **copy** of the CSV file sitting in memory. Any modifications we make to this file will not overwrite the CSV file, or any file on disk, unless we explicitly do so (for example by using `write.table`). Let's begin by comparing the size of the original CSV file with the size of its copy in the R session.

``` r
obj_size_mb <- as.integer(object.size(nyc_taxi)) / 2^20 # size of object in memory (we divide by 2^20 to convert from bytes to megabytes)
obj_size_mb # size of memory object in R representing data
```

    ## [1] 1371

``` r
file_size_mb <- file.size(file.path(data_dir, 'yellow_tripsample_2016-01.csv')) / 2^20 # size of the original file
file_size_mb * 6 # approximate size of the 6 CSVs on disk
```

    ## [1] 912

As we can see, the object `nyc_taxi` takes up more space in memory than the CSV file does on disk. Since the amount of available memory on a computer is much smaller than available disk space, for a long time the need to load data in its entirety in the memory imposed a serious limitation on using R with large datasets. Over the years, machines have been endowed with more CPU power and more memory, but data sizes have grown even more, so fundamentally the problem is still there. As we become better R programmers, we can learn ways to more efficiently load and process the data, but writing efficient R code is not always easy. Sometimes, doing so is not even desirable, as the resulting code can end up looking hard to read and understand.

Nowadays there are R libraries that provide us with ways to handle large datasets in R quickly and without hogging too much memory. Microsoft R Server's `RevoScaleR` library is an example of such a package. `RevoScaleR` is covered in a different course for which the current course can serve as a prerequisite.

With the data loaded into R, we can now set out to examine its content, which is the subject of the next chapter.
