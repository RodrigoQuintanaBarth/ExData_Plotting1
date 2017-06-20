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

# PLOTTING

par(mfrow=c(1,1))

png("plot1.png",width = 480, height = 480, units = "px")

hist(data$Global_active_power, col="red",xlab = "Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")

dev.off()