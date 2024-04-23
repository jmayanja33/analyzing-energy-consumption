library(zoo,warn.conflicts=FALSE)
library(lubridate,warn.conflicts=FALSE)
library(mgcv,warn.conflicts=FALSE)
library(rugarch,warn.conflicts=FALSE)
library(forecast)
library(MLmetrics)

# Load data
data <- read.csv("../Data/formatted_data.csv", head=TRUE)
data$Formatted.Data <- as.Date(data$Formatted.Data, format="%B %d, %Y")
cols <- names(data)
num_cols <- length(names(data))

# Initialize dataframe to hold spline model results
detrended_data <- data
detrended_data_residuals <- data


  
# Iterate through each column and detrend each with a splines model
for (i in 1:num_cols){
  column <- cols[i]
  
  if (column != "DATE" & column != "Month" & column != "Quarter" & column != "Formatted Data"){
    
    # Create time series for the data
    ts_column <- ts(data[column], start=c(1973), freq=4)
    
    # Define time points
    time_pts = c(1:length(ts_column))
    time_pts = c(time_pts - min(time_pts))/max(time_pts)
    
    # Fit data with splines and monthly seasonality
    # quarter <- as.factor(format(data$Formatted.Data,"%B"))
    # splines_model <- gam(column ~ s(time_pts) + quarter, data=data)
    splines_model <- gam(ts_column~s(time_pts))
    
    # Save data to dataframe
    detrended_data[column] <- splines_model$fitted.values
    detrended_data_residuals[column] <- splines_model$residuals
  }
}

data_ts <- ts(data$Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector, 
              start=c(1973), freq=4)

detrend_ts <- ts(detrended_data$Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector, 
                 start=c(1973), freq=4)

residual_ts <- ts(detrended_data_residuals$Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector,
                  start=c(1973), freq=4)

ts.plot(data_ts, col="blue")
lines(detrend_ts, col="orange")

ts.plot(residual_ts)
acf(residual_ts)

acf(detrend_ts, lag.max=24*4)

# Save detrended data to a csv file
write.csv(detrended_data, "../Data/Splines/splines_data.csv", row.names=FALSE)
write.csv(detrended_data_residuals, "../Data/Splines/splines_data_residuals.csv",
          row.names=FALSE)
