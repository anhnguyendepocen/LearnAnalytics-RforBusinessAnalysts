01-take-samples-of-data.R
================
Seth Mottaghinejad
January 23, 2017

The NYC taxi data
-----------------

The New York City taxi data (hosted [here](http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml)) is an interesting example of a large dataset with lots of fun analytics applications. The original data has one CSV for each month and data spanning over multiple years. Each CSV is close to 2 GB in size. We will use this data to benchmark `RevoScaleR` functions in various compute contexts (local, Spark, and SQL). But for it's always handy to have a smaller copy of the data to develop and test our code with. For that purpose, here's to reach and extract samples from each month of the data.

The original CSVs were downloaded and put in the below folder, which we set as our working directory. We can use `readLines` to print the first 3 lines of the data.

``` r
dir(pattern = "yellow_tripdata*")
```

    ## [1] "yellow_tripdata_2016-01.csv" "yellow_tripdata_2016-02.csv"
    ## [3] "yellow_tripdata_2016-03.csv" "yellow_tripdata_2016-04.csv"
    ## [5] "yellow_tripdata_2016-05.csv" "yellow_tripdata_2016-06.csv"

``` r
print(readLines(file('yellow_tripdata_2016-01.csv'), n = 3)) # print the first 3 lines of the file
```

    ## [1] "VendorID,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,RatecodeID,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount"
    ## [2] "2,2016-01-01 00:00:00,2016-01-01 00:00:00,2,1.10,-73.990371704101563,40.734695434570313,1,N,-73.981842041015625,40.732406616210937,2,7.5,0.5,0.5,0,0,0.3,8.8"                                                                                                                         
    ## [3] "2,2016-01-01 00:00:00,2016-01-01 00:00:00,5,4.90,-73.980781555175781,40.729911804199219,1,N,-73.944473266601563,40.716678619384766,1,18,0.5,0.5,0,0,0.3,19.3"

This may not be the most efficient solution, but it runs pretty fast in the DSVM, especially if done in parallel, as we will see. We begin will read the data using the `read_csv` function in the `readr` package, which is faster than the `read.csv` function in `utils`. When specifying the column types, we can use `col_skip` to skip certain columns we don't need.

``` r
library(readr)

col_types <- cols(
  vendor_id             = col_skip(),
  pickup_datetime       = col_character(),
  dropoff_datetime      = col_character(),
  passenger_count       = col_integer(),
  trip_distance         = col_number(),
  pickup_longitude      = col_number(),
  pickup_latitude       = col_number(),
  rate_code_id          = col_factor(levels = 1:6),
  store_and_fwd_flag    = col_skip(),
  dropoff_longitude     = col_number(),
  dropoff_latitude      = col_number(),
  payment_type          = col_factor(levels = 1:4),
  fare_amount           = col_number(),
  extra                 = col_number(),
  mta_tax               = col_number(),
  tip_amount            = col_number(),
  tolls_amount          = col_number(),
  improvement_surcharge = col_number(),
  total_amount          = col_number()
)
```

Since we have multiple CSVs to read from, one for each month, we use the `lubridate` package to make it easy to get each month's data.

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
most_recent_date <- ymd("2016-07-01") # the day of the months is irrelevant
```

We can then write a naive for loop to go through the data and extact each sample.

``` r
for (ii in 1:6) {
  file_date <- most_recent_date - months(ii)
  input_csv <- sprintf('yellow_tripdata_%s.csv', substr(file_date, 1, 7))
  output_csv <- sprintf('yellow_tripsample_%s.csv', substr(file_date, 1, 7))
  nyc_taxi_monthly <- read_csv(input_csv, col_names = names(col_types$cols), col_types = col_types, skip = 1)
  n <- nrow(nyc_taxi_monthly)
  write_csv(nyc_taxi_monthly[sample(1:n, 10^6), ], path = output_csv, na = "", col_names = TRUE)
  rm(nyc_taxi_monthly)
}
```

The above approach works, but it's not the R way of doing things. You may have heard that we don't write a lot of loops in R because there's usually a cleaner way of doing things, namely by writing an R function (we call `sample_data` here) and iteratively calling it using functions such as `lappy`, `foreach`, or as we will see in our case `rxExec`.

``` r
# but the better way of doing this is to turn the above code into a function
sample_data <- function(file_date) {
  input_csv <- sprintf('yellow_tripdata_%s.csv', substr(file_date, 1, 7))
  output_csv <- sprintf('yellow_tripsample_%s.csv', substr(file_date, 1, 7))
  nyc_taxi_monthly <- read_csv(input_csv, col_names = names(col_types$cols), col_types = col_types, skip = 1)
  n <- nrow(nyc_taxi_monthly)
  write_csv(nyc_taxi_monthly[sample(1:n, 10^6), ], path = output_csv, na = "", col_names = TRUE)
  return(output_csv)
}
```

Now that we have a function, we create an object called `date_range` containing the dates the function will take as input for each iteration.

``` r
date_range <- as.character(most_recent_date - months(1:6))
date_range
```

    ## [1] "2016-06-01" "2016-05-01" "2016-04-01" "2016-03-01" "2016-02-01"
    ## [6] "2016-01-01"

We can now call the function iteratively (but without writing an explicit loop) by passing it to the `rxExec` function in `RevoScaleR`. The inputs the function is looping over are passed to the `elemArgs` argument. Any packages that need to be loaded for the function to run successfully are passed to the `packagesToLoad` argument.

``` r
# and then to run the function iteratively by passing it to the rxExec function
system.time(
  rxExec(sample_data, elemArgs = date_range, oncePerElem = TRUE, packagesToLoad = 'readr', execObjects = "col_types")
)
```

    ## Warning: 273 parsing failures.
    ##    row               col           expected actual
    ## 269055 dropoff_longitude value in level set     99
    ## 302496 dropoff_longitude value in level set     99
    ## 412382 dropoff_longitude value in level set     99
    ## 480014 dropoff_longitude value in level set     99
    ## 523413 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ## Warning: 372 parsing failures.
    ##    row               col           expected actual
    ##  35878 dropoff_longitude value in level set     99
    ## 152312 dropoff_longitude value in level set     99
    ## 167292 dropoff_longitude value in level set     99
    ## 167539 dropoff_longitude value in level set     99
    ## 181857 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ## Warning: 8012 parsing failures.
    ##    row               col           expected actual
    ##    222 dropoff_longitude value in level set     99
    ##  52665 dropoff_longitude value in level set     99
    ## 106556 dropoff_longitude value in level set     99
    ## 115555 dropoff_longitude value in level set     99
    ## 129111 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ## Warning: 329 parsing failures.
    ##    row               col           expected actual
    ## 121600 dropoff_longitude value in level set     99
    ## 177487 dropoff_longitude value in level set     99
    ## 184076 dropoff_longitude value in level set     99
    ## 186067 dropoff_longitude value in level set     99
    ## 275658 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ## Warning: 290 parsing failures.
    ##    row               col           expected actual
    ##   6831 dropoff_longitude value in level set     99
    ##  26288 dropoff_longitude value in level set     99
    ##  56414 dropoff_longitude value in level set     99
    ## 109241 dropoff_longitude value in level set     99
    ## 127194 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ## Warning: 217 parsing failures.
    ##    row               col           expected actual
    ## 109421 dropoff_longitude value in level set     99
    ## 115942 dropoff_longitude value in level set     99
    ## 148481 dropoff_longitude value in level set     99
    ## 236061 dropoff_longitude value in level set     99
    ## 323287 dropoff_longitude value in level set     99
    ## ...... ................. .................. ......
    ## See problems(...) for more details.

    ##    user  system elapsed 
    ##  250.31   14.20  267.00

In addition to making the R code look cleaner, which is a good thing in an of itself, the biggest benefit of the above approach is that we can also run it in parallel with a very small change. By defalut, an R sessions **compute context** is set to local (whichever machine R is running on) and one core only. We will now change the compute context to remain local but use multiple cores in parallel. Do do so, all we have to do is set the number of cores we want to use and set to compute context using `rxSetComputeContext`.

``` r
rxOptions(numCoresToUse = 8) # use 8 cores
rxSetComputeContext(RxLocalParallel()) # multiple cores on a single machine
system.time(
  rxExec(sample_data, elemArgs = date_range, oncePerElem = TRUE, packagesToLoad = 'readr', execObjects = "col_types")
)
```

    ##    user  system elapsed 
    ##    0.06    0.01   60.21

To combine all the CSVs into a single one, the easiest way is to us the `copy` command from the Windows command line: Simply run `copy yellow_tripsample*.csv NYC_sample.csv` and all the sample CSVs will go into a single CSV called `NYC_sample.csv`.
