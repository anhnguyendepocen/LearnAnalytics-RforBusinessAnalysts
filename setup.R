
knitr::opts_chunk$set(fig.width = 10, fig.height = 10, fig.path = 'rendered/images/',
                      cache = FALSE, warning = FALSE, message = FALSE, 
                      echo = TRUE, tidy = FALSE)

data_dir <- "C:/Data/NYC_taxi"
if (file.exists("nyc_taxi.RData")) load(file = "nyc_taxi.RData")
