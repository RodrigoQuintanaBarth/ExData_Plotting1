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

# CHANGING SUB_METERING CLASS TO NUMERIC

data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# CREATING A VARIABLE THAT TAKES EACH DAY AND TIME AS A SINGLE OBSERVATION AND CLEANING NA VALUES

data2 <- mutate(data, week.day = wday(Date,label = TRUE,abbr = TRUE),exact_time=ymd_hms(paste(Date,Time)))

data2 <- data2[complete.cases(data2),]

# PLOTTING SUB_METERING AS A FUNCTION OF TIME

png("plot3.png",width = 480, height = 480, units = "px")

with(data2, plot(Sub_metering_1~exact_time, type="n",xlab="",ylab = "Energy sub metering"))

with(data2, lines(Sub_metering_1~exact_time,lwd=0.5))

with(data2, lines(Sub_metering_2~exact_time, col="Red",lwd=0.5))

with(data2, lines(Sub_metering_3~exact_time, col="Blue", lwd=0.5))

legend("topright",col=c("Black","Red","Blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty = 1)

dev.off()
