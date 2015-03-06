## Loading the dataset
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataset_url, "eletricpower.zip")
unzip("eletricpower.zip", exdir = "data")

## Reading the data
tab5rows <- read.table("data/household_power_consumption.txt", sep=";", header = TRUE, nrows = 5)
classes <- sapply(tab5rows, class)
data = read.csv("data/household_power_consumption.txt", 
                sep=";", na.strings = "?",
                header = TRUE,
                colClasses = c(classes)
)

##Converting field Date from factor to date
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

## Subsetting just the observations needed in a new dataframe.
df <- data[data$Date >= '2007-02-01' & data$Date <= '2007-02-02',]

## Creating a new colum for timestamp (Date + Time)
df <- transform(df, timestamp=paste(Date, Time, sep = " "))
##Tranform timestamp from character to Date(POSIXlt)
##Obs: "format" may vary by R locale/language
#Here the data are show as YYYY-MM-DD. Ex: '2007-02-01'
df$timestamp <- strptime(df$timestamp, format="%Y-%m-%d %H:%M:%S")

# Open the PNG graphics device to create a file with 
# a width of 480 pixels and a height of 480 pixels
png(filename = "plot3.png",
    width = 480, height = 480, units = "px")

#Plotting:
# create the graph with axes, titles, etc., but without plotting the points
plot(df$timestamp, df$Sub_metering_1,  
     type = "n",
     ylab = "Energy sub metering",
     xlab = "")
#Plotting metering 1
lines(df$timestamp,
      df$Sub_metering_1,
      col = "black")
#Plotting metering 2
lines(df$timestamp,
      df$Sub_metering_2,
      col = "red")
#Plotting metering 3
lines(df$timestamp,
      df$Sub_metering_3,
      col = "blue")
#Adding the legend
legend("topright", col = c("black", "red", "blue"), legend = colnames(df[7:9]),
       lty=c(1,1,1))
#Obs: Since i'm running in a Portuguese environment, days at .png are in portuguese
# So, you should see "qui", "sex", "sáb" besides "thu", "fri", "sat"

#Closing the device
dev.off()
