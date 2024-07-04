#load relevant packages:
if (!require("dplyr")) install.packages("dplyr")
if (!require("here")) install.packages("here")
if (!require("lubridate")) install.packages("lubridate")
library(dplyr)
library(lubridate)
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
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data <- data %>%
  mutate(DateTime = paste(Date, Time))
data <- data %>%
  mutate(DateTime = as.POSIXct(DateTime, format = "%Y-%m-%d %H:%M:%S"))

#Select only data that is between x and x
subset_data <- data[data$Date >= "2007-02-01" & data$Date <= "2007-02-02", ]

# Open png plotting device
png(file = "plot3.png", width = 480, height = 480)

#create multiple line plot

matplot(subset_data$DateTime, 
        cbind(subset_data$Sub_metering_1, subset_data$Sub_metering_2, subset_data$Sub_metering_3),
        type = "l", lty = 1,
        col = c("black", "red", "blue"),
        ylab = "Energy sub metering",
        xlab = "",
        xaxt = "n")

# Determine the positions of the desired tick marks
dates <- as.Date(subset_data$DateTime)
tick_positions <- sapply(c("Thu", "Fri"), function(day) {
  which(weekdays(dates, abbreviate = TRUE) == day)[1]
})

# Add the position for "Sat" at the end of the data
tick_positions <- c(tick_positions, length(dates))

# Add custom x-axis with the specified ticks
axis(1, at = subset_data$DateTime[tick_positions], labels = c("Thu", "Fri", "Sat"))

#add legend:
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

#turn graphic device off
dev.off()