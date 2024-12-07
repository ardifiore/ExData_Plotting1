library(data.table)

# Estimate memory usage
rows <- 2075259
cols <- 9
memory <- rows * cols * 8 / (1024^2) # Approx. memory in MB
print(memory)

# Load and subset the dataset
data <- fread("household_power_consumption.txt", na.strings = "?", sep = ";")
data_subset <- data[Date %in% c("1/2/2007", "2/2/2007")]

# Add DateTime column to subsetted dataset
data_subset[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Save the plot as a PNG graphics device
png("plot3.png", width = 480, height = 480)

# Multi-line plot for energy sub-metering over time
# - Add custom x-axis labels
plot(data_subset$DateTime, as.numeric(data_subset$Sub_metering_1), type = "l",
     xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(data_subset$DateTime, as.numeric(data_subset$Sub_metering_2), col = "red")
lines(data_subset$DateTime, as.numeric(data_subset$Sub_metering_3), col = "blue")

# Add x-axis with days of the week
# - Extend the range of DateTime by one day to ensure Saturday is included
start_date <- as.POSIXct(format(min(data_subset$DateTime), "%Y-%m-%d"))
end_date <- as.POSIXct(format(max(data_subset$DateTime), "%Y-%m-%d")) + 86400
axis_ticks <- seq(start_date, end_date, by = "day")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))

# Add a legend 
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Close the graphics device and save the plot
dev.off()