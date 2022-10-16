# Download and unzip data from the web

fileURL <-
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

zipFile <- "./exdata_data_household_power_consumption.zip"

if (!file.exists(zipFile)) {
  download.file(fileURL, destfile = zipFile, mode = 'wb')
  unzip(zipfile = zipFile, exdir = getwd())
  date_download <- date()
}

# Read data

file_name <-
  substr(zipFile, nchar("./exdata_data_") + 1, nchar(zipFile) - 4)
file_name <- paste(file_name, '.txt', sep = '')
household_data <-
  read.csv(file_name,
           header = TRUE,
           sep = ';',
           na.strings = '?')

# subset from the dates 2007-02-01 and 2007-02-02
# Load the packages required to select data and work with dates

library(lubridate)
library(dplyr)

period <- c('01/02/2007', '02/02/2007')
data <- household_data %>%
  filter(as.Date(Date, "%d/%m/%Y") %in% as.Date(period, "%d/%m/%Y"))

## Convert Time to proper Time class
data$DateTime <- paste(data$Date, data$Time)

## Convert Date to proper date class
data$DateTime <-
  as.POSIXct(data$DateTime, "%d/%m/%Y %H:%M:%S", tz = "GMT")

# Check

table(data$Date)

# Generate Plot 1: Histogram of Global Active Power

hist(
  data$Global_active_power,
  col = 'red',
  main = 'Global Active Power',
  xlab = 'Global Active Power (kilowatts)'
)

dev.copy(png, file = 'plot1.png', height = 480, width = 480)

dev.off()
