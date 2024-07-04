#load relevant packages:
if (!require("dplyr")) install.packages("dplyr")
if (!require("here")) install.packages("here")
library(dplyr)
library(here)

#download .zip file from the web:
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest_dir <- "EDA_assignment1"
dest_file <- file.path(dest_dir, "data.zip")
data_file <- file.path(dest_dir, "household_power_consumption.txt")

# Create directory if it doesn't exist
if(!dir.exists(dest_dir)) dir.create(dest_dir)

# Download and unzip data
download.file(url, dest_file, method = "libcurl")
unzip(dest_file, exdir = dest_dir)

#read text data file into R
data_file <- "./EDA_assignment1/household_power_consumption.txt"
      
#check size of file:
file.info(data_file)
      
data <- read.table(data_file, header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)
      
#explore data to get an overview of variables:
head(data)
str(data)
summary(data)
      
#Convert date and time variables to correct format
  #combine date and time to one variable DateTime
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data <- data %>%
  mutate(DateTime = paste(Date, Time))
data <- data %>%
  mutate(DateTime = as.POSIXct(DateTime, format = "%Y-%m-%d %H:%M:%S"))

#Select only data that is between x and x
subset_data <- data[data$Date >= "2007-02-01" & data$Date <= "2007-02-02", ]

#Create plot 1:
png(filename = "plot1.png", width = 480, height = 480)
hist(subset_data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowats)")
dev.off()