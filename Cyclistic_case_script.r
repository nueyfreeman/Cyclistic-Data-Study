install.packages('tidyverse')

library(tidyverse)
library(lubridate)
library(ggplot2)

dec2021 <- read.csv("Past12Data/202112-divvy-tripdata.csv")
jan2022 <- read.csv("Past12Data/202201-divvy-tripdata.csv")
feb2022 <- read.csv("Past12Data/202202-divvy-tripdata.csv")
mar2022 <- read.csv("Past12Data/202203-divvy-tripdata.csv")
apr2022 <- read.csv("Past12Data/202204-divvy-tripdata.csv")
may2022 <- read.csv("Past12Data/202205-divvy-tripdata.csv")
jun2022 <- read.csv("Past12Data/202206-divvy-tripdata.csv")
jul2022 <- read.csv("Past12Data/202207-divvy-tripdata.csv")
aug2022 <- read.csv("Past12Data/202208-divvy-tripdata.csv")
sep2022 <- read.csv("Past12Data/202209-divvy-publictripdata.csv")
oct2022 <- read.csv("Past12Data/202210-divvy-tripdata.csv")
nov2022 <- read.csv("Past12Data/202211-divvy-tripdata.csv")

past12 <- list(dec2021, jan2022, feb2022, mar2022, apr2022, may2022, 
            jun2022, jul2022, aug2022, sep2022, oct2022, nov2022)

sapply(past12, colnames)
sapply(past12, str)

full_year <- bind_rows(past12)

with_station <- filter(full_year, 
                  start_station_name != "" & end_station_name != "")



