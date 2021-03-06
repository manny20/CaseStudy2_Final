#Case Study 2



#Question 3A

#Find the difference between the maximum and the minimum monthly average temperatures 
#for each country and report/visualize top 20 countries with
#the maximum differences for the period since 1900.

#Load packages necessary for analysis.
library(dplyr)
library(ggplot2)
library(lubridate)


#first lets look at the structure of the Data
str(Temp.data)
View(Temp.data)
colnames(Temp.data)

#Let's also see if there are NA's within our dataset columns
sapply(Temp.data, function(x)  sum(is.na(x)) )

#Date cleanup: convert dates to "date" variables of matching format.
ymd<- ymd(Temp.data$Date)
mdy<- dmy(Temp.data$Date)
ymd[is.na(ymd)]<-mdy[is.na(ymd)]
Temp.data$Date<-ymd

Temp.data$year <- substr(Temp.data$Date,1,4)
Temp.data$year <- as.numeric(Temp.data$year)

#find the difference between the maximum and the minimum monthly average temperature for each country.
Temp.one <- Temp.data %>% 
    select (Date,year, Country,Monthly.AverageTemp) %>% 
    na.omit() %>% 
    filter(year >= 1900) %>% 
    group_by(Country)  %>% 
  summarise(temp_diff = max(Monthly.AverageTemp) -
              min(Monthly.AverageTemp)) %>% 
    arrange(desc(temp_diff))

#report/visualize top 20 countries with the maximum differences for the period since 1900.
ggplot(Temp.one[1:20,], aes(Country,temp_diff)) + geom_col() + theme(axis.text.x=element_text(angle=90, hjust=1)) + xlab("Country") + ylab ("Range (Celcius)") + ggtitle("Top 20 temperature ranges by country") + theme(plot.title=element_text(hjust=0.5))



#Question 3B

#Select a subset of data called "UStemp" where US land temperatures from 01/01/1990 in Temp data. 
#Use UStemp dataset to answer the followings.
  #i.) Create a new column to display the monthly average land temperatures in Fahrenheit (?F).
  #ii.) Calculate average land temperature by year and plot it. 
    #The original file has the average land temperature by month.
  #iii.) Calculate the one year difference of average land temperature by year and 
    #provide the maximum difference (value) with corresponding two years.
    #(for example, year 2000: add all 12 monthly averages and divide by 12  to get average temperature in 2000. 
    #You can do the same thing for all the available years. Then you can calculate the one year difference as 1991-1990, 1992- 1991, etc)


#Create a new column to display the monthly average land temperatures in Fahrenheit (?F).
Temp.two <- Temp.data %>% na.omit %>% 
  select (year, Monthly.AverageTemp,Country) %>% 
  filter ( Country=='United States', year >= 1900 ) %>% 
  mutate(Temp_Fahrenheit= Monthly.AverageTemp  * 9/5 + 32 ) %>% 
  select (year, Temp_Fahrenheit)%>%
  group_by(year) %>% 
  summarise(Avg_land_temp=mean(Temp_Fahrenheit) ) 
Temp.two

#Calculate average land temperature by year and plot it. 
 ggplot(Temp.two,aes(year,Avg_land_temp)) + geom_line() + xlab("Year") + ylab ("Avg. Yearly Temp (Fahrenheit)") + ggtitle("Average Yearly Temperatures in the U.S. 1990-2013") + theme(plot.title=element_text(hjust=0.5))

#Calculate the one year difference of average land temperature by year and 
#provide the maximum difference (value) with corresponding two years.
difference_in_temp <- diff(Temp.two$Avg_land_temp)
temp3 <- cbind(Temp.two[1:113,],difference_in_temp)
which.max(temp3$difference_in_temp)
temp3[c(21,22),]



#Question 3C

#Download "CityTemp" data set at box.com. Find the difference between the maximum and the minimum temperatures 
#for each major city and report/visualize top 20 cities with maximum differences for the period since 1900.


#Read in data set.
City.data <- read.csv("CityTemp.csv", stringsAsFactors = FALSE )
# Check structure of dataset
head(City.data)
str(City.data)
 
#Date Cleaning
ymd<- ymd(City.data$Date)
mdy<- dmy(City.data$Date)
ymd[is.na(ymd)]<-mdy[is.na(ymd)]
City.data$Date<-ymd
City.data$Date

City.data$year<- substr(City.data$Date,1,4)
City.data$year <- as.numeric(City.data$year)

#Find the difference between the maximum and the minimum temperatures 
#for each major city 
City.one<- City.data %>% 
  select (year,City,Monthly.AverageTemp) %>% 
  na.omit() %>% 
  filter(year >= 1900) %>% 
  group_by(City)  %>% 
  summarise(temp_diff = max(Monthly.AverageTemp) -
              min(Monthly.AverageTemp)) %>% 
  arrange(desc(temp_diff))
City.one

#visualize top 20 cities with maximum differences for the period since 1900.
ggplot(City.one[1:20,], aes(City,temp_diff)) + geom_col() + theme(axis.text.x=element_text(angle=90, hjust=1)) + xlab("City") + ylab ("Range (Celcius)") + ggtitle("Top 20 temperature ranges by city") + theme(plot.title=element_text(hjust=0.5))



#Question 3D
#Compare the two graphs in (i) and (iii).


#Comparison: The bar graphs depicting the top 20 countries and cities, respectively, with the greatest range in temperatures recorded since 1900 are similar. 
#Of the top 20 countries, 6 recorded maximum differences above 40?C. Of the top 20 cities, 7 recorded maximum differences above 40?C. 
#Furthermore, no maximum difference was recorded below 30?C nor above 50?C for both cities and countries.
#However, the top 20 ranges recorded for cities cannot be used to determine the top 20 ranges recorded for countries.
#For example, the two highest maximum differences recorded for cities belong to Harbin and Changchun.
#Both of these cities reside in China, but China is not in the top 20 list of country temperature ranges.
#This discrepancy suggests that the temperatures recorded for "Countries" may not have necessarily been recorded in the "cities" that are connected to them from the other data set.
#Also, without an understanding of how the temperatures were recorded for each country we do not even know how representative the recorded temperatures are of the entire countries. 
#Overall, the maximum difference data for both countries and cities paints a picture of world temperatures as generally having ranges no larger than 50?C in any given geographical loaction.



    











