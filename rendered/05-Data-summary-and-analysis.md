Data summary and analysis
================
Seth Mottaghinejad
2017-02-08

Let's recap where we are in the process:

1.  load all the data (and combine them if necessary)
2.  inspect the data in preparation cleaning it
3.  clean the data in preparation for analysis
4.  add any interesting features or columns as far as they pertain to the analysis
5.  **find ways to analyze or summarize the data and report your findings**

Of course in practice a workflow is not clean-cut the way we have it here, and it tends to be circular in that finding out certain quirks about the data forces us to go back and make certain changes to the data-cleaning process or add other features and so on.

We now have a data set that's more or less ready for analysis. In the next section we go over ways we can summarize the data and produce plots and tables. Let's run `str(nyc_taxi)` and `head(nyc_taxi)` again to review all the work we did so far.

``` r
str(nyc_taxi)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    6000000 obs. of  25 variables:
    ##  $ pickup_datetime      : POSIXct, format: "2016-06-21 21:33:52" "2016-06-08 09:52:19" ...
    ##  $ dropoff_datetime     : POSIXct, format: "2016-06-21 21:34:40" "2016-06-08 10:19:55" ...
    ##  $ passenger_count      : int  5 1 1 5 3 1 1 2 1 1 ...
    ##  $ trip_distance        : num  0.4 5.2 2.1 2.23 2.72 1.3 8.94 0.87 1.6 2.43 ...
    ##  $ pickup_longitude     : num  -74 -74 -74 -74 -74 ...
    ##  $ pickup_latitude      : num  40.7 40.8 40.7 40.8 40.7 ...
    ##  $ rate_code_id         : Factor w/ 7 levels "standard","JFK",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ dropoff_longitude    : num  -74 -74 -74 -74 -74 ...
    ##  $ dropoff_latitude     : num  40.7 40.8 40.7 40.8 40.7 ...
    ##  $ payment_type         : Factor w/ 2 levels "card","cash": 1 2 1 1 1 2 1 1 2 2 ...
    ##  $ fare_amount          : num  3 21.5 9 8 17 7.5 30.5 5 9.5 10.5 ...
    ##  $ extra                : num  0.5 0 0.5 0.5 0.5 1 0 0.5 0 0.5 ...
    ##  $ mta_tax              : num  0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 ...
    ##  $ tip_amount           : num  0.86 NA 1.5 2.79 3.66 2.5 7.37 1.7 0.5 NA ...
    ##  $ tolls_amount         : num  0 0 0 0 0 0 5.54 0 0 0 ...
    ##  $ improvement_surcharge: num  0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 ...
    ##  $ total_amount         : num  5.16 22.3 11.8 12.09 21.96 ...
    ##  $ pickup_hour          : Factor w/ 7 levels "1AM-5AM","5AM-9AM",..: 6 2 7 6 7 4 4 1 3 6 ...
    ##  $ pickup_dow           : Factor w/ 7 levels "Sun","Mon","Tue",..: 3 4 3 1 6 3 1 6 7 4 ...
    ##  $ dropoff_hour         : Factor w/ 7 levels "1AM-5AM","5AM-9AM",..: 6 3 7 6 7 4 4 1 4 6 ...
    ##  $ dropoff_dow          : Factor w/ 7 levels "Sun","Mon","Tue",..: 3 4 3 1 7 3 1 6 7 4 ...
    ##  $ trip_duration        : int  48 1656 463 341 1493 514 1709 225 706 755 ...
    ##  $ pickup_nhood         : Factor w/ 28 levels "West Village",..: 7 24 21 24 1 5 11 27 27 5 ...
    ##  $ dropoff_nhood        : Factor w/ 28 levels "West Village",..: 5 27 NA 4 21 1 NA 11 24 17 ...
    ##  $ tip_percent          : int  22 NA 14 25 17 25 19 25 5 NA ...

``` r
head(nyc_taxi, 3)
```

We divide this chapter into three section:

1.  **Overview of some important statistical summary functions:** This is by no means a comprehensive glossary of statistical functions, but rather a sampling of the important ones and how to use them, how to modify them, and some common patterns among them.
2.  **Data summary with `base` R tools:** The `base` R tools for summarizing data are a bit more tedious and some have a different notation or way of passing arguments, but they are also widely used and they can be very efficient if used right.
3.  **Data summary with `dplyr`:** `dplyr` offers a consistent and popular notation for processing and summarizing data, and one worth learning on top of `base` R.

To reiterate, statistical summary functions which we cover in section 1 can be used in either of the above cases, but what's different is the way we query the data using those functions. For the latter, we will review two (mostly alternative) ways: one using `base` functions in section 2 and one using the `dplyr` library in section 3.

Summary functions
-----------------

We already learned of one all-encompassing summary function, namely `summary`:

``` r
summary(nyc_taxi) # summary of the whole data
```

    ##  pickup_datetime               dropoff_datetime             
    ##  Min.   :2016-01-01 00:00:00   Min.   :1996-06-20 16:23:24  
    ##  1st Qu.:2016-02-15 15:13:43   1st Qu.:2016-02-15 15:28:34  
    ##  Median :2016-03-31 23:59:59   Median :2016-04-01 00:14:49  
    ##  Mean   :2016-03-31 22:26:38   Mean   :2016-03-31 22:40:51  
    ##  3rd Qu.:2016-05-15 21:27:04   3rd Qu.:2016-05-15 21:43:05  
    ##  Max.   :2016-06-30 23:59:56   Max.   :2016-07-01 22:38:46  
    ##                                                             
    ##  passenger_count trip_distance     pickup_longitude pickup_latitude
    ##  Min.   :0.00    Min.   :      0   Min.   :-75      Min.   :38     
    ##  1st Qu.:1.00    1st Qu.:      1   1st Qu.:-74      1st Qu.:41     
    ##  Median :1.00    Median :      2   Median :-74      Median :41     
    ##  Mean   :1.66    Mean   :      4   Mean   :-74      Mean   :41     
    ##  3rd Qu.:2.00    3rd Qu.:      3   3rd Qu.:-74      3rd Qu.:41     
    ##  Max.   :9.00    Max.   :1674368   Max.   :-73      Max.   :41     
    ##                                    NA's   :85784    NA's   :85983  
    ##                 rate_code_id     dropoff_longitude dropoff_latitude
    ##  standard             :5839179   Min.   :-75       Min.   :38      
    ##  JFK                  : 128092   1st Qu.:-74       1st Qu.:41      
    ##  negotiated           :  18253   Median :-74       Median :41      
    ##  Newark               :  10939   Mean   :-74       Mean   :41      
    ##  Nassau or Westchester:   2716   3rd Qu.:-74       3rd Qu.:41      
    ##  (Other)              :     54   Max.   :-73       Max.   :41      
    ##  NA's                 :    767   NA's   :80650     NA's   :81540   
    ##  payment_type    fare_amount         extra        mta_tax    
    ##  card:3982658   Min.   :  -450   Min.   :-36   Min.   :-2.7  
    ##  cash:1986124   1st Qu.:     6   1st Qu.:  0   1st Qu.: 0.5  
    ##  NA's:  31218   Median :    10   Median :  0   Median : 0.5  
    ##                 Mean   :    13   Mean   :  0   Mean   : 0.5  
    ##                 3rd Qu.:    14   3rd Qu.:  0   3rd Qu.: 0.5  
    ##                 Max.   :628545   Max.   :636   Max.   :80.5  
    ##                                                              
    ##    tip_amount      tolls_amount improvement_surcharge  total_amount   
    ##  Min.   :-64      Min.   :-12   Min.   :-0.30         Min.   :  -451  
    ##  1st Qu.:  1      1st Qu.:  0   1st Qu.: 0.30         1st Qu.:     9  
    ##  Median :  2      Median :  0   Median : 0.30         Median :    12  
    ##  Mean   :  2      Mean   :  0   Mean   : 0.30         Mean   :    16  
    ##  3rd Qu.:  3      3rd Qu.:  0   3rd Qu.: 0.30         3rd Qu.:    18  
    ##  Max.   :844      Max.   :906   Max.   : 0.76         Max.   :629034  
    ##  NA's   :832696                                                       
    ##    pickup_hour      pickup_dow     dropoff_hour     dropoff_dow 
    ##  1AM-5AM : 329006   Sun:800938   1AM-5AM : 342428   Sun:808101  
    ##  5AM-9AM : 918307   Mon:772497   5AM-9AM : 867447   Mon:772490  
    ##  9AM-12PM: 844536   Tue:834303   9AM-12PM: 838545   Tue:833377  
    ##  12PM-4PM:1163923   Wed:863102   12PM-4PM:1166009   Wed:861748  
    ##  4PM-6PM : 688718   Thu:900046   4PM-6PM : 666898   Thu:896975  
    ##  6PM-10PM:1395406   Fri:922501   6PM-10PM:1414732   Fri:920326  
    ##  10PM-1AM: 660104   Sat:906613   10PM-1AM: 703941   Sat:906983  
    ##  trip_duration                 pickup_nhood             dropoff_nhood    
    ##  Min.   :-631147949   Midtown        : 972293   Midtown        : 914279  
    ##  1st Qu.:       395   Upper East Side: 815312   Upper East Side: 772333  
    ##  Median :       661   Upper West Side: 494749   Upper West Side: 489991  
    ##  Mean   :       853   Gramercy       : 466436   Gramercy       : 428740  
    ##  3rd Qu.:      1076   Chelsea        : 397915   Chelsea        : 358347  
    ##  Max.   :  11122910   (Other)        :2296334   (Other)        :2252434  
    ##                       NA's           : 556961   NA's           : 783876  
    ##   tip_percent    
    ##  Min.   :   -1   
    ##  1st Qu.:   14   
    ##  Median :   18   
    ##  Mean   :   17   
    ##  3rd Qu.:   20   
    ##  Max.   :45100   
    ##  NA's   :833023

We can use `summary` to run a sanity check on the data and find ways that the data might need to be cleaned in preparation for analysis, but we are now interested in individual summaries. For example, here's how we can find the average fare amount for the whole data.

``` r
mean(nyc_taxi$fare_amount) # the average of `fare_amount`
```

    ## [1] 13

By specifying `trim = .10` we can get a 10 percent trimmed average, i.e. the average after throwing out the top and bottom 10 percent of the data:

``` r
mean(nyc_taxi$fare_amount, trim = .10) # trimmed mean
```

    ## [1] 10.7

By default, the `mean` function will return NA if there is any NA in the data, but we can overwrite that with `na.rm = TRUE`. This same argument shows up in almost all the statistical functions we encounter in this section.

``` r
mean(nyc_taxi$trip_duration, na.rm = TRUE) # removes NAs before computing the average
```

    ## [1] 853

We can use `weighted.mean` to find a weighted average. The weights are specified as the second argument, and if we fail to specify anything for weights, we just get a simple average.

``` r
weighted.mean(nyc_taxi$tip_percent, nyc_taxi$trip_distance, na.rm = TRUE) # weighted average
```

    ## [1] 16

The `sd` function returns the standard deviation of the data, which is the same as returning the square root of its variance.

``` r
sd(nyc_taxi$trip_duration, na.rm = TRUE) # standard deviation
```

    ## [1] 257845

``` r
sqrt(var(nyc_taxi$trip_duration, na.rm = TRUE)) # standard deviation == square root of variance
```

    ## [1] 257845

We can use `range` to get the minimum and maximum of the data at once, or use `min` and `max` individually.

``` r
range(nyc_taxi$trip_duration, na.rm = TRUE) # minimum and maximum
```

    ## [1] -631147949   11122910

``` r
c(min(nyc_taxi$trip_duration, na.rm = TRUE), max(nyc_taxi$trip_duration, na.rm = TRUE))
```

    ## [1] -631147949   11122910

We can use `median` to return the median of the data.

``` r
median(nyc_taxi$trip_duration, na.rm = TRUE) # median
```

    ## [1] 661

The `quantile` function is used to get any percentile of the data, where the percentile is specified by the `probs` argument. For example, letting `probs = .5` returns the median.

``` r
quantile(nyc_taxi$trip_duration, probs = .5, na.rm = TRUE) # median == 50th percentile
```

    ## 50% 
    ## 661

We can specify a vector for `probs` to get multiple percentiles all at once. For example setting `probs = c(.25, .75)` returns the 25th and 75th percentiles.

``` r
quantile(nyc_taxi$trip_duration, probs = c(.25, .75), na.rm = TRUE) # IQR == difference b/w 75th and 25th percentiles
```

    ##  25%  75% 
    ##  395 1076

The difference between the 25th and 75th percentiles is called the inter-quartile range, which we can also get using the `IQR` function.

``` r
IQR(nyc_taxi$trip_duration, na.rm = TRUE) # interquartile range
```

    ## [1] 681

Let's look at a common bivariate summary statistic for numeric data: correlation.

``` r
cor(nyc_taxi$trip_distance, nyc_taxi$trip_duration, use = "complete.obs")
```

    ## [1] -0.00000114

We can use `mothod` to switch from Pearson's correlation to Spearman rank correlation.

``` r
cor(nyc_taxi$trip_distance, nyc_taxi$trip_duration, use = "complete.obs", method = "spearman")
```

    ## [1] 0.839

Why does the Spearman correlation coefficient takes so much longer to compute?

So far we've examined functions for summarizing numeric data. Let's now shift our attention to categorical data. We already saw that we can use `table` to get counts for each level of a `factor` column.

``` r
table(nyc_taxi$pickup_nhood) # one-way table
```

    ## 
    ##        West Village        East Village        Battery Park 
    ##              140332              204170               55599 
    ##       Carnegie Hill            Gramercy                Soho 
    ##               69672              466436              119095 
    ##         Murray Hill        Little Italy        Central Park 
    ##              200315               50010               80785 
    ##   Greenwich Village             Midtown Morningside Heights 
    ##              270512              972293               28971 
    ##              Harlem    Hamilton Heights             Tribeca 
    ##               30857               11817               97612 
    ##   North Sutton Area     Upper East Side  Financial District 
    ##               59162              815312              126715 
    ##              Inwood             Chelsea     Lower East Side 
    ##                 619              397915              139292 
    ##           Chinatown  Washington Heights     Upper West Side 
    ##               18155                7712              494749 
    ##             Clinton           Yorkville    Garment District 
    ##              177426               39669              349100 
    ##         East Harlem 
    ##               18737

When we pass more than one column to `table`, we get counts for each *combination* of the factor levels. For example, with two columns we get counts for each combination of the levels of the first factor and the second factor. In other words, we get a two-way table.

``` r
two_way <- with(nyc_taxi, table(pickup_nhood, dropoff_nhood)) # two-way table: an R `matrix`
two_way[1:5, 1:5]
```

    ##                dropoff_nhood
    ## pickup_nhood    West Village East Village Battery Park Carnegie Hill
    ##   West Village          7232         6407         3059           390
    ##   East Village          6119        17738         1326           393
    ##   Battery Park          2865         1243         1748           141
    ##   Carnegie Hill          296          273          229          2749
    ##   Gramercy             11348        28705         3936          2122
    ##                dropoff_nhood
    ## pickup_nhood    Gramercy
    ##   West Village     10077
    ##   East Village     27860
    ##   Battery Park      2837
    ##   Carnegie Hill     1565
    ##   Gramercy         57703

What about a three-way table? A three-way table (or n-way table where n is an integer) is represented in R by an object we call an `array`. A vector is a one- dimensional array, a matrix a two-dimensional array, and a three-way table is a kind of three-dimensional array.

What about a three-way table? A three-way table (or n-way table where n is an integer) is represented in R by an object we call an `array`. A vector is a one- dimensional array, a matrix a two-dimensional array, and a three-way table is a kind of three-dimensional array.

``` r
arr_3d <- with(nyc_taxi, table(pickup_dow, pickup_hour, payment_type)) # a three-way table, an R 3D `array`
arr_3d
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun   59674   38043    75471   107598   57482    96287    81624
    ##        Mon   15034   99308    68270    96841   65379   127675    36726
    ##        Tue   14154  112848    76431   101237   67327   148627    42899
    ##        Wed   15746  115180    78929   102631   66920   157233    51433
    ##        Thu   18162  117213    79782   105169   68080   164574    61737
    ##        Fri   29268  108982    77712   103210   66854   147828    78734
    ##        Sat   54275   48882    78994   107592   61241   128233    99129
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun   29582   25358    44865    62249   31543    49461    37121
    ##        Mon   11241   41358    40619    60618   32191    52800    20505
    ##        Tue    9660   44922    42607    60235   32168    56569    20685
    ##        Wed   10938   44174    43161    59477   31537    59092    22412
    ##        Thu   12172   44692    43035    60186   32546    62329    25920
    ##        Fri   18567   43319    43707    62022   34143    68639    34471
    ##        Sat   26939   30345    47302    68499   37802    69633    42708

Let's see how we query a 3-dimensional `array`: Because we have a 3-dimensional array, we need to index it across three different dimensions:

``` r
arr_3d[3, 2, 2] # give me the 3rd row, 2nd column, 2nd 'page'
```

    ## [1] 44922

Just as with a `data.frame`, leaving out the index for one of the dimensions returns all the values for that dimension.

``` r
arr_3d[ , , 2]
```

    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun   29582   25358    44865    62249   31543    49461    37121
    ##        Mon   11241   41358    40619    60618   32191    52800    20505
    ##        Tue    9660   44922    42607    60235   32168    56569    20685
    ##        Wed   10938   44174    43161    59477   31537    59092    22412
    ##        Thu   12172   44692    43035    60186   32546    62329    25920
    ##        Fri   18567   43319    43707    62022   34143    68639    34471
    ##        Sat   26939   30345    47302    68499   37802    69633    42708

We can use the names of the dimensions instead of their numeric index:

``` r
arr_3d['Tue', '5AM-9AM', 'cash']
```

    ## [1] 44922

We can turn the `array` representation into a `data.frame` representation:

``` r
df_arr_3d <- as.data.frame(arr_3d) # same information, formatted as data frame
head(df_arr_3d)
```

    ##   pickup_dow pickup_hour payment_type  Freq
    ## 1        Sun     1AM-5AM         card 59674
    ## 2        Mon     1AM-5AM         card 15034
    ## 3        Tue     1AM-5AM         card 14154
    ## 4        Wed     1AM-5AM         card 15746
    ## 5        Thu     1AM-5AM         card 18162
    ## 6        Fri     1AM-5AM         card 29268

We can subset the `data.frame` using the `subset` function:

``` r
subset(df_arr_3d, pickup_dow == 'Tue' & pickup_hour == '5AM-9AM' & payment_type == 'cash')
```

    ##    pickup_dow pickup_hour payment_type  Freq
    ## 59        Tue     5AM-9AM         cash 44922

Notice how the `array` notation is more terse, but not as readable (because we need to remember the order of the dimensions).

We can use `apply` to get aggregates of a multidimensional array across some dimension(s). The second argument to `apply` is used to specify which dimension(s) we are aggregating over.

``` r
apply(arr_3d, 2, sum) # because `pickup_hour` is the second dimension, we sum over `pickup_hour`
```

    ##  1AM-5AM  5AM-9AM 9AM-12PM 12PM-4PM  4PM-6PM 6PM-10PM 10PM-1AM 
    ##   325412   914624   840885  1157564   685213  1388980   656104

Once again, when the dimensions have names it is better to use the names instead of the numeric index.

``` r
apply(arr_3d, "pickup_hour", sum) # same as above, but more readable notation
```

    ##  1AM-5AM  5AM-9AM 9AM-12PM 12PM-4PM  4PM-6PM 6PM-10PM 10PM-1AM 
    ##   325412   914624   840885  1157564   685213  1388980   656104

So in the above example, we used apply to collapse a 3D `array` into a 2D `array` by summing across the values in the second dimension (the dimension representing pick-up hour).

We can use `prop.table` to turn the counts returned by `table` into proportions. The `prop.table` function has a second argument. When we leave it out, we get proportions for the grand total of the table.

``` r
prop.table(arr_3d) # as a proportion of the grand total
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun 0.01000 0.00637  0.01264  0.01803 0.00963  0.01613  0.01368
    ##        Mon 0.00252 0.01664  0.01144  0.01622 0.01095  0.02139  0.00615
    ##        Tue 0.00237 0.01891  0.01281  0.01696 0.01128  0.02490  0.00719
    ##        Wed 0.00264 0.01930  0.01322  0.01719 0.01121  0.02634  0.00862
    ##        Thu 0.00304 0.01964  0.01337  0.01762 0.01141  0.02757  0.01034
    ##        Fri 0.00490 0.01826  0.01302  0.01729 0.01120  0.02477  0.01319
    ##        Sat 0.00909 0.00819  0.01323  0.01803 0.01026  0.02148  0.01661
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun 0.00496 0.00425  0.00752  0.01043 0.00528  0.00829  0.00622
    ##        Mon 0.00188 0.00693  0.00681  0.01016 0.00539  0.00885  0.00344
    ##        Tue 0.00162 0.00753  0.00714  0.01009 0.00539  0.00948  0.00347
    ##        Wed 0.00183 0.00740  0.00723  0.00996 0.00528  0.00990  0.00375
    ##        Thu 0.00204 0.00749  0.00721  0.01008 0.00545  0.01044  0.00434
    ##        Fri 0.00311 0.00726  0.00732  0.01039 0.00572  0.01150  0.00578
    ##        Sat 0.00451 0.00508  0.00792  0.01148 0.00633  0.01167  0.00716

For proportions out of marginal totals, we provide the second argument to `prop.table`. For example, specifying 1 as the second argument gives us proportions out of "row" totals. Recall that in a 3d object, a "row" is a 2D object, for example `arr_3d[1, , ]` is the first "row", `arr3d[2, , ]` is the second "row" and so on.

``` r
prop.table(arr_3d, 1) # as a proportion of 'row' totals, or marginal totals for the first dimension
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun  0.0749  0.0478   0.0948   0.1351  0.0722   0.1209   0.1025
    ##        Mon  0.0196  0.1292   0.0888   0.1260  0.0851   0.1661   0.0478
    ##        Tue  0.0170  0.1359   0.0920   0.1219  0.0811   0.1790   0.0517
    ##        Wed  0.0183  0.1341   0.0919   0.1195  0.0779   0.1831   0.0599
    ##        Thu  0.0203  0.1309   0.0891   0.1174  0.0760   0.1838   0.0689
    ##        Fri  0.0319  0.1188   0.0847   0.1125  0.0729   0.1611   0.0858
    ##        Sat  0.0602  0.0542   0.0876   0.1193  0.0679   0.1422   0.1100
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun  0.0371  0.0318   0.0563   0.0782  0.0396   0.0621   0.0466
    ##        Mon  0.0146  0.0538   0.0529   0.0789  0.0419   0.0687   0.0267
    ##        Tue  0.0116  0.0541   0.0513   0.0725  0.0387   0.0681   0.0249
    ##        Wed  0.0127  0.0514   0.0503   0.0693  0.0367   0.0688   0.0261
    ##        Thu  0.0136  0.0499   0.0481   0.0672  0.0363   0.0696   0.0289
    ##        Fri  0.0202  0.0472   0.0476   0.0676  0.0372   0.0748   0.0376
    ##        Sat  0.0299  0.0337   0.0525   0.0760  0.0419   0.0772   0.0474

We can confirm this by using `apply` to run the `sum` function across the first dimension to make sure that they all add up to 1.

``` r
apply(prop.table(arr_3d, 1), 1, sum) # check that across rows, proportions add to 1
```

    ## Sun Mon Tue Wed Thu Fri Sat 
    ##   1   1   1   1   1   1   1

Similarly, if the second argument to `prop.table` is 2, we get proportions that add up to 1 across the values of the 2nd dimension. Since the second dimension corresponds to pick-up hour, for each pickup-hour, we get the proportion of observations that fall into each pick-up day of week and payment type combination.

``` r
prop.table(arr_3d, 2) # as a proportion of column totals
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun  0.1834  0.0416   0.0898   0.0930  0.0839   0.0693   0.1244
    ##        Mon  0.0462  0.1086   0.0812   0.0837  0.0954   0.0919   0.0560
    ##        Tue  0.0435  0.1234   0.0909   0.0875  0.0983   0.1070   0.0654
    ##        Wed  0.0484  0.1259   0.0939   0.0887  0.0977   0.1132   0.0784
    ##        Thu  0.0558  0.1282   0.0949   0.0909  0.0994   0.1185   0.0941
    ##        Fri  0.0899  0.1192   0.0924   0.0892  0.0976   0.1064   0.1200
    ##        Sat  0.1668  0.0534   0.0939   0.0929  0.0894   0.0923   0.1511
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun  0.0909  0.0277   0.0534   0.0538  0.0460   0.0356   0.0566
    ##        Mon  0.0345  0.0452   0.0483   0.0524  0.0470   0.0380   0.0313
    ##        Tue  0.0297  0.0491   0.0507   0.0520  0.0469   0.0407   0.0315
    ##        Wed  0.0336  0.0483   0.0513   0.0514  0.0460   0.0425   0.0342
    ##        Thu  0.0374  0.0489   0.0512   0.0520  0.0475   0.0449   0.0395
    ##        Fri  0.0571  0.0474   0.0520   0.0536  0.0498   0.0494   0.0525
    ##        Sat  0.0828  0.0332   0.0563   0.0592  0.0552   0.0501   0.0651

Which once again we can double-check with `apply`:

``` r
apply(prop.table(arr_3d, 2), 2, sum) # check that across columns, proportions add to 1
```

    ##  1AM-5AM  5AM-9AM 9AM-12PM 12PM-4PM  4PM-6PM 6PM-10PM 10PM-1AM 
    ##        1        1        1        1        1        1        1

Finally, if the second argument to `prop.table` is 3, we get proportions that add up to 1 across the values of the 3rd dimension. So for each payment type, the proportions now add up to 1.

``` r
prop.table(arr_3d, 3) # as a proportion of totals across third dimension
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun 0.01498 0.00955  0.01895  0.02702 0.01443  0.02418  0.02049
    ##        Mon 0.00377 0.02494  0.01714  0.02432 0.01642  0.03206  0.00922
    ##        Tue 0.00355 0.02833  0.01919  0.02542 0.01691  0.03732  0.01077
    ##        Wed 0.00395 0.02892  0.01982  0.02577 0.01680  0.03948  0.01291
    ##        Thu 0.00456 0.02943  0.02003  0.02641 0.01709  0.04132  0.01550
    ##        Fri 0.00735 0.02736  0.01951  0.02591 0.01679  0.03712  0.01977
    ##        Sat 0.01363 0.01227  0.01983  0.02702 0.01538  0.03220  0.02489
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun 0.01489 0.01277  0.02259  0.03134 0.01588  0.02490  0.01869
    ##        Mon 0.00566 0.02082  0.02045  0.03052 0.01621  0.02658  0.01032
    ##        Tue 0.00486 0.02262  0.02145  0.03033 0.01620  0.02848  0.01041
    ##        Wed 0.00551 0.02224  0.02173  0.02995 0.01588  0.02975  0.01128
    ##        Thu 0.00613 0.02250  0.02167  0.03030 0.01639  0.03138  0.01305
    ##        Fri 0.00935 0.02181  0.02201  0.03123 0.01719  0.03456  0.01736
    ##        Sat 0.01356 0.01528  0.02382  0.03449 0.01903  0.03506  0.02150

Both `prop.table` and `apply` also accepts combinations of dimensions as the second argument. This makes them powerful tools for aggregation, as long as we're careful. For example, letting the second argument be `c(1, 2)` gives us proportions that add up to 1 for each combination of "row" and "column". So in other words, we get the percentage of card vs cash payments for each pick-up day of week and hour combination.

``` r
prop.table(arr_3d, c(1, 2)) # as a proportion of totals for each combination of 1st and 2nd dimensions
```

    ## , , payment_type = card
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun   0.669   0.600    0.627    0.633   0.646    0.661    0.687
    ##        Mon   0.572   0.706    0.627    0.615   0.670    0.707    0.642
    ##        Tue   0.594   0.715    0.642    0.627   0.677    0.724    0.675
    ##        Wed   0.590   0.723    0.646    0.633   0.680    0.727    0.696
    ##        Thu   0.599   0.724    0.650    0.636   0.677    0.725    0.704
    ##        Fri   0.612   0.716    0.640    0.625   0.662    0.683    0.695
    ##        Sat   0.668   0.617    0.625    0.611   0.618    0.648    0.699
    ## 
    ## , , payment_type = cash
    ## 
    ##           pickup_hour
    ## pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##        Sun   0.331   0.400    0.373    0.367   0.354    0.339    0.313
    ##        Mon   0.428   0.294    0.373    0.385   0.330    0.293    0.358
    ##        Tue   0.406   0.285    0.358    0.373   0.323    0.276    0.325
    ##        Wed   0.410   0.277    0.354    0.367   0.320    0.273    0.304
    ##        Thu   0.401   0.276    0.350    0.364   0.323    0.275    0.296
    ##        Fri   0.388   0.284    0.360    0.375   0.338    0.317    0.305
    ##        Sat   0.332   0.383    0.375    0.389   0.382    0.352    0.301

### Exercises

1.  The `trim` argument for the `mean` function is two-sided. Let's build a one- sided trimmed mean function, and one that uses counts instead of percentiles. Call it `mean_except_top_10`. For example `mean_except_top_10(x, 5)` will throw out the highest 5 values of `x` before computing the average. HINT: you can sort `x` using the `sort` function.

``` r
mean_except_top_10(c(1, 5, 3, 99), 1) # should return 3
```

------------------------------------------------------------------------

We just leared that the `probs` argument of `quantile` can be a vector. So instead of getting multiple quantiles separately, such as

``` r
c(quantile(nyc_taxi$trip_distance, probs = .9),
  quantile(nyc_taxi$trip_distance, probs = .6),
  quantile(nyc_taxi$trip_distance, probs = .3))
```

    ##  90%  60%  30% 
    ## 6.77 2.10 1.10

we can get them all at once by passing the percentiles we want as a single vector to `probs`:

``` r
quantile(nyc_taxi$trip_distance, probs = c(.3, .6, .9))
```

    ##  30%  60%  90% 
    ## 1.10 2.10 6.77

As it turns out, there's a considerable difference in efficiency between the first and second approach. We explore this in this exercise:

There are two important tools we can use when considering efficiency:

-   **profiling** is a helpful tool if we need to understand what a function does under the hood (good for finding bottlenecks)
-   **benchmarking** is the process of comparing multiple functions to see which is faster

Both of these tools can be slow when working with large datasets (especially the benchmarking tool), so instead we create a vector of random numbers and use that for testing (alternatively, we could use a sample of the data). We want the vector to be big enough that test result are stable (not due to chance), but small enough that they will run within a reasonable time frame.

Let's begin by profiling, for which we rely on the `profr` library:

``` r
random_vec <- rnorm(10^6) # a million random numbers generated from a standard normal distribution

library(profr)
my_test_function <- function(){
  quantile(random_vec, p = seq(0, 1, by = .01))
}
p <- profr(my_test_function())
plot(p)
```

![](rendered/images/chap05chunk39-1.png)

1.  Describe what the plot is telling us: what is the bottleneck in getting quantiles?

------------------------------------------------------------------------

Now onto benchmarking, we compare two functions: `first` and `scond`. `first` finds the 30th, 60th, and 90th percentiles of the data in one function call, but `scond` uses three separate function calls, one for each percentile. From the profiling tool, we now know that every time we compute percentiles, we need to sort the data, and that sorting the data is the most time-consuming part of the calculation. The benchmarking tool should show that `first` is three times more efficient than `scond`, because `first` sorts the data once and finds all three percentiles, whereas `scond` sorts the data three different times and finds one of the percentiles every time.

``` r
first <- function(x) quantile(x, probs = c(.3, .6, .9)) # get all percentiles at the same time
scond <- function(x) {
  c(
    quantile(x, probs = .9),
    quantile(x, probs = .6),
    quantile(x, probs = .3))
}

library(microbenchmark) # makes benchmarking easy
print(microbenchmark(
  first(random_vec), # vectorized version
  scond(random_vec), # non-vectorized
  times = 10))
```

    ## Unit: milliseconds
    ##               expr  min   lq mean median   uq   max neval
    ##  first(random_vec) 30.3 32.3 37.7   34.3 38.3  58.7    10
    ##  scond(random_vec) 44.6 57.0 68.4   62.6 64.5 149.7    10

1.  Describe what the results say? Do the runtimes bear out our intuition?

### Solutions

1.  We can sort the vector in reverse order, throw out the top n entries and then compute the average.

``` r
mean_except_top_10 <- function(x, n) {
  mean(-sort(-x)[-(1:n)], na.rm = TRUE)
}
mean_except_top_10(c(1, 5, 3, 99), 1)
```

    ## [1] 3

1.  Based on the plot we can see that the almost all of the runtime of `my_test_function` is spent on sorting the vector. Sorting is a computationally intensive process and many algorithms have been devised to sort data for that reason.

2.  We can look at the `mean` column to compare the average runtime of running `first` 10 times (recall that we set `times = 10`) to the average runtime for `scond`. We can see that `scond` is about twice as long.

Data summary in `base` R
------------------------

One of the most important sets of functions in `base` R are the `apply` family of functions: we learned about `apply` earlier, and learn about `sapply`, `lapply`, and `tapply` in this section (there are more of them, but we won't cover them all).

-   We already learned how `apply` runs a summary function across any dimension of an `array`
-   `sapply` and `lapply` allow us to apply a summary function to multiple column of the data at once using them means we can type less and avoid writing loops.
-   `tapply` is used to run a summary function on a column of the data, but group the result by other columns of the data

Say we were interested in obtained summary statistics for all the columns listed in the vector `trip_metrics`:

``` r
trip_metrics <- c('passenger_count', 'trip_distance', 'fare_amount', 'tip_amount', 'trip_duration', 'tip_percent')
```

We can use either `sapply` or `lapply` for this task. In fact, `sapply` and `lapply` have an identical syntax, but the difference is in the type output return. Let's first look at `sapply`: `sapply` generally organizes the results in a tidy format (unsually a vector or a matrix):

``` r
s_res <- sapply(nyc_taxi[ , trip_metrics], mean)
s_res
```

    ## passenger_count   trip_distance     fare_amount      tip_amount 
    ##            1.66            3.81           12.98              NA 
    ##   trip_duration     tip_percent 
    ##          852.89              NA

One of the great advantages of the `apply`-family of functions is that in addition to the statistical summary, we can pass any secondary argument the function takes to the function. Notice how we pass `na.rm = TRUE` to `sapply` hear so that we can remove missing values from the data before we compute the means.

``` r
s_res <- sapply(nyc_taxi[ , trip_metrics], mean, na.rm = TRUE)
s_res
```

    ## passenger_count   trip_distance     fare_amount      tip_amount 
    ##            1.66            3.81           12.98            2.48 
    ##   trip_duration     tip_percent 
    ##          852.89           17.37

The object `sapply` returns in this case is a vector: `mean` is a summary function that returns a single number, and `sapply` applies `mean` to multiple columns, returning a **named vector** with the means as its elements and the original column names preserved. Because `s_res` is a named vector, we can query it by name:

``` r
s_res["passenger_count"] # we can query the result object by name
```

    ## passenger_count 
    ##            1.66

Now let's see what `lapply` does: unlike `sapply`, `lapply` makes no attempt to organize the results. Instead, it always returns a `list` as its output. A `list` is a very "flexible" data type, in that anything can be "dumped" into it.

``` r
l_res <- lapply(nyc_taxi[ , trip_metrics], mean)
l_res
```

    ## $passenger_count
    ## [1] 1.66
    ## 
    ## $trip_distance
    ## [1] 3.81
    ## 
    ## $fare_amount
    ## [1] 13
    ## 
    ## $tip_amount
    ## [1] NA
    ## 
    ## $trip_duration
    ## [1] 853
    ## 
    ## $tip_percent
    ## [1] NA

In this case, we can 'flatten' the `list` with the `unlist` function to get the same result as `sapply`.

``` r
unlist(l_res) # this 'flattens' the `list` and returns what `sapply` returns
```

    ## passenger_count   trip_distance     fare_amount      tip_amount 
    ##            1.66            3.81           12.98              NA 
    ##   trip_duration     tip_percent 
    ##          852.89              NA

Querying a `list` is a bit more complicated. We use one bracket to query a `list`, but the return object is still a `list`, in other words, with a single bracket, we get a sublist.

``` r
l_res["passenger_count"] # this is still a `list`
```

    ## $passenger_count
    ## [1] 1.66

If we want to return the object itself, we use two brackets.

``` r
l_res[["passenger_count"]] # this is the average count itself
```

    ## [1] 1.66

The above distinction is not very important when all we want to do is look at the result. But when we need to perform more computations on the results we obtained, the distinction is crucial. For example, recall that both `s_res` and `l_res` store column averages for the data. Say now that we wanted to take the average for passenger count and add 1 to it, so that the count includes the driver too. With `s_res` we do the following:

``` r
s_res["passenger_count"] <- s_res["passenger_count"] + 1
s_res
```

    ## passenger_count   trip_distance     fare_amount      tip_amount 
    ##            2.66            3.81           12.98            2.48 
    ##   trip_duration     tip_percent 
    ##          852.89           17.37

With `l_res` using a single bracket fails, because `l_res["passenger_count"]` is still a `list` and we can't add 1 to a `list`.

``` r
l_res["passenger_count"] <- l_res["passenger_count"] + 1
```

    ## Error in l_res["passenger_count"] + 1: non-numeric argument to binary operator

So we need to use two brackets to perform the same operation on `l_res`.

``` r
l_res[["passenger_count"]] <- l_res[["passenger_count"]] + 1
l_res
```

    ## $passenger_count
    ## [1] 2.66
    ## 
    ## $trip_distance
    ## [1] 3.81
    ## 
    ## $fare_amount
    ## [1] 13
    ## 
    ## $tip_amount
    ## [1] NA
    ## 
    ## $trip_duration
    ## [1] 853
    ## 
    ## $tip_percent
    ## [1] NA

Let's look at our last function in the `apply` family now, namely `tapply`: We use `tapply` to apply a function to the a column, **but group the results by the values other columns.**

``` r
tapply(nyc_taxi$tip_amount, nyc_taxi$pickup_nhood, mean, trim = 0.1, na.rm = TRUE) # trimmed average tip, by pickup neighborhood
```

    ##        West Village        East Village        Battery Park 
    ##                2.00                2.03                2.65 
    ##       Carnegie Hill            Gramercy                Soho 
    ##                1.89                1.91                2.07 
    ##         Murray Hill        Little Italy        Central Park 
    ##                2.02                2.06                1.94 
    ##   Greenwich Village             Midtown Morningside Heights 
    ##                1.96                2.07                2.08 
    ##              Harlem    Hamilton Heights             Tribeca 
    ##                1.76                1.95                2.17 
    ##   North Sutton Area     Upper East Side  Financial District 
    ##                1.86                1.85                2.76 
    ##              Inwood             Chelsea     Lower East Side 
    ##                2.21                1.95                2.18 
    ##           Chinatown  Washington Heights     Upper West Side 
    ##                2.18                2.32                1.87 
    ##             Clinton           Yorkville    Garment District 
    ##                1.98                1.83                2.04 
    ##         East Harlem 
    ##                1.69

We can group the results by pickup and dropoff neighborhood pairs, by combining those two columns into one. For example, the `paste` function concatenates the pick-up and drop-off neighborhoods into a single string. The result is a flat vector with one element for each pick-up and drop-off neighborhood combination.

``` r
flat_array <- tapply(nyc_taxi$tip_amount,
paste(nyc_taxi$pickup_nhood, nyc_taxi$dropoff_nhood, sep = " to "),
mean, trim = 0.1, na.rm = TRUE)

head(flat_array)
```

    ##  Battery Park to Battery Park Battery Park to Carnegie Hill 
    ##                          1.38                          5.25 
    ##  Battery Park to Central Park       Battery Park to Chelsea 
    ##                          4.57                          2.35 
    ##     Battery Park to Chinatown       Battery Park to Clinton 
    ##                          1.87                          3.02

By putting both grouping columns in a `list` we can get an `array` (a 2D `array` or `matrix` in this case) instead of the flat vector we got earlier.

``` r
square_array <- tapply(nyc_taxi$tip_amount,
list(nyc_taxi$pickup_nhood, nyc_taxi$dropoff_nhood),
mean, trim = 0.1, na.rm = TRUE)

square_array[1:5, 1:5]
```

    ##               West Village East Village Battery Park Carnegie Hill
    ## West Village          1.14         1.92         1.80          4.00
    ## East Village          1.85         1.20         2.63          3.41
    ## Battery Park          1.83         2.84         1.38          5.25
    ## Carnegie Hill         4.33         3.72         5.00          1.06
    ## Gramercy              1.83         1.57         2.94          3.01
    ##               Gramercy
    ## West Village      1.87
    ## East Village      1.50
    ## Battery Park      3.36
    ## Carnegie Hill     3.35
    ## Gramercy          1.29

### Exercises

Let's look at two other cases of using `sapply` vs `lapply`, one involving `quantile` and one involving `unique`.

``` r
qsap1 <- sapply(nyc_taxi[ , trip_metrics], quantile, probs = c(.01, .05, .95, .99), na.rm = TRUE)
qlap1 <- lapply(nyc_taxi[ , trip_metrics], quantile, probs = c(.01, .05, .95, .99), na.rm = TRUE)
```

1.  Query `qsap1` and `qlap1` for the 5th and 95th percentiles of `trip_distance` and `trip_duration`.

Let's now try the same, but this time pass the `unique` function to both, which returns the unique values in the data for each of the columns.

``` r
qsap2 <- sapply(nyc_taxi[ , trip_metrics], unique)
qlap2 <- lapply(nyc_taxi[ , trip_metrics], unique)
```

1.  Query `qsap2` and `qlap2` to show the distinct values of `passenger_count` and `tip_percent`. Can you tell why did `sapply` and `lapply` both return lists in the second case?

2.  Use `qlap2` to find the number of unique values for each column.

### Solutions

1.  Because `qsap1` is a matrix, we can query it the same way we query any n-dimensional `array`:

``` r
qsap1[c('5%', '95%'), c('trip_distance', 'trip_duration')]
```

    ##     trip_distance trip_duration
    ## 5%            0.5           177
    ## 95%          10.5          2107

Since `qlap1` is a list with one element per each column of the data, we use two brackets to extract the percentiles for column separately. Moreover, because the percentiles themselves are stored in a named vector, we can pass the names of the percentiles we want in a single bracket to get the desired result.

``` r
qlap1[['trip_distance']][c('5%', '95%')]
```

    ##   5%  95% 
    ##  0.5 10.5

``` r
qlap1[['trip_duration']][c('5%', '95%')]
```

    ##   5%  95% 
    ##  177 2107

1.  In this case, `sapply` and `lapply` both return a `list`, simply because there is no other way for `sapply` to organize the results. We can just return the results for `passenger_count` and `tip_percent` as a sublist.

``` r
qsap2[c('passenger_count', 'tip_percent')]
```

    ## $passenger_count
    ##  [1] 5 1 3 2 6 4 0 8 7 9
    ## 
    ## $tip_percent
    ##   [1]    22    NA    14    25    17    19     5    16    18    21    20
    ##  [12]    10    35     6    11    13     7     8     0    12    15    33
    ##  [23]    24    40    30     9    26    27    28    23    29    78    36
    ##  [34]     4    32    47     1    51    88     2    37    41    46   100
    ##  [45]    99    39    34    54     3    42    59    50    84    86    38
    ##  [56]    56    44    43    45    72    57    55    71    31    63    60
    ##  [67]    66    91    94    76   400    53    69    49    70    68    62
    ##  [78]    61    81    52    64    80   350    48    58    73    67    96
    ##  [89]    85    95    83    97    92    65    77    89  2100  5300    75
    ## [100]    98    74    82   700    90   800    87   450   850    79   500
    ## [111]    93 45100   550   600   650  2150  1300  1430   900 10100  1650
    ## [122]  3180  1380  3629    -1   750  1150  2200  9284

1.  Since we have the unique values for each column stored in `qlap2`, we can just run the `length` function to count how many unique values each column has. For example, for `passenger_count` we have

``` r
length(qlap2[['passenger_count']]) # don't forget the double bracket here!
```

    ## [1] 10

But we want to do this automatically for all the columns at once. The solution is to use `sapply`. So far we've been using `sapply` and `lapply` with the dataset as input. But we can just as well feed them any random list like `qsap` and apply a function to each element of that list (as long as doing so doesn't result in an error for any of the list's elements).

``` r
sapply(qlap2, length)
```

    ## passenger_count   trip_distance     fare_amount      tip_amount 
    ##              10            4035            1524            3120 
    ##   trip_duration     tip_percent 
    ##           10806             129

The above exercise offers a glimpse of how powerful R can be and quickly and succinctly processing the basic data types, as long as we write good functions and use the `apply` family of functions to iterate through the data types. A good goal to set for yourself as an R programmer is to increase your reliance on the `apply` family of function to run your code.

Writing summary functions
-------------------------

As we use R more and more, we will see that a lot of R functions return a `list` as output (or something that is fundamentally a `list` but looks cosmetically different). In fact, as it happens a `data.frame` is also just a kind a `list`, with each element of the list corresponding to a column of the `data.frame`, and **all elements having the same length**. Why would a `data.frame` be a `list` and not a `matrix`? Because like a `vector`, a `matirx` or any `array` is **atomic**, meaning that its elements must be of the same type (usually `numeric`). Notice what happens if we try to force a vector to have one `character` element and one `numeric` one:

``` r
c("one", 1)
```

    ## [1] "one" "1"

The second element was **coerced** into the string "1". A `list` will not complain about this:

``` r
list("one", 1)
```

    ## [[1]]
    ## [1] "one"
    ## 
    ## [[2]]
    ## [1] 1

Since columns of a `data.frame` can be of different types, it makes sense that under the hood a `data.frame` is really just a `list.` We can check that a `data.frame` is a kind of list **under the hood** by using the `typeof` function instead of `class`:

``` r
class(nyc_taxi)
```

    ## [1] "tbl_df"     "tbl"        "data.frame"

``` r
typeof(nyc_taxi)
```

    ## [1] "list"

This **flexibility** is the reason functions that return lots of loosely-related results return them as a single list. This includes most functions that perform various statistical tests, such as the `lm` function.

We can also write our own summary functions and demonstrate this. In section 6.1, we focused on single summaries (such as `mean`), or multiple related ones (such as `quantile`), but now we want to write a function that combines different summaries and returns all of them at once. The trick is basically to wrap everything into a `list` and return the `list`. The function `my.summary` shown here is an example of such a function. It consists of mostly of separate but related summaries that are calculated piece-wise and then put together into a list and returned by the function.

``` r
my.summary <- function(grp_1, grp_2, resp) {
# `grp_1` and `grp_2` are `character` or `factor` columns
# `resp` is a numeric column
  mean <- mean(resp, na.rm = TRUE) # mean
  sorted_resp <- sort(resp)
  n <- length(resp)
  mean_minus_top = mean(sorted_resp[1:(n-19)], na.rm = TRUE) # average after throwing out highest 20 values
  tt_1 <- table(grp_1, grp_2) # the total count
  ptt_1 <- prop.table(tt_1, 1) # proportions for each level of the response
  ptt_2 <- prop.table(tt_1, 2) # proportions for each level of the response
  tt_2 <- tapply(resp, list(grp_1, grp_2), mean, na.rm = TRUE)
# return everything as a list:
  list(mean = mean,
  trimmed_mean = mean_minus_top,
  row_proportions = ptt_1,
  col_proportions = ptt_2,
  average_by_group = tt_2
  )
}

my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount) # test the function
```

    ## $mean
    ## [1] 2.48
    ## 
    ## $trimmed_mean
    ## [1] 2.48
    ## 
    ## $row_proportions
    ##      grp_2
    ## grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##   Sun  0.1126  0.0796   0.1509   0.2131  0.1117   0.1830   0.1491
    ##   Mon  0.0344  0.1828   0.1416   0.2049  0.1269   0.2347   0.0746
    ##   Tue  0.0289  0.1898   0.1433   0.1946  0.1199   0.2470   0.0767
    ##   Wed  0.0313  0.1853   0.1421   0.1889  0.1146   0.2517   0.0861
    ##   Thu  0.0341  0.1805   0.1370   0.1847  0.1123   0.2532   0.0980
    ##   Fri  0.0525  0.1658   0.1322   0.1802  0.1101   0.2358   0.1234
    ##   Sat  0.0905  0.0879   0.1398   0.1953  0.1098   0.2193   0.1574
    ## 
    ## $col_proportions
    ##      grp_2
    ## grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##   Sun  0.2740  0.0694   0.1431   0.1467  0.1299   0.1050   0.1810
    ##   Mon  0.0808  0.1538   0.1295   0.1360  0.1424   0.1299   0.0873
    ##   Tue  0.0732  0.1724   0.1416   0.1395  0.1452   0.1477   0.0969
    ##   Wed  0.0820  0.1742   0.1452   0.1400  0.1437   0.1557   0.1126
    ##   Thu  0.0933  0.1769   0.1461   0.1429  0.1468   0.1633   0.1336
    ##   Fri  0.1471  0.1665   0.1444   0.1428  0.1475   0.1559   0.1725
    ##   Sat  0.2495  0.0867   0.1501   0.1521  0.1446   0.1425   0.2161
    ## 
    ## $average_by_group
    ##     1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ## Sun    2.33    2.42     2.22     2.49    2.49     2.53     2.41
    ## Mon    2.93    2.42     2.51     2.56    2.47     2.51     2.72
    ## Tue    2.71    2.33     2.53     2.60    2.51     2.52     2.69
    ## Wed    2.75    2.34     2.54     2.73    2.61     2.52     2.62
    ## Thu    2.76    2.36     2.55     2.76    2.62     2.55     2.63
    ## Fri    2.71    2.36     2.47     2.65    2.53     2.42     2.54
    ## Sat    2.40    2.36     2.15     2.28    2.26     2.26     2.40

Looking at the above result, we can see that something went wrong with the trimmed mean: the trimmed mean and the mean appear to be the same, which is very unlikely. It's not obvious what the bug is. Take a moment and try find out what the problem is and propose a fix.

One thing that makes it hard to debug the function is that we do not have direct access to its **environment**. We need a way to "step inside" the function and run it line by line so we can see where the problem is. This is what `debug` is for.

``` r
debug(my.summary) # puts the function in debug mode
```

Now, anytime we run the function we leave our current "global" environment and step into the function's environment, where we have access to all the local variables in the function as we run the code line-by-line.

``` r
my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount)
```

We start at the beginning, where the only things evaluated are the function's arguments. We can press ENTER to run the next line. After running each line, we can query the object to see if it looks like it should. We can always go back to the global environment by pressing Q and ENTER. If you were unsuccessful at fixing the bug earlier, take a second stab at it now. (HINT: it has something to do with NAs.)

Once we resolve the issue, we run `undebug` so the function can now run normally.

``` r
undebug(my.summary)
```

To run `my.summary` on multiple numeric columns at once, we can use `lapply`:

``` r
res <- lapply(nyc_taxi[ , trip_metrics], my.summary, grp_1 = nyc_taxi$pickup_dow, grp_2 = nyc_taxi$pickup_hour)
```

`res` is just a nested `list` and we can 'drill into' any individual piece we want with the right query. At the first level are the column names.

``` r
res$tip_amount$col_proportions # the next level has the statistics that the function outputs.
```

    ##      grp_2
    ## grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    ##   Sun  0.2740  0.0694   0.1431   0.1467  0.1299   0.1050   0.1810
    ##   Mon  0.0808  0.1538   0.1295   0.1360  0.1424   0.1299   0.0873
    ##   Tue  0.0732  0.1724   0.1416   0.1395  0.1452   0.1477   0.0969
    ##   Wed  0.0820  0.1742   0.1452   0.1400  0.1437   0.1557   0.1126
    ##   Thu  0.0933  0.1769   0.1461   0.1429  0.1468   0.1633   0.1336
    ##   Fri  0.1471  0.1665   0.1444   0.1428  0.1475   0.1559   0.1725
    ##   Sat  0.2495  0.0867   0.1501   0.1521  0.1446   0.1425   0.2161

``` r
res$tip_amount$col_proportions["Mon", "9AM-12PM"]
```

    ## [1] 0.13

Since `res` contains a lot of summaries, it might be a good idea to save it using `save`. Any R object can be saved with `save`. This way if our R session crashes we can reload the object with the `load` function.

``` r
save(res, file = "res.RData") # save this result
rm(res) # it is now safe to delete `res` from the current session
load(file = "res.RData") # we can use `load` to reopen it anytime we need it again
file.remove(file = "res.RData") # delete the file
```

    ## [1] TRUE

### Exercises

Debug the summary function `my.summary` in the last section so that the trimmed mean returns the correct result.

HINT: Notice what `sort` does to missing values.

``` r
sort(c(5, 1, NA, NA, 2))
```

    ## [1] 1 2 5

### Solutions

This is a tricky type of "bug" because nothing in R went wrong and no error message was returned. Instead, we simply overlooked something in the code. As it turns out, when we pass a vector with missing values to `sort`, `sort` returns the sorted vector with the missing values **removed**. But if missing values are removed, then the length of the vector changes and we need to recompute it. This is a quick fix: we need to change `n <- length(resp)` in the body of the function to `n <- length(sorted_resp)`.

Data summary with `dplyr`
-------------------------

When it comes to summarizing data, we have a lot of options. We covered just a few in the last section, but there are many more functions both in `base` R and packages. We will cover `dplyr` in this section, as an example of a third-party package. What makes `dplyr` very popular is the simple and streight-farward notation for creating increasing complex data pipelines.

First let's review important functions in `dplyr`: `filter`, `mutate`, `transmute`, `group_by`, `select`, `slice`, `summarize`, `distinct`, `arrange`, `rename`, `inner_join`, `outer_join`, `left_join`. With each of the above function, we can either pass the data directly to the function or infer it from the the pipeline. Here's an example of `filter` being used in both ways. In the first case we pass the data as the first argument to `filter`.

``` r
library(dplyr)
head(filter(nyc_taxi, fare_amount > 500)) # pass data directly to the function
```

In the second case, we start a pipeline with the data, followed by the piping function `%>%`, followed by `filter` which now inherits the data from the previous step and only needs the filtering condition.

``` r
nyc_taxi %>% filter(fare_amount > 500) %>% head # infer the data from the pipeline
```

Piping is especially useful for longer pipelines. Here's an example of a query without piping.

``` r
summarize( # (3)
  group_by( # (2)
    filter(nyc_taxi, fare_amount > 500), # (1)
  payment_type),
ave_duration = mean(trip_duration), ave_distance = mean(trip_distance))
```

To understand the query, we need to work from the inside out: 1. First filter the data to show only fare amounts above $500 2. Group the resulting data by payment type 3. For each group find average trip duration and trip distance

The same query, using piping, looks like this:

``` r
nyc_taxi %>%
  filter(fare_amount > 500) %>% # (1)
  group_by(payment_type) %>% # (2)
  summarize(ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)) # (3)
```

Instead of working from the inside out, piping allows us to read the code from top to bottom. This makes it easier (1) to understand what the query does and (2) to build upon the query.

The best way to learn `dplyr` is by example. So instead of covering functions one by one, we state some interesting queries and use `dplyr` to implement them. There are obvious parallels between `dplyr` and the SQL language, but important differences exist too. We point out some of those differences along the way.

### Exercises

1.  In the following query, we want to add a forth step: Sort the results by descending average trip duration. The `dplyr` function to sort is `arrange`. For example `arrange(data, x1, desc(x2))` will sort `data` by increasing values of `x1` and decreasing values of `x2` within each value of `x1`.

Implement this forth step to both the code with and without the pipeline, both of which are shown here:

``` r
summarize( # (3)
  group_by( # (2)
    filter(nyc_taxi, fare_amount > 500), # (1)
  payment_type),
ave_duration = mean(trip_duration), ave_distance = mean(trip_distance))
```

``` r
nyc_taxi %>%
  filter(fare_amount > 500) %>% # (1)
  group_by(payment_type) %>% # (2)
  summarize(ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)) # (3)
```

The remaining exercises are questions about the data that need to be translated into a `dplyr` pipeline. The goal of the exercise is two-fold: learn to break down a question into multiple pieces and learn to translate each piece into a line in `dplyr`, which together comprise the pipeline.

1.  What are the pick-up times of the day and the days of the week with the highest average fare per mile of ride?

2.  For each pick-up neighborhood, find the number and percentage of trips that "fan out" into other neighborhoods. Sort results by pickup neighborhood and descending percentage. Limit results to top 50 percent coverage. In other words, show only the top 50 percent of destinations for each pick-up neighborhood.

3.  Are any dates missing from the data?

4.  Find the 3 consecutive days with the most total number of trips?

5.  Get the average, standard deviation, and mean absolute deviation of `trip_distance` and `trip_duration`, as well as the ratio of `trip_duration` over `trip_distance`. Results should be broken up by `pickup_nhood` and `dropoff_nhood`.

### Solutions

1.  Without the pipeline function, we would have `arrange` as the outermost function:

``` r
arrange( # (4)
  summarize( # (3)
    group_by( # (2)
      filter(nyc_taxi, fare_amount > 500), # (1)
    payment_type),
  ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)),
desc(ave_duration))
```

With the pipeline function, we simply add the pipe to the end of `summarize` and add `arrange` as a new line to the end of the code:

``` r
q1 <- nyc_taxi %>%
  filter(fare_amount > 500) %>% # (1)
  group_by(payment_type) %>% # (2)
  summarize(ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)) %>% # (3)
  arrange(desc(ave_duration)) # (4)

head(q1)
```

1.  What are the times of the day and the days of the week with the highest fare per mile of ride?

``` r
q2 <- nyc_taxi %>%
  filter(trip_distance > 0) %>%
  group_by(pickup_dow, pickup_hour) %>%
  summarize(ave_fare_per_mile = mean(fare_amount / trip_distance, na.rm = TRUE), count = n()) %>%
  group_by() %>% # we 'reset', or remove, the group by, otherwise sorting won't work
  arrange(desc(ave_fare_per_mile))

head(q2)
```

1.  For each pick-up neighborhood, find the number and percentage of trips that "fan out" into other neighborhoods. Sort results by pickup neighborhood and descending percentage. Limit results to top 50 percent coverage. In other words, show only the top 50 percent of destinations for each pick-up neighborhood.

``` r
q3 <- nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize(count = n()) %>%
  group_by(pickup_nhood) %>%
  mutate(proportion = prop.table(count),
         cum.prop = order_by(desc(proportion), 
         cumsum(proportion))) %>%
  group_by() %>%
  arrange(pickup_nhood, desc(proportion)) %>%
  group_by(pickup_nhood) %>%
  filter(row_number() < 11 | cum.prop < .50)

head(q3)
```

1.  Are any dates missing from the data?

There are many ways to answer this query and we cover three because each way highlights an important point. The first way consists sorting the data by date and using the `lag` function to find the difference between each date and the date proceeding it. If this difference is greater than 1, then we skipped one or more days.

``` r
nyc_taxi %>%
  select(pickup_datetime) %>%
  distinct(date = as.Date(pickup_datetime)) %>%
  arrange(date) %>% # this is an important step!
  mutate(diff = date - lag(date)) %>%
  arrange(desc(diff))
```

The second solution is more involved. First we create a `data.frame` of all dates available in `nyc_taxi`.

``` r
nyc_taxi %>%
  select(pickup_datetime) %>%
  distinct(date = as.Date(pickup_datetime)) %>%
  filter(!is.na(date)) -> data_dates
```

Then we create a new `data.frame` of all dates that span the time range in the data. We can use `seq` to do that.

``` r
start_date <- min(data_dates$date)
end_date <- max(data_dates$date)
all_dates <- data.frame(date = seq(start_date, end_date, by = '1 day'))
```

Finally, we ask for the "anti-join" of the two datasets. An anti-join is the opposite of an left join: any keys present in left dataset but not the right are returned.

``` r
anti_join(all_dates, data_dates, by = 'date') # an anti-join is the reverse of an left join
```

    ## [1] date
    ## <0 rows> (or 0-length row.names)

The third solution consists of comparing the number of days between the earliest and latest dates in the data to the number of days we expect to see if no days were missing.

``` r
nyc_taxi %>%
  distinct(date = as.Date(pickup_datetime)) %>%
  filter(is.na(date) == FALSE) %>%
  summarize(min_date = min(date), max_date = max(date), n = n()) %>%
  mutate(diff = max_date - min_date + 1)
```

1.  Find the 3 consecutive days with the most total number of trips?

This is a hard exercise. In query 3, we need to compute rolling statistics (rolling sums in this case). There are functions in R that we can use for that purpose, but one of the advantages of R is that writing our own functions is not always that hard. Write a function called `rolling_sum` that takes in two arguments: `x` and `nlag`: `x` is a numeric vector `nlags` is a positive integer for the number of days we're rolling by. The function returns a vector of the same length as `x`, of the rolling sum of `x` over `nlag` elements.

For example, given `x <- 1:6` and `n <- 2` as inputs, the function returns `c(NA, NA, 6, 9, 12, 15)`

``` r
rolling_sum <- function(x, nlag) {
  stopifnot(nlag > 0, nlag < length(x))
  c(rep(NA, nlag), sapply((nlag + 1):length(x), function(ii) sum(x[(ii - nlag):ii])))
}
# Here's an easy test to see if things seem to be working:
rolling_sum(rep(1, 100), 10) # Should return 10 NAs followed by 90 entries that are all 11
```

    ##   [1] NA NA NA NA NA NA NA NA NA NA 11 11 11 11 11 11 11 11 11 11 11 11 11
    ##  [24] 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11
    ##  [47] 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11
    ##  [70] 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11
    ##  [93] 11 11 11 11 11 11 11 11

We can even go one step further. Let's rename the function to `rolling` and add a third argument to it called `FUN`, allowing us to specify any rolling function, not just `sum`.

``` r
rolling <- function(x, nlag, FUN) {
  stopifnot(nlag > 0, nlag < length(x))
  c(rep(NA, nlag), sapply((nlag + 1):length(x), function(ii) FUN(x[(ii - nlag):ii])))
}
```

We can now use `rolling` to find the 3 consecutive days with the most total number of trips.

``` r
nlag <- 2

q5 <- nyc_taxi %>%
  filter(!is.na(pickup_datetime)) %>%
  transmute(end_date = as.Date(pickup_datetime)) %>%
  group_by(end_date) %>%
  summarize(n = n()) %>%
  group_by() %>%
  mutate(start_date = end_date - nlag, cn = rolling(n, nlag, sum)) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)

head(q5)
```

As it turns out, there's already a similar function we could have used, called `rollapply` in the `zoo` package. Sometimes it pays off to take the time and search for the right function, especially if what we're trying to do is common enough that we should not have to "reinvent the wheel".

``` r
library(zoo)
rollapply(1:10, 3, sum, fill = NA, align = 'right')
```

    ##  [1] NA NA  6  9 12 15 18 21 24 27

Here's an alternative solution: We could have run the above query without `rolling` by just using the `lag` function, but the code is more complicated and harder to automate it for different values of `nlag` or for different functions other than `sum`. Here's how we can rewrite the above query with `lag`:

``` r
q5 <- nyc_taxi %>%
  filter(!is.na(pickup_datetime)) %>%
  transmute(end_date = as.Date(pickup_datetime)) %>%
  group_by(end_date) %>%
  summarize(n = n()) %>%
  group_by() %>%
  mutate(start_date = end_date - 3,
  n_lag_1 = lag(n), n_lag_2 = lag(n, 2),
  cn = n + n_lag_1 + n_lag_2) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)

head(q5)
```

1.  Get the average, standard deviation, and mean absolute deviation of `trip_distance` and `trip_duration`, as well as the ratio of `trip_duration` over `trip_distance`. Results should be broken up by `pickup_nhood` and `dropoff_nhood`.

Here's how we compute the mean absolute deviation:

``` r
mad <- function(x) mean(abs(x - median(x))) # one-liner functions don't need curly braces
```

This query can easily be written with the tools we learned so far.

``` r
q6 <- nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize(mean_trip_distance = mean(trip_distance, na.rm = TRUE),
            mean_trip_duration = mean(trip_duration, na.rm = TRUE),
            sd_trip_distance = sd(trip_distance, na.rm = TRUE),
            sd_trip_duration = sd(trip_duration, na.rm = TRUE),
            mad_trip_distance = mad(trip_distance),
            mad_trip_duration = mad(trip_duration))

head(q6)
```

You may have noticed that the query we wrote in the last exercise was a little tedious and repetitive. Let's now see a way of rewriting the query using some "shortcut" functions available in `dplyr`:

-   When we apply the same summary function(s) to the same column(s) of the data, we can save a lot of time typing by using `summarize_each` instead of `summarize`. There is also a `mutate_each` function.
-   We can select `trip_distance` and `trip_duration` automatically using `starts_with('trip_')`, since they are the only columns that begin with that prefix, this can be a time-saver if we are selecting lots of columns at once (and we named them in a smart way). There are other helper functions called `ends_with` and `contains`.
-   Instead of defining the `mad` function separately, we can define it in-line. In fact, there's a shortcut whereby we just name the function and provide the body of the function, replacing `x` with a period.

``` r
q6 <- nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize_each(
    funs(mean, sd, mad = mean(abs(. - median(.)))), # all the functions that we apply to the data are   listed here
    starts_with('trip_'), # `trip_distance` and `trip_duration` are the only columns that start with `trip_`
    wait_per_mile = trip_duration / trip_distance) # `duration_over_dist` is created on the fly

head(q6)
```

We can do far more with `dplyr` but we leave it at this for an introduction. The goal was to give the user enough `dplyr` to develop an appreciation and be inspired to learn more.
