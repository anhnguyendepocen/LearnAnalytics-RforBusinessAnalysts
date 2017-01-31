Inspecting the data
================
Seth Mottaghinejad
2017-01-31

With the data loaded in the R session, we are ready to inspect the data and write some basic queries against it. The goal of this chapter is to get a feel for the data. Any exploratory analysis often consists of the following steps:

1.  load all the data (and combine them if necessary)
2.  **inspect the data in preparation cleaning it**
3.  clean the data in preparation for analysis
4.  add any interesting features or columns as far as they pertain to the analysis
5.  find ways to analyze or summarize the data and report your findings

We are now in step 2, where we intend to introduce some helpful R functions for inspecting the data and write some of our own.

Most of the time, the above steps are not clearly delineated from each other. For example, one could inspect certain columns of the data, clean them, build new features out of them, and then move on to other columns, thereby iterating on steps 2 through 4 until all the columns are dealt with. This approach is completely valid, but for the sake of teaching the course we prefer to show each step as distinct. Moreover, going over results and findings can often guide how data should be collected and processed in the future, so it is more accurate to present the above workflow as being circular, but once again for simplicity we assume a linear workflow.

Basic queries
-------------

Let's begin the data exploration. Each of the functions below return some useful information about the data.

``` r
head(nyc_taxi) # show me the first few rows
```

``` r
head(nyc_taxi, n = 3) # show me the first n rows
```

``` r
tail(nyc_taxi) # show me the last few rows
```

``` r
basic_info <- list(
  class = class(nyc_taxi), # shows the type of the data: `data.frame`
  type = typeof(nyc_taxi), # shows that a `data.frame` is fundamentally a `list` object
  nrow = nrow(nyc_taxi), # number of rows
  ncol = ncol(nyc_taxi), # number of columns
  colnames = names(nyc_taxi))

basic_info
```

    ## $class
    ## [1] "tbl_df"     "tbl"        "data.frame"
    ## 
    ## $type
    ## [1] "list"
    ## 
    ## $nrow
    ## [1] 6000000
    ## 
    ## $ncol
    ## [1] 17
    ## 
    ## $colnames
    ##  [1] "pickup_datetime"       "dropoff_datetime"     
    ##  [3] "passenger_count"       "trip_distance"        
    ##  [5] "pickup_longitude"      "pickup_latitude"      
    ##  [7] "rate_code_id"          "dropoff_longitude"    
    ##  [9] "dropoff_latitude"      "payment_type"         
    ## [11] "fare_amount"           "extra"                
    ## [13] "mta_tax"               "tip_amount"           
    ## [15] "tolls_amount"          "improvement_surcharge"
    ## [17] "total_amount"

We use `str` to look at column types in the data: the most common column types are `integer`, `numeric` (for floats), `character` (for strings), `factor` (for categorical data). Less common column types exist, such as date, time, and datetime formats.

``` r
str(nyc_taxi)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    6000000 obs. of  17 variables:
    ##  $ pickup_datetime      : chr  "2016-06-21 21:33:52" "2016-06-08 09:52:19" "2016-06-14 23:27:22" "2016-06-12 20:13:12" ...
    ##  $ dropoff_datetime     : chr  "2016-06-21 21:34:40" "2016-06-08 10:19:55" "2016-06-14 23:35:05" "2016-06-12 20:18:53" ...
    ##  $ passenger_count      : int  5 1 1 5 3 1 1 2 1 1 ...
    ##  $ trip_distance        : num  0.4 5.2 2.1 2.23 2.72 1.3 8.94 0.87 1.6 2.43 ...
    ##  $ pickup_longitude     : num  -74 -74 -74 -74 -74 ...
    ##  $ pickup_latitude      : num  40.7 40.8 40.7 40.8 40.7 ...
    ##  $ rate_code_id         : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ dropoff_longitude    : num  -74 -74 -74 -74 -74 ...
    ##  $ dropoff_latitude     : num  40.7 40.8 40.7 40.8 40.7 ...
    ##  $ payment_type         : int  1 2 1 1 1 2 1 1 2 2 ...
    ##  $ fare_amount          : num  3 21.5 9 8 17 7.5 30.5 5 9.5 10.5 ...
    ##  $ extra                : num  0.5 0 0.5 0.5 0.5 1 0 0.5 0 0.5 ...
    ##  $ mta_tax              : num  0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 ...
    ##  $ tip_amount           : num  0.86 0 1.5 2.79 3.66 0 7.37 1.7 0 0 ...
    ##  $ tolls_amount         : num  0 0 0 0 0 0 5.54 0 0 0 ...
    ##  $ improvement_surcharge: num  0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 ...
    ##  $ total_amount         : num  5.16 22.3 11.8 12.09 21.96 ...

Now let's see how we can subset or slice the data: in other words. Since a `data.frame` is a 2-dimensional object, we can slice by asking for specific rows or columns of the data. The notation we use here (which we refer to as the **bracket notation**) is as follows:

    data[rows_to_slice, columns_to_slice]

As we will see, we can be very flexible in what we choose for `rows_to_slice` and `columns_to_slice`. For example,

-   we can provide numeric indexes corresponding to row numbers or column positions
-   we can (and should) specify the column names instead of column positions
-   we can provide functions that return integers corresponding to the row indexes we want to return
-   we can provide functions that return the column names we want to return
-   we can have conditional statements or functions that return `TRUE` and `FALSE` for each row or column, so that only cases that are `TRUE` are returned

We will encounter examples for each case.

``` r
nyc_taxi[1:5, 1:4] # rows 1 through 5, columns 1 through 4
```

``` r
nyc_taxi[1:5, -(1:4)] # rows 1 through 5, except columns 1 through 4
```

``` r
nyc.first.ten <- nyc_taxi[1:10, ] # store the first 10 rows and all columns in a new `data.frame` called `nyc.first.ten`
```

So far our data slices have been limited to adjacent rows and adjacent columns. Here's an example of how to slice the data for non-adjacent rows. It is also far more common to select columns by their names instead of their position (also called numeric index), since this makes the code more readable and won't break the code if column positions change.

``` r
nyc_taxi[c(2, 3, 8, 66), c("fare_amount", "mta_tax", "tip_amount", "tolls_amount")]
```

More on querying data
---------------------

To query a single column of the data, we have two options:

-   we can still use the bracket notation, namely `data[ , col_name]`
-   we can use a list notation, namely `data$col_name`

``` r
nyc_taxi[1:10, "fare_amount"]
```

``` r
nyc_taxi$fare_amount[1:10]
```

    ##  [1]  3.0 21.5  9.0  8.0 17.0  7.5 30.5  5.0  9.5 10.5

Depending on the situation, one notation may be preferable to the other, as we will see.

So far we sliced the data at particular rows using the index of the row. A more common situation is one where we query the data for rows that meet a given condition. Multiple conditions can be combined using the `&` (and) and `|` (or) operators.

``` r
head(nyc_taxi[nyc_taxi$fare_amount > 350, ]) # return the rows of the data where `fare_amount` exceeds 350
```

We can use a function like `grep` to grab only columns that match a certain pattern, such as columns that have the word 'amount' in them.

``` r
amount_vars <- grep('amount', names(nyc_taxi), value = TRUE)
nyc_taxi[nyc_taxi$fare_amount > 350 & nyc_taxi$tip_amount < 10, amount_vars]
```

As these conditional statements become longer, it becomes increasingly tedious to write `nyc_taxi$` proir to the column name every time we refer to a column in the data. Note how leaving out `nyc_taxi$` by accident can result in an error:

``` r
nyc_taxi[nyc_taxi$fare_amount > 350 & tip_amount < 10, amount_vars]
```

    ## Error in lapply(x, `[`, i): object 'tip_amount' not found

As the error suggests, R expected to find a stand-alone object called `tip_amount`, which doesn't exist. Instead, we meant to point to the column called `tip_amount` in the nyc\_taxi dataset, in other words `nyc_taxi$tip_amount`. This error also suggests one dangerous pitfall: if we did have an object called `tip_amount` in our R session, we may have failed to notice the bug in the code.

``` r
tip_amount <- 20 # this is the value that will be used to check the condition below
amount_vars <- grep('amount', names(nyc_taxi), value = TRUE)
nyc_taxi[nyc_taxi$fare_amount > 350 & tip_amount < 10, amount_vars] # since `20 < 10` is FALSE, we return an empty data
```

There are three ways to avoid such errors: (1) avoid having objects with the same name as column names in the data, (2) use the `with` function. With `with` we are explicitly telling R that the columns we reference are in `nyc_taxi`, this way we don't need to prefix the columns by `nyc_taxi$` anymore. Here's the above query rewritten using `with`.

``` r
with(nyc_taxi, nyc_taxi[fare_amount > 350 & tip_amount < 10, amount_vars])
```

We can use `with` any time we need to reference multiple columns in the data, not just for slicing the data. In the specific case where we slice the data, there is another option: using the `subset` function. Just like `with`, `subset` takes in the data as its first input so we don't have to prefix column names with `nyc_taxi$`. We can also use the `select` argument to slice by columns. Let's contrast slicing the data using `subset` with the bracket notation:

-   bracket notation: `data[rows_to_slice, columns_to_slice]`
-   using `subset`: `subset(data, rows_to_slice, select = columns_to_slice)`

Here's what the above query would look like using `subset`:

``` r
subset(nyc_taxi, fare_amount > 350 & tip_amount < 10, select = amount_vars)
```

The `select` argument for `subset` allows us to select columns in a way that is not possible with the bracket notation:

``` r
nyc_small <- subset(nyc_taxi, fare_amount > 350 & tip_amount < 10,
  select = fare_amount:tip_amount) # return all columns between `fare_amount` and `tip_amount`
dim(nyc_small)
```

    ## [1] 58  4

### Exercises

Here is an example of a useful new function: `seq`

``` r
seq(1, 10, by = 2)
```

    ## [1] 1 3 5 7 9

1.  Once you figure out what `seq` does, use it to take a sample of the data consisting of every 2500th rows. Such a sample is called a **systematic sample**.

Here is another example of a useful function: `rep`

``` r
rep(1, 4)
```

    ## [1] 1 1 1 1

What happens if the first argument to `rep` is a vector?

``` r
rep(1:2, 4)
```

    ## [1] 1 2 1 2 1 2 1 2

What happens if the second argument to `rep` is also a vector (of the same length)?

``` r
rep(c(3, 6), c(2, 5))
```

    ## [1] 3 3 6 6 6 6 6

1.  Create a new data object consisting of 5 copies of the first row of the data.

2.  Create a new data object consisting of 5 copies of each of the first 10 rows of the data.

3.  We learned to how to slice data using conditional statements. Note that in R, not all conditional statements have to involve columns in the data. Here's an example:

``` r
subset(nyc_small, fare_amount > 100 & 1:2 > 1)
```

See if you can describe what the above statement returns. Of course, just because we can do something in R doesn't mean that we should. Sometimes, we have to sacrifice a little bit of efficiency or conciseness for the sake of clarity. So reproduce the above subset in a way that makes the code more understandable. There is more than one way to do this, and you can break up the code in two steps instead of one if you want.

Here's another useful R function: `sample`. Run the below example multiple times to see the different samples being generated.

``` r
sample(1:10, 5)
```

    ## [1]  5 10  3  2  4

1.  Use `sample` to create random sample consisting of about 10 percent of the data. Store the result in a new data object called `nyc_sample`.

There is another way to do what we just did (that does not involve the `sample` function). We start by creating a column `u` containing random uniform numbers between 0 and 1, which we can generate with the `runif` function.

``` r
nyc_taxi$u <- runif(nrow(nyc_taxi))
```

1.  Recreate the same sample we had in the last exercise but use the column `u` instead.

2.  You would probably argue that the second solution is easier. There is however an advantage to using the `sample` function: we can also do sampling **with replacement** with the `sample` function. First find the argument that allows sampling with replacement. Then use it to take a sample of size 1000 *with replacement* from the `nyc_taxi` data.

### Solutions

1.  We simply use the output of `seq` as indexes for selecting rows:

``` r
head(nyc_taxi[seq(1, nrow(nyc_taxi), 2500), ])
```

Another approach we can take is to use the **modulo operator** (`%%`) in R, but a this approach is less efficient.

``` r
head(nyc_taxi[1:nrow(nyc_taxi) %% 2500 == 1, ])
```

1.  In this case, we are still using the same bracket notation, but this time return the first rows 5 times.

``` r
nyc_taxi[rep(1, 5), ]
```

1.  This is akin to the last exercise, but this time we repeat `1:10` instead of just `1`. We use `head` here to only show the top 6 rows.

``` r
head(nyc_taxi[rep(1:10, 5), ])
```

Notice the way that the row indexes appear in the results in each case. This can sometimes be an indication of how the data was sampled.

1.  As it turns out, the second condition makes it so that we skip every other row of the data, but we need to be familiar with vector operation in R to guess that and even then it is not immediately clear that is what's happening. So here's a better way of doing the same thing.

``` r
nyc_small <- nyc_small[seq(2, nrow(nyc_small), by = 2), ] # take even-numbered rows
subset(nyc_small, fare_amount > 100)
```

1.  Here's one way we can sample from the data.

``` r
nyc_sample <- nyc_taxi[sample(1:nrow(nyc_taxi), nrow(nyc_taxi)/10) , ]
```

1.  Here's a second way of doing it.

``` r
nyc_sample <- subset(nyc_taxi, u < .1)
nyc_taxi$u <- NULL # we can drop `u` now, since it is no longer needed
```

1.  We can sample with replacement using the `replace = TRUE` argument in the `sample` function.

``` r
nyc_sample <- nyc_taxi[sample(1:nrow(nyc_taxi), 1000, replace = TRUE) , ]
```

Basic summaries
---------------

After `str`, `summary` is probably the most ubiquitous R function. It provides us with summary statistics of each of the columns in the data. The kind of summary statistics we see for a given column depends on the column type. Just like `str`, `summary` gives clues for how we need to clean the data. For example

-   `pickup_datetime` and `dropoff_datetime` should be `datetime` columns, not `character`
-   `rate_code_id` and `payment_type` should be a `factor`, not `character`
-   the geographical coordinates for pick-up and drop-off occasionally fall outside a reasonable bound (probably due to error)
-   `fare_amount` is sometimes negative (could be refunds, could be errors, could be something else)

Once we clean the data (next chapter), we will rerun summary and notice how we see the appropriate summary statistics once the column have been converted to the right classes.

What if there are summaries we don't see? We can just write our own summary function, and here's an example. The `num.distinct` function will return the number of unique elements in a vector. Most of the work is done for us: the `unique` function returns the unique elements of a vector, and the `length` function counts how many there are. Notice how the function is commented with information about input types and output.

``` r
num.distinct <- function(x) {
# returns the number of distinct values of a vector `x`
# `x` can be numeric (floats are not recommended) , character, logical, factor
# to see why floats are a bad idea try this:
# unique(c(.3, .4 - .1, .5 - .2, .6 - .3, .7 - .4))
  length(unique(x))
}
```

It's usually a good idea to test the function with some random inputs before we test it on the larger data. We should also test the function on 'unusual' inputs to see if it does what we expect from it.

``` r
num.distinct(c(5, 6, 6, 9))
```

    ## [1] 3

``` r
num.distinct(1) # test the function on a singleton (a vector of length 1)
```

    ## [1] 1

``` r
num.distinct(c()) # test the function on an empty vector
```

    ## [1] 0

``` r
num.distinct(c(23, 45, 45, NA, 11, 11)) # test the function on a vector with NAs
```

    ## [1] 4

Now we can test the function on the data, for example on `pickup_longitude`:

``` r
num.distinct(nyc_taxi$pickup_longitude) # check it on a single variable in our data
```

    ## [1] 31159

But what if we wanted to run the function on all the columns in the data at once? We could write a loop, but instead we show you the `sapply` function, which accomplishes the same thing in a more succint and R-like manner. With `sapply`, we pass the data as the first argument, and some function (usually a summary function) as the second argument: `sapply` will run the function on each column of the data (or those columns of the data for which the summary function is relevant).

``` r
sapply(nyc_taxi, num.distinct) # apply it to each variable in the data
```

    ##       pickup_datetime      dropoff_datetime       passenger_count 
    ##               4819099               4818764                    10 
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

Any secondary argument to the summary function can be passed along to `sapply`. This feature makes `sapply` (and other similar functions) very powerful. For example, the `mean` function has an argument called `na.rm` for removing missing values. By default, `na.rm` is set to `FALSE` and unless `na.rm = TRUE` the function will return `NA` if there is any missing value in the data.

``` r
sapply(nyc_taxi, mean) # returns the average of all columns in the data
```

    ##       pickup_datetime      dropoff_datetime       passenger_count 
    ##                    NA                    NA                 1.661 
    ##         trip_distance      pickup_longitude       pickup_latitude 
    ##                 3.805               -72.918                40.169 
    ##          rate_code_id     dropoff_longitude      dropoff_latitude 
    ##                    NA               -72.981                40.205 
    ##          payment_type           fare_amount                 extra 
    ##                    NA                12.985                 0.333 
    ##               mta_tax            tip_amount          tolls_amount 
    ##                 0.497                 1.802                 0.315 
    ## improvement_surcharge          total_amount 
    ##                 0.300                16.233

``` r
sapply(nyc_taxi, mean, na.rm = TRUE) # returns the average of all columns in the data after removing NAs
```

    ##       pickup_datetime      dropoff_datetime       passenger_count 
    ##                    NA                    NA                 1.661 
    ##         trip_distance      pickup_longitude       pickup_latitude 
    ##                 3.805               -72.918                40.169 
    ##          rate_code_id     dropoff_longitude      dropoff_latitude 
    ##                 1.039               -72.981                40.205 
    ##          payment_type           fare_amount                 extra 
    ##                 1.343                12.985                 0.333 
    ##               mta_tax            tip_amount          tolls_amount 
    ##                 0.497                 1.802                 0.315 
    ## improvement_surcharge          total_amount 
    ##                 0.300                16.233

### Exercises

Let's return to the `num.distinct` function we created earlier. The comment inside the function indicated that we should be careful about using it with a non-integer `numeric` input (a float). The problem lies with how `unique` handles such inputs. Here's an example:

``` r
unique(c(.3, .4 - .1, .5 - .2, .6 - .3, .7 - .4)) # what happened?
```

    ## [1] 0.3 0.3 0.3

Generally, to check for equality between two numeric value (or two numeric columns), we need to be more careful.

``` r
.3 == .4 - .1 # returns unexpected result
```

    ## [1] FALSE

The right way to check if two real numbers are equal is to see if their difference is below a certain threshold.

``` r
abs(.3 - (.4 - .1)) < .0000001 # the right way of doing it
```

    ## [1] TRUE

Another more convenient way to check equality between two real numbers is by using the `all.equal` function.

``` r
all.equal(.3, .4 - .1) # another way of doing it
```

    ## [1] TRUE

1.  Use `all.equal` to determine if `total_amount` is equal to the sum of `fare_amount`, `extra`, `mta_tax`, `tip_amount`, `tolls_amount`, and `improvement_surcharge`.

2.  What are some other ways we could check (not necessarily exact) equality between two numeric variables?

### Solutions

1.  We can pass the two columns (vectors) directly to `all.equal` to check if they are the same, but the second column needs to be computed on the fly.

``` r
with(nyc_taxi,
  all.equal(total_amount,
    fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge)
  )
```

    ## [1] "Mean relative difference: 0.00024"

1.  Another way to check for equality is by looking at correlation. Two identical columns of `numeric` type will have a correlation of 1.

``` r
with(nyc_taxi,
  cor(total_amount, # we could use correlation instead of `all.equal`
    fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge)
  )
```

    ## [1] 1
