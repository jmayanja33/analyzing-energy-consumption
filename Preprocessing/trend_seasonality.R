library(zoo,warn.conflicts=FALSE)
library(lubridate,warn.conflicts=FALSE)
library(mgcv,warn.conflicts=FALSE)
library(rugarch,warn.conflicts=FALSE)
library(forecast)
library(MLmetrics)

## Remove trend/seasonality for quarterly data with GDP ##

# Load data
data <- read.csv("../Data/formatted_data.csv", head=TRUE)
data$Formatted.Data <- as.Date(data$Formatted.Data, format="%B %d, %Y")
cols <- names(data)
num_cols <- length(names(data))

# Initialize data frame to hold spline model results
stationary_data <- head(data, -4)
# stationary_data_residuals <- data

  
# Iterate through each column and remove trend/seasonality with moving averages
for (i in 1:num_cols){
  column <- cols[i]
  
  if (column != "DATE" & column != "Month" & column != "Quarter" & column != "Formatted Data"){
    
    # Create time series for the data
    ts_column <- ts(data[column], start=c(1973), freq=4)
    
    # Remove seasonality from data
    decompose <- decompose(ts_column)
    ts_column_season_removed <- seasadj(decompose)
    
    # Difference resulting data by 4 quarters (1 year) to remove trend
    ts_column_trend_season_removed <- diff(ts_column_season_removed, differences=4)
    
    # Save data to dataframe
    stationary_data[column] <- unclass(ts_column_trend_season_removed)
    # stationary_data_residuals[column] <- residuals(ts)
  }
}


# Save detrended data to a csv file
write.csv(stationary_data, "../Data/MovingAverages/quarterly_moving_averages_data.csv", row.names=FALSE)
# write.csv(detrended_data_residuals, "../Data/Splines/splines_data_residuals.csv",
#           row.names=FALSE)


## Remove trend/seasonality for monthly data without GDP ##

# Load data
data <- read.csv("../Data/formatted_data_monthly.csv", head=TRUE)
data$Formatted.Data <- as.Date(data$Formatted.Data, format="%B %d, %Y")
cols <- names(data)
num_cols <- length(names(data))

# Initialize data frame to hold spline model results
stationary_data <- head(data, -12)
# stationary_data_residuals <- data


# Iterate through each column and remove trend/seasonality with moving averages
for (i in 1:num_cols){
  column <- cols[i]
  
  if (column != "DATE" & column != "Month" & column != "Quarter" & column != "Formatted Data"){
    
    # Create time series for the data
    ts_column <- ts(data[column], start=c(1973), freq=12)
    
    # Remove seasonality from data
    decompose <- decompose(ts_column)
    ts_column_season_removed <- seasadj(decompose)
    
    # Difference resulting data by 4 quarters (1 year) to remove trend
    ts_column_trend_season_removed <- diff(ts_column_season_removed, differences=12)
    
    # Save data to dataframe
    stationary_data[column] <- unclass(ts_column_trend_season_removed)
    # stationary_data_residuals[column] <- residuals(ts)
  }
}


# Save detrended data to a csv file
write.csv(stationary_data, "../Data/MovingAverages/monthly_moving_averages_data.csv", row.names=FALSE)
# write.csv(detrended_data_residuals, "../Data/Splines/splines_data_residuals.csv",
#          row.names=FALSE)