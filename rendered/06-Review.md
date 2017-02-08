Review
================
Seth Mottaghinejad
2017-02-08

There are many important themes that are worth highlighting as this course comes to an end:

-   **Learn your basic data types:** We saw many examples of how different functions can sometimes return more or less the same results but in different formats. Knowing which data types we are dealing with helps us understand how to query and drill into different objects, and over time we develop a better intuition of the pros and cons of each data type, for example the flexibility of a `list` versus the structured layout of an `array`.
-   **Build upon existing tools:** R is a flexible language and one that is easy to build upon. This is the reason so many R packages exist and continue to grow. We covered many examples of how we can modify or tweak an existing function, or put together many functions to create our own summary functions. What is true about almost every programming language is true about R as well: we start small, make changes incrementally and test the code along the way. -**Learn about different packages:** As R users, in addition to specialized packages, we should be familiar with the most popular packages. Learning to use them can often save us a lot of time and the trouble of having to "reinvent the wheel".

In the next series of lectures, we will revisit the NYC Taxi dataset, and use the Microsoft R Server's `RevoScaleR` package to process and analyze a much larger dataset size. When dataset sizes get very large, we run into two problems:

1.  Since a `data.frame` is memory-bound, we may not have enough memory to process the dataset. `RevoScaleR` provides a framework to store data on disk and only load it into memory a small chunk at a time (so that we never use too much memory).
2.  Even with enough memory, it may take too long to process the dataset or run an analytics function on it, such as a statistical model. `RevoScaleR` offers a set of distributed algorithms that scale linearly with data size, so we can run analytical models on large datasets in a reasonable time.

We hope to see you there.
