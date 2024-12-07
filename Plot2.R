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
png("plot2.png", width = 480, height = 480)

# Line plot of Global Active Power over time
# - Suppress default x-axis and add custom day labels
plot(data_subset$DateTime, as.numeric(data_subset$Global_active_power), type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)", xaxt = "n")

# Add x-axis with days of the week
# - Extend the range of DateTime by one day to ensure Saturday is included
start_date <- as.POSIXct(format(min(data_subset$DateTime), "%Y-%m-%d"))
end_date <- as.POSIXct(format(max(data_subset$DateTime), "%Y-%m-%d")) + 86400
axis_ticks <- seq(start_date, end_date, by = "day")
axis(1, at = axis_ticks, labels = weekdays(axis_ticks, abbreviate = TRUE))

# Close the graphics device and save the plot
dev.off()