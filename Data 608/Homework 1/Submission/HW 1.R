library(dplyr)
library(ggplot2)
dataset <- read.csv(file="https://raw.githubusercontent.com/jasonjgy2000/Cuny/master/Data%20608/Homework%201/Data/inc5000_data.csv",header = TRUE,sep=",")


# clean up Data

  # create dataset of complete data
  completeSet <- dataset[complete.cases(dataset),]

  # remove outliers from Employment Column
  # remove outliers. Using if any value is less than Q1 - 1.5IQR or greater than Q3 + 1.5IQR
  #find IQR
  iqr <- IQR(completeSet$Employees)
  q1 <- quantile(completeSet$Employees)[2]
  q3 <- quantile(completeSet$Employees)[4]
   
  # filter outliers out
  trimmedDataSet <- completeSet %>% filter(Employees > (q1 - 1.5*iqr),Employees < (q3 + 1.5*iqr))


  # remove Revenue outliers. 
  #find IQR
  iqr <- IQR(trimmedDataSet$Revenue)
  q1 <- quantile(trimmedDataSet$Revenue)[2]
  q3 <- quantile(trimmedDataSet$Revenue)[4]
  
  # filter outliers out
  trimmedDataSet <- trimmedDataSet %>% filter(Revenue > (q1 - 1.5*iqr),Revenue < (q3 + 1.5*iqr))


# Question 1
  companyInState <- count(trimmedDataSet,State)
  ggplot(companyInState, aes(x = State, y = n )) +geom_bar(stat = "identity",color="blue", fill=rgb(0.1,0.4,0.5,0.7))  + coord_flip()


# question 2
  # Find State with 3rd most companies
  item <- trimmedDataSet %>% count(State) %>% arrange(desc(n)) %>% slice(3) %>% select(State)

# Create dataset of industries and number of employees for the sate with the 3rd most companies
  companyData <- trimmedDataSet %>% filter(State == item[[1]])

# Find average employment by industry for companies in state
  companySateEmployeeData <- companyData %>% group_by(Industry) %>% summarise(averageEmployment = sum(Employees)/ length(Name))
  ggplot(companySateEmployeeData, aes(x = Industry, y = averageEmployment )) +geom_bar(stat = "identity")  + coord_flip()


# Question 3 
# Find which industries generate the most revenue per employee
  mostRevenue <- trimmedDataSet  %>% group_by(Industry) %>% summarise(revenuePerEmployee = sum(Revenue) /sum(Employees))
  ggplot(mostRevenue, aes(x = Industry, y = revenuePerEmployee )) +geom_bar(stat = "identity")  + coord_flip()


