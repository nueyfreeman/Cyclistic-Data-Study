install.packages('tidyverse')
install.packages('skimr')
install.packages('janitor')

library(tidyverse)
library(lubridate)
library(ggplot2)
library(skimr)
library(janitor)
library(hms)

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

full_year %>% group_by(member_casual) %>% summarize()
full_year %>% group_by(rideable_type) %>% summarize()
skim_without_charts(full_year)

with_station <- filter(full_year, 
                  start_station_name != "" & end_station_name != "")

all_trips <- full_year %>% mutate(
  month = month(started_at, label=TRUE, abbr=TRUE), 
  day = wday(started_at, label=TRUE, abbr=TRUE), 
  trip_duration = as_hms(difftime(ended_at, started_at)))

ggplot(data = all_trips) 
+ geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) 
+ facet_wrap(~day)

ggplot(data = all_trips) 
+ geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) 
+ facet_wrap(~month)

all_trips <- mutate(all_trips, 
                  duration_as_mins = as.numeric(trip_duration) / 60)
all_trips %>% 
  group_by(rideable_type) %>% 
  summarize(mean_duration = mean(duration_as_mins), 
            max_duration = max(duration_as_mins), 
            min_duration = min(duration_as_mins))

clean_trips <- all_trips %>% 
  filter(rideable_type != 'docked_bikes') %>% 
  filter(duration_as_mins > 0 & duration_as_mins < 60)

cleanv2 <- clean_trips %>% 
  filter(start_station_name != "" & end_station_name != "")
