
## Cyclistic Bikeshare Case Study

### Intro

In this scenario, the marketing department of the Cyclistic Bikeshare Company in Chicago, IL is seeking to evaluate possible opportunities to convert casual users (those who make short-term or daily use of the bikeshares) to annual members (who pay a subscription and are more profitable). Having been asked to analyze the data, I will develop a report documenting my analysis and the conclusions I found concerning the differences between casual riders and annual members. 

To answer this question, analysis will be performed on rideshare data from the past 12 months: **December 2021 through November 2022**. I will highlight 3 key insights from this data and make a final recommendation on possible opportunities to convert casual users to annual members. 

#### Sourcing the data

I have been directed to use public data located at <https://divvy-tripdata.s3.amazonaws.com/index.html> for this analysis. This is bikeshare data from an actual bikeshare program in Chicago called Divvy, which will be used as a stand-in for relevant proprietary in-house data from the fictional company Cyclistic.


#### Inspecting the data

I opened the files in R as dataframes and inspected each before combining them. I verified that the column names and data types were consistent then joined the data from each month into one large dataframe.

I also confirmed that there are three different bike types (`classic_bike`, `docked_bike`, `electric_bike`) and two different types of members (`member` and `casual`), as expected. I discovered that certain subsets of this data do not include any entry on the start and end stations of trips (`start_station_name`, `end_station_name`). There were approximately 800k observances like this.

It seemed to be certain months that contained many observances missing this information, although those observances did include latitude and longitude data which could perhaps be used to determine the stations. These observances did contain the other information such as `started_at`, `ended_at`, `member_casual` and `rideable_type`. Those are the more relevant factors in context of the business question under investigation, so the missing stations should not have any bearing on the analysis. No other columns had any significant amount of missing data.

Lastly, I confirmed that the columns had a consistent datetime format and verified that I could filter out some cases (such as the observances without station names) if necessary. However, as stated above, I decided it would not be necessary, unless the empty columns suggest a lack of data integrity for those observances.


#### Preparing the data

I added the following columns to the dataset for convenience in analysis: I made columns for `day` of the week and for `month`, to compare rider behavior on different dates. I also calculated `trip_duration` in a new column based on the `started_at` and `ended_at` columns.

Before analyzing the data, I removed all observations without an entry for `start_station_name` and `end_station_name` so that there would be no question of data integrity where those observations are concerned. I confirmed that those weren't concentrated on a particular day or month before removing them.

After observing the data both in a histogram and as quartile values, I also elected to eliminate any trips with a duration of more than 3 hours or less than 0 minutes. The data gives no definite answer to how these values were found, but based on the station names and ids, the implication is that many of these may have referred to bikes taken out for maintenance or electric bikes taken out to be charged. Because these accounted for only a tiny percentage of the total observations, I eliminated them as outliers. Trips most frequently lasted between 0 and 30 minutes, which was further evidence that it was appropriate to conclude that trips longer than a few hours, or even days long in some cases, referred to a different situation entirely than the one I was investigating. 

Lastly, I noticed that the majority of these outliers I eliminated had `docked_bike` listed as the `rideable_type`. `docked_bike` accounted for a small percentage of the total rides, was always designated as `casual`, and had an average duration of approximately 2 hours - far more than the other bike types. For these reasons, I decided to eliminate all `docked_bike` observations as well, for the purpose of doing calculations. 

#### Analyzing the data

I created a new dataframe to use for analysis which reflected those refinements of the original data. I first inspected quartile and mean values for `duration_as_mins` in this dataset, then the same measures aggregated by `member_casual`, `rideable_type`, `day` and `month`. They showed significant difference in ride length between types of users overall. Bike type did not appear to differ significantly between types of users. 

I also recodified the trip start as `start_time` so that I could view the data in histogram form and compare peak usage times for different types of users. It showed that bike usage peaked in the late afternoon, when people are done with work or school, but that for subscription members there was a second peak coinciding with the morning commute. Casual riders showed no spike in usage during the morning hours.

The data also displayed significant differences in usage between types of users depending on the month and day of the week. By aggregating number of rides, I identified weekdays and winter months as times when members vastly outnumber casual users, marking a key difference in their usage patterns.

### Conclusion: The differences between members and casual riders

The data showed three key differences between annual members of the bikeshare and casual users. The first was that over all days and times of the year, casual users took longer rides than annual members did, where the median ride time for casual users was approximately 44% longer and the average ride time 64% longer.

It also showed that the usage rate for casual users (as a fraction of total rides), only matches that of annual members during the summer months and it significantly decreases during the weekdays. That is to say, although there are always some casual users and some members riding, annual members comprise a clear majority during the week and make up nearly all riders during the colder months of the year.

The last key difference between the two user groups is in the time of day that they ride. Members have overall higher ridership during daylight hours and total ridership peaks in the late afternoon. However, annual member ridership also peaks during the morning commute, at which time there is no corresponding peak for casual users. That is to say, the morning hours are when member rides most significantly outstrip casual rides.

##### Marketing Recommendations

If the Cyclistic Bikeshare Company's marketing team wishes to convert more casual users to annual subscribing members, they might target this growth in two ways. 

The first would be to target casual riders whose use matches that of annual members. Those that ride during the colder months, those that ride in the morning, those that ride on weekdays, and those that take short rides may have the most interest in an annual membership.

They could also use the data to target their marketing where they will reach the most casual users of their service. If they want to reach the highest amount of casual users, the data shows that they should target longer bike rides, rides that happen around the late afternoon and early evening and should time their marketing be seen on the weekends and during the summer.




