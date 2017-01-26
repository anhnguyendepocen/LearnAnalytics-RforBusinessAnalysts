R for Business Analysts
======================================

Welcome to R for Business Analysts Repository. You can find the latest materials from the workshop here. This course is intended for data scientists and who want to sharpen their R skills by working on analyzing a real dataset. This course can also be viewed as a preperatory course for learning Microsoft R's `RevoScaleR` package for handling large datasets.

## Course overview

Please refer to the [course syllabus](https://microsoft.sharepoint.com/teams/LearnAnalytics/Pages/CourseDetail.aspx#139) for the full syllabus. 

At a high level this is what we cover:

- importing data
- querying data
- cleaning data
- redo and optimize
- creating new features
- data summary and analysis
- statistical summaries
- data summary with `base` R
- data summary with `dplyr`

At a deeper level, the course is a deep-dive R programming course. The goal of the course is to learn about programming in R by working on a specific data analysis project. In other words, we will learn about

- data types in R
- control flow
- important R functions
- writing R efficient functions
- debugging/benchmarking/profiling in R
- using third-party packages

and more, but we will do so **in the context of doing data analysis**. This is what makes the course a *practical* introduction to R. It is in contrast to a *programmatic* introduction to R where users learn programming concepts _in a vacuum_. The latter is better-suited for strong programmers (in a general-purpose language like Python or Java) and just need to see the R syntax and its quirks.

## About pre-requisites

We strongly encourage the user to learn the basics of R before starting the course. In particular, familiarity with the following is highly recommended:

1. basic data-types in R
2. installing and loading R packages
3. using a good IDE like [RStudio](https://www.rstudio.com/products/RStudio/) or [RTVS](https://www.visualstudio.com/en-us/features/rtvs-vs.aspx) (R Tools for Visual Studio)
4. looking up documentation or examples of how to use a specific R function
5. familiarity with some basic programming terminology, such as functions, arguments, variables, loops, etc.

We cover item (1) throughout the course, but a basic familiarity with data-types can make the content easier to digest. Learning item (2) is relatively easy, although the GIS packages we use (`rgeos` especially) may have OS-specific dependencies for Linux-based systems. Finally, item (3) is absolutely essential: knowing our way around an IDE can make it easier to learn an interpreted language such as R. Finally, item (4) can be as easy as looking at the official help page for a function, or it can involve navigating our way around the many websites and blogs with code examples in R. There are many helpful tutorials on Youtube or other places to get started with R, so we leave it up to the user to find such resources.

## Lab exercises

There are lots of lab exercises included in this course. We strongly encourage the participants to attempt the exercises before looking at the solution. Most of the exercises are challenging for a good reason: the purpose of the exercises is not always to confirm or strengthen what has been learned, but rather to set the tone for what is about to be learned. The intent is to get users to **think like an R programmer** and explore R functions by running different examples and then figuring out how to build upon them. Over time, this approach will pay off. Not being able to solve all the labs should not discourage learning.

## The dataset

The dataset we use for this course is a **sample** of the [NYC Taxi dataset](http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml). The dataset includes trip records from trips completed in yellow taxis in New York City for a given time period. **Each trip has information about pick-up and drop-off dates and times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and passenger counts.** The sample covers a very small subset (1 million trips per months) of trips ranging from January 1 to June 30, 2016.

[This is](https://github.com/smott/NYC-taxi-dataset/blob/master/00-Take-samples-of-data.md) how R was used to extract samples from the large NYC taxi CSV files.
