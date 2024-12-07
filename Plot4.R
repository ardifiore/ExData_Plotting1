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
png("plot4.png", width = 480, height = 480)

# Set a 2x2 plotting layout
par(mfrow = c(2, 2))

# Top-left: Line plot of Global Active Power
plot(data_subset$DateTime, as.numeric(data_subset$Global_active_power), type = "l",
     xlab = "", ylab = "Global Active Power", xaxt = "n")
start_date <- as.POSIXct(format(min(data_subset$DateTime), "%Y-%m-%d"))
end_date <- as.POSIXct(format(max(data_subset$DateTime), "%Y-%m-%d")) + 86400
axis_ticks <- seq(start_date, end_date, by = "day")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))

# Top-right: Line plot of Voltage
plot(data_subset$DateTime, as.numeric(data_subset$Voltage), type = "l",
     xlab = "datetime", ylab = "Voltage", xaxt = "n")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))

# Bottom-left: Multi-line plot for energy sub-metering
plot(data_subset$DateTime, as.numeric(data_subset$Sub_metering_1), type = "l",
     xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(data_subset$DateTime, as.numeric(data_subset$Sub_metering_2), col = "red")
lines(data_subset$DateTime, as.numeric(data_subset$Sub_metering_3), col = "blue")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# Bottom-right: Line plot of Global Reactive Power
plot(data_subset$DateTime, as.numeric(data_subset$Global_reactive_power), type = "l",
     xlab = "datetime", ylab = "Global Reactive Power", xaxt = "n")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))

# Close the graphics device and save the plot
dev.off()