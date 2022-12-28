# Install packages
install.packages('tidyverse')
install.packages('skimr')
install.packages('janitor')


# Loading libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(skimr)
library(janitor)
library(hms)


# Read in raw data
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


# Inspect raw data before combining
sapply(past12, colnames)
sapply(past12, str)


# Combine raw data into one dataframe
full_year <- bind_rows(past12)


# Inspect single dataframe
full_year %>% group_by(member_casual) %>% summarize()
full_year %>% group_by(rideable_type) %>% summarize()
skim_without_charts(full_year)


# Data without dropped stations
with_station <- filter(full_year, 
                  start_station_name != "" & end_station_name != "")


# Add columns to use in analysis
all_trips <- full_year %>% mutate(
  month = month(started_at, label=TRUE, abbr=TRUE), 
  day = wday(started_at, label=TRUE, abbr=TRUE), 
  trip_duration = as_hms(difftime(ended_at, started_at)))

all_trips <- mutate(all_trips, 
                    duration_as_mins = as.numeric(trip_duration)/60)


# Visualize and summarize rideable_types
ggplot(data = all_trips) + 
  geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) + 
  facet_wrap(~day)

ggplot(data = all_trips) + 
  geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) + 
  facet_wrap(~month)

all_trips %>% 
  group_by(rideable_type) %>% 
  summarize(mean_duration = mean(duration_as_mins), 
            max_duration = max(duration_as_mins), 
            min_duration = min(duration_as_mins))


# Use previous observations to clean data
clean_trips <- all_trips %>% 
  filter(rideable_type != 'docked_bike') %>% 
  filter(duration_as_mins > 0 & duration_as_mins < 60)

cleanv2 <- clean_trips %>% 
  filter(start_station_name != "" & end_station_name != "")


# Validate the data that's been removed
clean_missing_stations <- clean_trips %>% 
  filter(start_station_name == "" | end_station_name == "")

clean_missing_stations %>% group_by(month) %>% summary()
clean_missing_stations %>% group_by(month) %>% count()


# Inspect cleaned data
summary(cleanv2$duration_as_mins)

aggregate(cleanv2$duration_as_mins ~ cleanv2$member_casual, 
          FUN = summary)

aggregate(
  cleanv2$duration_as_mins ~ cleanv2$member_casual + cleanv2$day, 
  FUN = mean)


# Make a summary set for analysis
ctrips_by_duration <- cleanv2 %>% 
  group_by(rideable_type, member_casual, day, month) %>% 
  summarize(num_rides = n(), 
            avg_ride = mean(duration_as_mins), 
            median_ride = median(duration_as_mins)) %>% 
  arrange(month, day, member_casual, rideable_type)


# Visualize with plots
ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=day, y=num_rides, fill=member_casual), 
           position="dodge") + 
  labs(title='Daily Rides', 
       subtitle = 'by rider type', 
       y = 'Number of Rides', 
       x = 'Day of the Week')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=day, y=num_rides, fill=member_casual)) + 
  labs(title='Daily Rides', 
       subtitle = 'by rider type', 
       y = 'Number of Rides', 
       x = 'Day of the Week')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=month, y=num_rides, fill=member_casual), 
           position="dodge") + 
  labs(title = 'Monthly Rides', 
       subtitle = 'by rider type',
       x = 'Months',
       y = 'Number of Rides')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=month, 
                         y=num_rides, 
                         fill=member_casual)) + 
  labs(title = 'Monthly Rides', 
       subtitle = 'by rider type',
       x = 'Months',
       y = 'Number of Rides')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=day, y=avg_ride, fill=member_casual), 
           position="dodge") + 
  labs(title = 'Avg Ride Time',
       subtitle = 'by day',
       x = 'Day of the Week',
       y = 'Ride Time')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=day, y=median_ride, fill=member_casual),
           position = 'dodge') + 
  labs(title = 'Median Ride Time',
       subtitle = 'by day',
       x = 'Day of the Week',
       y = 'Ride Time')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=month, y=avg_ride, fill=member_casual), 
           position="dodge") + 
  labs(title = 'Avg Ride Time',
       subtitle = 'by month',
       x = 'Month',
       y = 'Ride Time')

ggplot(data = ctrips_by_duration) + 
  geom_col(mapping = aes(x=month, 
                         y=median_ride, 
                         fill=member_casual),
           position = 'dodge') + 
  labs(title = 'Median Ride Time',
       subtitle = 'by month',
       x = 'Month',
       y = 'Ride Time')


# Adding column for time-of-day histogram
cleanv2 <- cleanv2 %>% 
  mutate(start_time = (hour(started_at) * 60) + 
           minute(started_at) + 
           (second(started_at) / 60))


# Visualizing histogram
ggplot(data = cleanv2) + 
  geom_histogram(mapping = aes(x = start_time, 
                               fill = member_casual), 
                 binwidth = 60, # larger binwidth equals less bins
                 position = 'dodge')

