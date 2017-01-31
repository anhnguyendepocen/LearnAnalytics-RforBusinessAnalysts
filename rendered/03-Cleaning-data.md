Cleaning the data
================
Seth Mottaghinejad
2017-01-31

In the last section, we proposed ways that we could clean the data. In this section, we actually clean the data. Let's review where we are in the EDA (exploratory data analysis) process:

1.  load all the data (and combine them if necessary)
2.  inspect the data in preparation cleaning it
3.  **clean the data in preparation for analysis**
4.  add any interesting features or columns as far as they pertain to the analysis
5.  find ways to analyze or summarize the data and report your findings

### Exercises

Run `summary` on the data.

``` r
summary(nyc_taxi)
```

    ##  pickup_datetime    dropoff_datetime   passenger_count trip_distance    
    ##  Length:6000000     Length:6000000     Min.   :0.00    Min.   :      0  
    ##  Class :character   Class :character   1st Qu.:1.00    1st Qu.:      1  
    ##  Mode  :character   Mode  :character   Median :1.00    Median :      2  
    ##                                        Mean   :1.66    Mean   :      4  
    ##                                        3rd Qu.:2.00    3rd Qu.:      3  
    ##                                        Max.   :9.00    Max.   :1674368  
    ##                                                                         
    ##  pickup_longitude pickup_latitude  rate_code_id dropoff_longitude
    ##  Min.   :-121.9   Min.   : 0.0    Min.   :1     Min.   :-122     
    ##  1st Qu.: -74.0   1st Qu.:40.7    1st Qu.:1     1st Qu.: -74     
    ##  Median : -74.0   Median :40.8    Median :1     Median : -74     
    ##  Mean   : -72.9   Mean   :40.2    Mean   :1     Mean   : -73     
    ##  3rd Qu.: -74.0   3rd Qu.:40.8    3rd Qu.:1     3rd Qu.: -74     
    ##  Max.   :   0.0   Max.   :57.3    Max.   :6     Max.   :   0     
    ##                                   NA's   :767                    
    ##  dropoff_latitude  payment_type   fare_amount         extra    
    ##  Min.   :  0      Min.   :1.00   Min.   :  -450   Min.   :-36  
    ##  1st Qu.: 41      1st Qu.:1.00   1st Qu.:     6   1st Qu.:  0  
    ##  Median : 41      Median :1.00   Median :    10   Median :  0  
    ##  Mean   : 40      Mean   :1.34   Mean   :    13   Mean   :  0  
    ##  3rd Qu.: 41      3rd Qu.:2.00   3rd Qu.:    14   3rd Qu.:  0  
    ##  Max.   :405      Max.   :4.00   Max.   :628545   Max.   :636  
    ##                   NA's   :2                                    
    ##     mta_tax       tip_amount   tolls_amount improvement_surcharge
    ##  Min.   :-2.7   Min.   :-64   Min.   :-12   Min.   :-0.30        
    ##  1st Qu.: 0.5   1st Qu.:  0   1st Qu.:  0   1st Qu.: 0.30        
    ##  Median : 0.5   Median :  1   Median :  0   Median : 0.30        
    ##  Mean   : 0.5   Mean   :  2   Mean   :  0   Mean   : 0.30        
    ##  3rd Qu.: 0.5   3rd Qu.:  2   3rd Qu.:  0   3rd Qu.: 0.30        
    ##  Max.   :80.5   Max.   :844   Max.   :906   Max.   : 0.76        
    ##                                                                  
    ##   total_amount   
    ##  Min.   :  -451  
    ##  1st Qu.:     9  
    ##  Median :    12  
    ##  Mean   :    16  
    ##  3rd Qu.:    18  
    ##  Max.   :629034  
    ## 

What are some important things we can tell about the data by looking at the above summary?

Discuss possible ways that some columns may need to be 'cleaned'. By 'cleaned' here we mean - reformatted into the appropriate type, - replaced with another value or an NA, - removed from the data for the purpose of the analysis.

### Solutions

Here are some of the ways we can clean the data:

-   `pickup_datetime` and `dropoff_datetime` should be `datetime` columns, not `character`
-   `rate_code_id` and `payment_type` should be a `factor`, not `character`
-   the geographical coordinates for pick-up and drop-off occasionally fall outside a reasonable bound (probably due to error)
-   `fare_amount` is sometimes negative (could be refunds, could be errors, could be something else)

Some data-cleaning jobs depend on the analysis. For example, turning `payment_type` into a `factor` is unnecessary if we don't intend to use it as a categorical variable in the model. Even so, we might still benefit from turning it into a factor so that we can see counts for it when we run `summary` on the data, or have it show the proper labels when we use it in a plot. Other data- cleaning jobs on the other hand relate to data quality issues. For example, unreasonable bounds for pick-up or drop-off coordinates can be due to error. In such cases, we must decide whether we should clean the data by

-   removing rows that have incorrect information for some columns, even though other columns might still be correct
-   replace the incorrect information with NAs and decide whether we should impute missing values somehow
-   leave the data as is, but think about how doing so could skew some results from our analysis

Dealing with datetimes
----------------------

Next we format `pickup_datetime` and `dropoff_datetime` as `datetime` columns. There are different functions for dealing with `datetime` column types, including functions in the `base` package, but we will be using the `lubridate` package for its rich set of functions and simplicity.

``` r
library(lubridate)
Sys.setenv(TZ = "US/Pacific") # not important for this dataset, but this is how we set the time zone
```

The function we need is called `ymd_hms`, but before we run it on the data let's test it on a string. Doing so gives us a chance to test the function on a simple input and catch any errors or wrong argument specifications.

``` r
ymd_hms("2015-01-25 00:13:08", tz = "US/Eastern") # we can ignore warning message about timezones
```

    ## [1] "2015-01-25 00:13:08 EST"

We seem to have the right function and the right set of arguments, so let's now apply it to the data. If we are still unsure about whether things will work, it might be prudent to not immediately overwrite the existing column. We could either write the transformation to a new column or run the transformation on the first few rows of the data and just display the results in the console.

``` r
ymd_hms(nyc_taxi$pickup_datetime[1:20], tz = "US/Eastern")
```

    ##  [1] "2016-06-21 21:33:52 EDT" "2016-06-08 09:52:19 EDT"
    ##  [3] "2016-06-14 23:27:22 EDT" "2016-06-12 20:13:12 EDT"
    ##  [5] "2016-06-10 23:40:21 EDT" "2016-06-28 16:46:23 EDT"
    ##  [7] "2016-06-26 14:19:52 EDT" "2016-06-24 05:31:36 EDT"
    ##  [9] "2016-06-18 12:56:02 EDT" "2016-06-01 20:20:56 EDT"
    ## [11] "2016-06-14 21:02:39 EDT" "2016-06-08 14:56:59 EDT"
    ## [13] "2016-06-19 17:11:54 EDT" "2016-06-03 17:15:58 EDT"
    ## [15] "2016-06-11 04:43:17 EDT" "2016-06-13 12:21:37 EDT"
    ## [17] "2016-06-30 23:50:48 EDT" "2016-06-15 15:09:48 EDT"
    ## [19] "2016-06-20 20:34:31 EDT" "2016-06-16 19:06:37 EDT"

We now apply the transformation to the whole data and overwrite the original column with it.

``` r
nyc_taxi$pickup_datetime <- ymd_hms(nyc_taxi$pickup_datetime, tz = "US/Eastern")
```

There's another way to do the above transformation: by using the `transform` function. Just as was the case with `subset`, `transform` allows us to pass the data as the first argument so that we don't have to prefix the column names with `nyc_taxi$`. The result is a cleaner and more readable notation.

``` r
nyc_taxi <- transform(nyc_taxi, dropoff_datetime = ymd_hms(dropoff_datetime, tz = "US/Eastern"))
```

Let's now see some of the benefits of formatting the above columns as `datetime`. The first benefit is that we can now perform date calculations on the data. Say for example that we wanted to know how many data points are in each week. We can use `table` to get the counts and the `week` function in `lubridate` to extract the week (from 1 to 52 for a non-leap year) from `pickup_datetime`.

``` r
table(week(nyc_taxi$pickup_datetime)) # `week`
```

    ## 
    ##      1      2      3      4      5      6      7      8      9     10 
    ## 214051 243272 246876 184836 239827 241759 245821 243568 239014 227594 
    ##     11     12     13     14     15     16     17     18     19     20 
    ## 229391 227115 216875 236555 238668 234649 219985 236080 232334 237423 
    ##     21     22     23     24     25     26 
    ## 229126 203470 240475 234064 229246 227925

``` r
table(week(nyc_taxi$pickup_datetime), month(nyc_taxi$pickup_datetime)) # `week` and `month` are datetime functions
```

    ##     
    ##           1      2      3      4      5      6
    ##   1  214051      0      0      0      0      0
    ##   2  243272      0      0      0      0      0
    ##   3  246876      0      0      0      0      0
    ##   4  184836      0      0      0      0      0
    ##   5  110965 128862      0      0      0      0
    ##   6       0 241759      0      0      0      0
    ##   7       0 245821      0      0      0      0
    ##   8       0 243568      0      0      0      0
    ##   9       0 139990  99024      0      0      0
    ##   10      0      0 227594      0      0      0
    ##   11      0      0 229391      0      0      0
    ##   12      0      0 227115      0      0      0
    ##   13      0      0 216875      0      0      0
    ##   14      0      0      0 236555      0      0
    ##   15      0      0      0 238668      0      0
    ##   16      0      0      0 234649      0      0
    ##   17      0      0      0 219985      0      0
    ##   18      0      0      0  70143 165937      0
    ##   19      0      0      0      0 232334      0
    ##   20      0      0      0      0 237423      0
    ##   21      0      0      0      0 229126      0
    ##   22      0      0      0      0 135180  68290
    ##   23      0      0      0      0      0 240475
    ##   24      0      0      0      0      0 234064
    ##   25      0      0      0      0      0 229246
    ##   26      0      0      0      0      0 227925

Another benefit of the `datetime` format is that plotting functions can do a better job of displaying the data in the expected format.\# (2) many data summaries and data visualizations automatically 'look right' when the data has the proper format. We do not cover data visualization in-depth in this course, but we provide many examples to get you started. Here's a histogram of `pickup_datetime`.

``` r
library(ggplot2)
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = pickup_datetime), col = "black", fill = "lightblue",
  binwidth = 60*60*24*7) # the bin has a width of one week
```

![](images/unnamed-chunk-11-1.png)

Notice how the x-axis is properly formatted as a date without any manual input from us. Both the summary and the plot above would not have been possible if `pickup_datetime` was still a character column.

Dealing with factors
--------------------

It's time to turn our attention to the categorical columns in the dataset. Ideally, categorical columns should be turned into `factor` (usually from `character` or `integer`). A `factor` is the appropriate data type for a categorical column. When we loaded the data in R using `read.csv`, we set `stringsAsFactors = FALSE` to prevent any `character` columns from being turned into a factor. This is generally a good idea, because some character columns (such as columns with raw text in them or alpha-numeric ID columns) are not appropriate for factors. Accidentally turning such columns into factors can result in overhead, especially when data sizes are large. The overhead is the result of R having to keep a tally of all the factor levels. We do not have any `character` columns in this dataset that need to be converted to factors, but we have `integer` columns that represent categorical data. These are the columns with low cardinality, as can be seen here:

``` r
sapply(nyc_taxi, num.distinct)
```

    ##       pickup_datetime      dropoff_datetime       passenger_count 
    ##               4819099               4818760                    10 
    ##         trip_distance      pickup_longitude       pickup_latitude 
    ##                  4035                 31159                 56804 
    ##          rate_code_id     dropoff_longitude      dropoff_latitude 
    ##                     7                 47211                 80240 
    ##          payment_type           fare_amount                 extra 
    ##                     5                  1524                    40 
    ##               mta_tax            tip_amount          tolls_amount 
    ##                    15                  3100                   716 
    ## improvement_surcharge          total_amount 
    ##                     8                  9541

Fortunately, the site that hosted the dataset also provides us with a [data dictionary](http://www.nyc.gov/html/tlc/downloads/pdf/data_dictionary_trip_records_y%20ellow.pdf). Going over the document helps answer what the categorical columns are and what each category represents.

For example, for `rate_code_id`, the mapping is as follows:

-   1 = Standard rate
-   2 = JFK
-   3 = Newark
-   4 = Nassau or Westchester
-   5 = Negotiated fare
-   6 = Group ride

The above information helps us properly label the factor levels.

Notice how `summary` shows us numeric summaries for the categorical columns right now.

``` r
summary(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # shows numeric summaries for both columns
```

    ##   rate_code_id  payment_type 
    ##  Min.   :1     Min.   :1.00  
    ##  1st Qu.:1     1st Qu.:1.00  
    ##  Median :1     Median :1.00  
    ##  Mean   :1     Mean   :1.34  
    ##  3rd Qu.:1     3rd Qu.:2.00  
    ##  Max.   :6     Max.   :4.00  
    ##  NA's   :767   NA's   :2

A quick glance at `payment_type` shows two payments as by far the most common. The data dictionary confirms for us that they correspond to card and cash payments.

``` r
table(nyc_taxi$payment_type)
```

    ## 
    ##       1       2       3       4 
    ## 3982658 1986124   23153    8063

We now turn both `rate_code_id` and `payment_type` into `factor` columns. For `rate_code_id` we keep all the labels, but for `payment_type` we only keep the two most common and label them as 'card' and 'cash'. We do so by specifying `levels = 1:2` instead of `levels = 1:6` and provide labels for only the first two categories. This means the other values of `payment_type` get lumped together and replaced with NAs, resulting in information loss (which we are comfortable with, for the sake of this analysis).

``` r
nyc_taxi <- transform(nyc_taxi,
rate_code_id = factor(rate_code_id,
levels = 1:6, labels = c('standard', 'JFK', 'Newark', 'Nassau or Westchester', 'negotiated', 'group ride')),
payment_type = factor(payment_type,
levels = 1:2, labels = c('card', 'cash')
))
```

``` r
head(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # now proper labels are showing in the data
```

    ##   rate_code_id payment_type
    ## 1     standard         card
    ## 2     standard         cash
    ## 3     standard         card
    ## 4     standard         card
    ## 5     standard         card
    ## 6     standard         cash

``` r
summary(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # now counts are showing in the summary
```

    ##                 rate_code_id     payment_type  
    ##  standard             :5839179   card:3982658  
    ##  JFK                  : 128092   cash:1986124  
    ##  Newark               :  10939   NA's:  31218  
    ##  Nassau or Westchester:   2716                 
    ##  negotiated           :  18253                 
    ##  group ride           :     54                 
    ##  NA's                 :    767

It is very important that the `labels` be in the same order as the `levels` they map into.

What about `passenger_count`? should it be treated as a `factor` or left as integer? The answer is it depends on how it will be used, especially in the context of modeling. Most of the time, such a column is best left as `integer` in the data and converted into factor 'on-the-fly' when need be (such as when we want to see counts, or when we want a model to treat the column as a `factor`).

Our data-cleaning is for now done. We are ready to now add new features to the data, but before we do so, let's briefly revisit what we have so far done from the beginning, and see if we could have taken any shortcuts. That is the subject of the next chapter.

### Exercises

Let's create a sample with replacement of size 2000 from the colors red, blue and green. This is like reaching into a jar with three balls of each color, grabbing one and recording the color, placing it back into the jar and repeating this 2000 times.

``` r
rbg_chr <- sample(c("red", "blue", "green"), 2000, replace = TRUE)
```

We add one last entry to the sample: the entry is 'pink':

``` r
rbg_chr <- c(rbg_chr, "pink") # add a pink entry to the sample
```

We now turn `rbg_chr` (which is a character vector) into a `factor` and call it `rbg_fac`. We then drop the 'pink' entry from both vectors.

``` r
rbg_fac <- factor(rbg_chr) # turn `rbg_chr` into a `factor` `rbg_fac`
rbg_chr <- rbg_chr[1:(length(rbg_chr)-1)] # dropping the last entry from `rbg_chr`
rbg_fac <- rbg_fac[1:(length(rbg_fac)-1)] # dropping the last entry from `rbg_fac`
```

Note that `rbg_chr` and `rbg_fac` contain the same information, but are of different types. Discuss what differences you notice between `rbg_chr` and `rbg_fac` in each of the below cases:

1.  When we query the first few entries of each:

``` r
head(rbg_chr)
```

    ## [1] "green" "blue"  "green" "red"   "green" "blue"

``` r
head(rbg_fac)
```

    ## [1] green blue  green red   green blue 
    ## Levels: blue green pink red

1.  When we compare the size of each in the memory:

``` r
sprintf("Size as characters: %s. Size as factor: %s",
object.size(rbg_chr), object.size(rbg_fac))
```

    ## [1] "Size as characters: 16184. Size as factor: 8624"

1.  When we ask for counts within each category:

``` r
table(rbg_chr)
```

    ## rbg_chr
    ##  blue green   red 
    ##   591   683   726

``` r
table(rbg_fac)
```

    ## rbg_fac
    ##  blue green  pink   red 
    ##   591   683     0   726

1.  when we try to replace an entry with something other than 'red', 'blue' and 'green':

``` r
rbg_chr[3] <- "yellow" # replaces the 3rd entry in `rbg_chr` with 'yellow'
rbg_fac[3] <- "yellow" # throws a warning, replaces the 3rd entry with NA
```

1.  Each category in a categorical column (formatted as `factor`) is called a **factor level**. We can look at factor levels using the `levels` function:

``` r
levels(rbg_fac)
```

    ## [1] "blue"  "green" "pink"  "red"

We can relabel the factor levels directly with `levels`. Change the levels of `rbg_fac` so that the labels start with capital letters.

1.  We can add new factor levels to the existing ones. Add "Yellow" as a new level for `rbg_fac`.

2.  Once new factor levels have been created, we can have entries which match the new level. Change the third entry of `rbg_fac` to now be "Yellow".

3.  Finally, we need to recreate the `factor` column if we want to drop a particular level or change the order of the levels.

``` r
table(rbg_chr) # what we see in the orignal `character` column
```

    ## rbg_chr
    ##   blue  green    red yellow 
    ##    591    682    726      1

If we don't provide the `factor` with levels (through the `levels` argument), we create a `factor` by scanning the data to find all the levels and sort the levels alphabetically.

``` r
rbg_fac <- factor(rbg_chr)
table(rbg_fac) # the levels are just whatever was present in `rbg_chr`
```

    ## rbg_fac
    ##   blue  green    red yellow 
    ##    591    682    726      1

We can overwrite that by explicitly passing factor levels to the `factor` function, in the order that we wish them to be. Recreate `rbg_fac` by passing `rbg_chr` `factor` function, but this time specify only "red", "green" and "blue" as the levels. Run `table` on both `rbg_chr` and `rbg_fac`. What differences do you see?

1.  What benefits do you see in being able to overwrite factor levels? Specifically, what could be useful about adding new factor levels? Removing certain existing factor levels? Reordering factor levels?

### Solutions

1.  We see quotes around `rbg_chr` but no quotes for `rbg_fac` and factor levels at the bottom.

``` r
head(rbg_chr) # we see quotes
```

    ## [1] "green"  "blue"   "yellow" "red"    "green"  "blue"

``` r
head(rbg_fac) # we don't see quotes and we see the factor levels at the bottom
```

    ## [1] green  blue   yellow red    green  blue  
    ## Levels: blue green red yellow

1.  A `factor` column tends to take up less space than `character` column, the more so when the strings in the `character` column are longer. This is because a `factor` column stores the information as integers under the hood, with a mapping from each integer to the string it represents.

``` r
sprintf("Size as characters: %s. Size as factor: %s",
object.size(rbg_chr), object.size(rbg_fac))
```

    ## [1] "Size as characters: 16232. Size as factor: 8624"

1.  

``` r
table(rbg_chr)
```

    ## rbg_chr
    ##   blue  green    red yellow 
    ##    591    682    726      1

``` r
table(rbg_fac) # we can see a count of 0 for 'pink', becuase it's one of the factor levels
```

    ## rbg_fac
    ##   blue  green    red yellow 
    ##    591    682    726      1

1.  Changing an entry in a `factor` column to a values other than one of its acceptable levels will result in an NA. Notice that this happens without any warnings.

``` r
head(rbg_chr) # the 3rd entry changed to 'yellow'
```

    ## [1] "green"  "blue"   "yellow" "red"    "green"  "blue"

``` r
head(rbg_fac) # we could not change the 3rd entry to 'yellow' because it's not one of the factor levels
```

    ## [1] green  blue   yellow red    green  blue  
    ## Levels: blue green red yellow

1.  We simply re-assign the factor levels, but we must be careful to provide the new levels **in the same order** as the old ones.

``` r
levels(rbg_fac) <- c('Blue', 'Green', 'Pink', 'Red') # we capitalize the first letters
head(rbg_fac)
```

    ## [1] Green Blue  Red   Pink  Green Blue 
    ## Levels: Blue Green Pink Red

1.  We simply append "Yellow" to the old factor levels and assign this as the new factor levels.

``` r
levels(rbg_fac) <- c(levels(rbg_fac), "Yellow") # we add 'Yellow' as a new factor level
table(rbg_fac) # even though the data has no 'Yellow' entries, it's an acceptable value
```

    ## rbg_fac
    ##   Blue  Green   Pink    Red Yellow 
    ##    591    682    726      1      0

1.  Since "Yellow" is one of the levels now, we can change any entry to "Yellow" and we won't get an NA anymore.

``` r
rbg_fac[3] <- "Yellow" # does not throw a warning anymore
head(rbg_fac) # now the data has one 'Yellow' entry
```

    ## [1] Green  Blue   Yellow Pink   Green  Blue  
    ## Levels: Blue Green Pink Red Yellow

1.  We use the `levels` argument in the `factor` function. Since "yellow" was one of the entries in `rgb_chr` and we are not specifying "yellow" as one of the factor levels we want, it will be turned into an NA.

``` r
table(rbg_chr)
```

    ## rbg_chr
    ##   blue  green    red yellow 
    ##    591    682    726      1

``` r
rbg_fac <- factor(rbg_chr, levels = c('red', 'green', 'blue')) # create a `factor`, with only the levels provided, in the order provided
table(rbg_fac) # notice how 'yellow' has disappeared
```

    ## rbg_fac
    ##   red green  blue 
    ##   726   682   591

``` r
table(rbg_fac, useNA = "ifany") # 'yellow' was turned into an NA
```

    ## rbg_fac
    ##   red green  blue  <NA> 
    ##   726   682   591     1

1.  There are three important advantages to providing factor levels:

<!-- -->

1.  We can reorder the levels to any order we want (instead of having them alphabetically ordered). This way related levels can appear next to each other in summaries and plots.
2.  The factor levels don't have to be limited to what's in the data: we can provide additional levels that are not part of the data if we expect them to be part of future data. This way levels that are not in the data can still be represented in summaries and plots.
3.  Factor levels that are in the data, but not relevant to the analysis can be ignored (replaced with NAs) by not including them in `levels`. **Note that doing so results in information loss if we overwrite the original column.**

Being more efficient
--------------------

Before we move to the next exciting section about feature creation, we need to take a quick step back and revisit what we've so far done with an eye toward doing it more efficiently and in fewer steps. Often when doing exploratory data analysis we don't know much about the data ahead of time and need to learn as we go. But once we have the basics down, we can find shortcuts for some of the data-processing jobs. This is especially helpful if we intend to use the data to generate regular reports or somehow in a production environment. Therefore, in this section, we go back to the original CSV file and load it into R and redo all the data-cleaning to bring the data to where we left it off in the last section. But as you will see, we take a slightly different approach to do it.

Our approach in the last few sections was to load the data, and process it by "cleaning" each column. But some of the steps we took could have been taken at the time we loaded the data. We sometime refer to this as **pre-processing**. Pre-processing can speed up reading the data and allow us to skip certain steps. It is useful to read data as we did in section 1 for the sake of exploring it, but in a production environment where efficiency matters these small steps can go a long way in optimizing the workflow.

We are now going to read the CSV file again, but add a few additional steps so we can tell it which type each column needs to have (we can use `col_skip()` when we wish the column dropped) and the name we wish to give to each column. We store the column types and names in an object called `col_types` for ease of access.

``` r
col_types <- cols(
pickup_datetime       = col_datetime(format = ""),
dropoff_datetime      = col_datetime(format = ""),
passenger_count       = col_integer(),
trip_distance         = col_number(),
pickup_longitude      = col_number(),
pickup_latitude       = col_number(),
rate_code_id          = col_factor(levels = 1:6),
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

st <- Sys.time()
nyc_taxi <- bind_rows(lapply(1:6, read_each_month, progress = FALSE, col_names = names(col_types$cols), col_types = col_types, skip = 1))
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

    ## Time difference of 28.4 secs

Reading the data the way we did above means we can now skip some steps, such as factor conversions, but we have still have some work left before we get the data to where it was when we left it in the last section.

Before we do so, let's quickly review the two ways we learned to both query and transform data: We can query and transform data using a direct approach, or we can do so using functions such as `subset` and `transform`. The notation for the latter is cleaner and easier to follow. The two different approaches are shown in the table below. Additionally, we now introduce a third way performing the above two tasks: by using the popular `dplyr` package. `dplyr` has a host of functions for querying, processing, and summarizing data. We learn more about its querying and processing capabilities in this section and the next, and about how to summarize data with `dplyr` in the section about data summaries.

| task | direct approach | using `base` functions | using `dplyr` functions | |----------------|----------------------------------|--------------------------- -------------------|--------------------------------------| | query data | `data[data$x > 10, c('x', 'y')]` | `subset(data, x > 10, select = c('x', 'y'))` | `select(filter(data, x > 10), x, y)` | | transform data | `data$z <- data$x + data$y` | `transform(data, z = x + y)` | `mutate(data, z = x + y)` |

As we can see in the above table, `dplyr` has two functions called `mutate` and `filter`, and in notation they mirror `transform` and `subset` respectively. The one difference is that `subset` has an argument called `select` for selecting specific columns, whereas `dplyr` has a function called `select` for doing so (and the column names we pass are unquoted).

We cover more of `dplyr` in the next two sections to give you a chance to get comfortable with the `dplyr` functions and their notation, and it's in section 6 that we really gain an appreciation for `dplyr` and its simple notation for creating complicated data pipelines.

In this section, we use `dplyr` to redo all the transformations to clean the data. This will essentially consist of using `mutate` instead of `transform`. Beyond simply changing function names, `dplyr` functions are generally more efficient too.

Here's what remains for us to do:

1.  Replace the unusual geographical coordinates for pick-up and drop-off with NAs
2.  Assign the proper labels to the factor levels and drop any unnecessary factor levels (in the case of `payment_type`)

``` r
library(lubridate)
library(dplyr)
nyc_taxi <- mutate(nyc_taxi,
  pickup_longitude = ifelse(pickup_longitude < -75 | pickup_longitude > -73, NA, pickup_longitude),
  dropoff_longitude = ifelse(dropoff_longitude < -75 | dropoff_longitude > -73, NA, dropoff_longitude),
  pickup_latitude = ifelse(pickup_latitude < 38 | pickup_latitude > 41, NA, pickup_latitude),
  dropoff_latitude = ifelse(dropoff_latitude < 38 | dropoff_latitude > 41, NA, dropoff_latitude)
  )
```

As for the factor columns: firstly, `rate_code_id` is a factor now, but we still need to assign the proper labels it.

``` r
levels(nyc_taxi$rate_code_id) <- c('standard', 'JFK', 'Newark', 'Nassau or Westchester', 'negotiated', 'group ride', 'n/a')
```

Secondly, `payment_type` is also a factor, but with all six levels, so we need to "refactor" it so we can only keep the top two.

``` r
table(nyc_taxi$payment_type, useNA = "ifany") # we can see all different payment types
```

    ## 
    ##       1       2       3       4    <NA> 
    ## 3982658 1986124   23153    8063       2

``` r
nyc_taxi <- mutate(nyc_taxi, payment_type = factor(payment_type, levels = 1:2, labels = c('card', 'cash')))
table(nyc_taxi$payment_type, useNA = "ifany") # other levels turned into NAs
```

    ## 
    ##    card    cash    <NA> 
    ## 3982658 1986124   31218

We now have the data to where it was when we left it at the end of the previous section. In the next section, we work on adding new features (columns) to the data.

### Exercises

A useful question we might want to ask is the following: Are longitude and latitude mostly missing as pairs? In other words, is it generally the case that when longitude is missing, so is latitude and vice versa?

Once missing values are formatted as NAs, we use the `is.na` function to determine what's an NA.

``` r
is.na(c(2, 4, NA, -1, 5, NA))
```

    ## [1] FALSE FALSE  TRUE FALSE FALSE  TRUE

Combine `is.na` and `table` to answer the following question:

1.  How many of the `pickup_longitude` values are NAs? (This was also answered when we ran `summary`.)

2.  How many times are `pickup_longitude` and `pickup_latitude` missing together vs separately?

3.  Of the times when the pair `pickup_longitude` and `pickup_latitude` are missing, how many times is the pair `dropoff_longitude` and `dropoff_latitude` also missing?

### Solutions

1.  We use `is.na` inside `table`.

``` r
table(is.na(nyc_taxi$pickup_longitude))
```

    ## 
    ##   FALSE    TRUE 
    ## 5914216   85784

1.  We can combine both statements using `&`.

``` r
table(is.na(nyc_taxi$pickup_longitude) & is.na(nyc_taxi$pickup_latitude))
```

    ## 
    ##   FALSE    TRUE 
    ## 5914281   85719

We can also separate the two statements and pass them as separate arguments to `table`. Doing so gives us a **two-way table** with a little more information.

``` r
table(is.na(nyc_taxi$pickup_longitude), is.na(nyc_taxi$pickup_latitude)) # better solution to (2)
```

    ##        
    ##           FALSE    TRUE
    ##   FALSE 5913952     264
    ##   TRUE       65   85719

1.  Providing n arguments to `table` gives us an n-way table, which is an `array` object. When n &gt; 3 it gets confusing to look at it, so here we can use `&` to simplify things.

``` r
with(nyc_taxi,
  table(is.na(pickup_longitude) & is.na(pickup_latitude), is.na(dropoff_longitude) & is.na(dropoff_latitude))
)
```

    ##        
    ##           FALSE    TRUE
    ##   FALSE 5905405    8876
    ##   TRUE    14019   71700
