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
png("plot1.png", width = 480, height = 480)

# Generate a histogram of Global Active Power values
# - Convert the Global Active Power column to numeric for plotting
# - Use red bars to represent the distribution
# - Set the title of the plot as "Global Active Power"
# - Label the x-axis as "Global Active Power (kilowatts)"
hist(as.numeric(data_subset$Global_active_power), col = "red",
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# Close the graphics device and save the plot
dev.off()