# SETTING UP THE ENVIRONMENT

if (!isTRUE(require(lubridate))) { install.packages("lubridate")}
if (!isTRUE(require(dplyr))) { install.packages("dplyr")}

library(lubridate)
library(dplyr)

if(!dir.exists("./expgraphweek1")){ dir.create("./expgraphweek1") }

if(!file.exists("./expgraphweek1/expgraphweek1.zip")) { 
  
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile = "./expgraphweek1/expgraphweek1.zip")
  
}

unzip("./expgraphweek1/expgraphweek1.zip", exdir = "expgraphweek1") 

#READING DATA INTO R

data <- read.table("./expgraphweek1/household_power_consumption.txt" , sep=";",header=TRUE, stringsAsFactors=FALSE, dec=".")

# GIVING PROPER CLASSES TO DATE AND TIME VARIABLES

data$Date <- dmy(data$Date)

data$Time <- hms(data$Time)


# SUBSETTING RELEVANT DAYS

data <- subset(data,Date =="2007-02-01"| Date =="2007-02-02")

# CHANGING GLOBAL ACTIVE POWER CLASS TO NUMERIC

data$Global_active_power <- as.numeric(data$Global_active_power)

# CREATING A VARIABLE THAT TAKES EACH DAY AND TIME AS A SINGLE OBSERVATION AND CLEANING NA VALUES

data2 <- mutate(data, week.day = wday(Date,label = TRUE,abbr = TRUE),exact_time=ymd_hms(paste(Date,Time)))

data2 <- data2[complete.cases(data2),]

# PLOTTING GLOBAL ACTIVE POWER AS A FUNCTION OF TIME

png("plot2.png",width = 480, height = 480, units = "px")

with(data2, plot(exact_time,Global_active_power, type="n",xlab="",ylab = "Global Active Power (Kilowatts)"))

with(data2, lines(exact_time,Global_active_power, lwd=0.5))

dev.off()