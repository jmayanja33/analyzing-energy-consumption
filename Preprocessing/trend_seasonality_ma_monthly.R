library(zoo,warn.conflicts=FALSE)
library(lubridate,warn.conflicts=FALSE)
library(mgcv,warn.conflicts=FALSE)
library(rugarch,warn.conflicts=FALSE)
library(forecast)
library(MLmetrics)
library(glue)
library(vars)
library(car)

# Load data
data <- read.csv("../Data/formatted_data_monthly.csv", head=TRUE)
data$Formatted.Data <- as.Date(data$Formatted.Data, format="%B %d, %Y")
cols <- names(data)
num_cols <- length(names(data))
predictors <- cols[-c(1, 17, 18)]

# Initialize data frame to hold model results
stationary_data <- head(data, -12)


# Iterate through each column and remove trend/seasonality with moving averages
for (i in 1:num_cols){
  column <- cols[i]
  
  if (column != "DATE" & column != "Month" & column != "Quarter" & column != "Formatted.Data"){
    
    # Create time series for the data
    ts_column <- ts(data[column], start=c(1973), freq=12)
    
    # Remove seasonality from data
    decompose <- decompose(ts_column)
    ts_column_season_removed <- seasadj(decompose)
    
    
    # Difference resulting data by 4 quarters (1 year) to remove trend
    ts_column_trend_season_removed <- diff(ts_column_season_removed, differences=12)
    
    # Save data to dataframe
    stationary_data[column] <- unclass(ts_column_trend_season_removed)
    
  }
}


# Save detrended data to a csv file
write.csv(stationary_data, "../Data/MovingAverages/monthly_moving_averages_data.csv", row.names=FALSE)


# Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector
train.Primary.Energy.Consumed.by.the.Residential.Sector <- ts(head(stationary_data$Primary.Energy.Consumed.by.the.Residential.Sector, -12), 
                                                              start=c(1973), freq=12)
test.Primary.Energy.Consumed.by.the.Residential.Sector <- ts(tail(stationary_data$Primary.Energy.Consumed.by.the.Residential.Sector, 12), 
                                                             start=c(2021), freq=12)

# Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector
train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector <- ts(head(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector, -12), 
                                                                              start=c(1973), freq=12)
test.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector <- ts(tail(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector, 12), 
                                                                                                                                                 start=c(2021), freq=12)
# End.Use.Energy.Consumed.by.the.Residential.Sector
train.End.Use.Energy.Consumed.by.the.Residential.Sector <- ts(head(stationary_data$End.Use.Energy.Consumed.by.the.Residential.Sector, -12), 
                                                              start=c(1973), freq=12)
test.End.Use.Energy.Consumed.by.the.Residential.Sector <- ts(tail(stationary_data$End.Use.Energy.Consumed.by.the.Residential.Sector, 12), 
                                                             start=c(2021), freq=12)

# Residential.Sector.Electrical.System.Energy.Losses
train.Residential.Sector.Electrical.System.Energy.Losses <- ts(head(stationary_data$Residential.Sector.Electrical.System.Energy.Losses, -12), 
                                                               start=c(1973), freq=12)
test.Residential.Sector.Electrical.System.Energy.Losses <- ts(tail(stationary_data$Residential.Sector.Electrical.System.Energy.Losses, 12), 
                                                              start=c(2021), freq=12)

# Residential.Sector.Electrical.System.Energy.Losses
train.Residential.Sector.Electrical.System.Energy.Losses <- ts(head(stationary_data$Residential.Sector.Electrical.System.Energy.Losses, -12), 
                                                               start=c(1973), freq=12)
test.Residential.Sector.Electrical.System.Energy.Losses <- ts(tail(stationary_data$Residential.Sector.Electrical.System.Energy.Losses, 12), 
                                                              start=c(2021), freq=12)

# Total.Energy.Consumed.by.the.Residential.Sector
train.Total.Energy.Consumed.by.the.Residential.Sector <- ts(head(stationary_data$Total.Energy.Consumed.by.the.Residential.Sector, -12), 
                                                            start=c(1973), freq=12)
test.Total.Energy.Consumed.by.the.Residential.Sector <- ts(tail(stationary_data$Total.Energy.Consumed.by.the.Residential.Sector, 12), 
                                                           start=c(2021), freq=12)

# Primary.Energy.Consumed.by.the.Commercial.Sector
train.Primary.Energy.Consumed.by.the.Commercial.Sector <- ts(head(stationary_data$Primary.Energy.Consumed.by.the.Commercial.Sector, -12), 
                                                             start=c(1973), freq=12)
test.Primary.Energy.Consumed.by.the.Commercial.Sector <- ts(tail(stationary_data$Primary.Energy.Consumed.by.the.Commercial.Sector, 12), 
                                                            start=c(2021), freq=12)

# Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector
train.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector <- ts(head(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector, -12), 
                                                                             start=c(1973), freq=12)
test.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector <- ts(tail(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector, 12), 
                                                                            start=c(2021), freq=12)

# End.Use.Energy.Consumed.by.the.Commercial.Sector
train.End.Use.Energy.Consumed.by.the.Commercial.Sector <- ts(head(stationary_data$End.Use.Energy.Consumed.by.the.Commercial.Sector, -12),
                                                             start=c(1973), freq=12)
test.End.Use.Energy.Consumed.by.the.Commercial.Sector <- ts(tail(stationary_data$End.Use.Energy.Consumed.by.the.Commercial.Sector, 12),
                                                            start=c(2021), freq=12)

# Commercial.Sector.Electrical.System.Energy.Losses
train.Commercial.Sector.Electrical.System.Energy.Losses <- ts(head(stationary_data$Commercial.Sector.Electrical.System.Energy.Losses, -12),
                                                              start=c(1973), freq=12)
test.Commercial.Sector.Electrical.System.Energy.Losses <- ts(tail(stationary_data$Commercial.Sector.Electrical.System.Energy.Losses, 12),
                                                             start=c(2021), freq=12)

# Total.Energy.Consumed.by.the.Commercial.Sector
train.Total.Energy.Consumed.by.the.Commercial.Sector <- ts(head(stationary_data$Total.Energy.Consumed.by.the.Commercial.Sector, -12),
                                                           start=c(1973), freq=12)
test.Total.Energy.Consumed.by.the.Commercial.Sector <- ts(tail(stationary_data$Total.Energy.Consumed.by.the.Commercial.Sector, 12),
                                                          start=c(2021), freq=12)

# Primary.Energy.Consumed.by.the.Industrial.Sector
train.Primary.Energy.Consumed.by.the.Industrial.Sector <- ts(head(stationary_data$Primary.Energy.Consumed.by.the.Industrial.Sector, -12),
                                                             start=c(1973), freq=12)
test.Primary.Energy.Consumed.by.the.Industrial.Sector <- ts(tail(stationary_data$Primary.Energy.Consumed.by.the.Industrial.Sector, 12),
                                                            start=c(2021), freq=12)

# Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector
train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector <- ts(head(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector, -12),
                                                                             start=c(1973), freq=12)
test.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector <- ts(tail(stationary_data$Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector, 12),
                                                                            start=c(2021), freq=12)

# End.Use.Energy.Consumed.by.the.Industrial.Sector
train.End.Use.Energy.Consumed.by.the.Industrial.Sector <- ts(head(stationary_data$End.Use.Energy.Consumed.by.the.Industrial.Sector, -12),
                                                             start=c(1973), freq=12)
test.End.Use.Energy.Consumed.by.the.Industrial.Sector <- ts(tail(stationary_data$End.Use.Energy.Consumed.by.the.Industrial.Sector, 12),
                                                            start=c(2021), freq=12)

# Industrial.Sector.Electrical.System.Energy.Losses
train.Industrial.Sector.Electrical.System.Energy.Losses <- ts(head(stationary_data$Industrial.Sector.Electrical.System.Energy.Losses, -12),
                                                              start=c(1973), freq=12)
test.Industrial.Sector.Electrical.System.Energy.Losses <- ts(tail(stationary_data$Industrial.Sector.Electrical.System.Energy.Losses, 12),
                                                             start=c(2021), freq=12)

# Total.Energy.Consumed.by.the.Industrial.Sector
train.Total.Energy.Consumed.by.the.Industrial.Sector <- ts(head(stationary_data$Total.Energy.Consumed.by.the.Industrial.Sector, -12),
                                                           start=c(1973), freq=12)
test.Total.Energy.Consumed.by.the.Industrial.Sector <- ts(tail(stationary_data$Total.Energy.Consumed.by.the.Industrial.Sector, 12),
                                                          start=c(2021), freq=12)

# Total.Energy
train.Total.Energy.Consumed <- ts(head(stationary_data$Total.Energy.Consumed, -12),
                                  start=c(1973), freq=12)
test.Total.Energy.Consumed <- ts(tail(stationary_data$Total.Energy.Consumed, 12),
                                 start=c(2021), freq=12)



# Merge training and test data
train_data <- cbind(train.Commercial.Sector.Electrical.System.Energy.Losses,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector,
                    train.End.Use.Energy.Consumed.by.the.Residential.Sector,
                    train.Industrial.Sector.Electrical.System.Energy.Losses,
                    train.Residential.Sector.Electrical.System.Energy.Losses,
                    train.Total.Energy.Consumed.by.the.Commercial.Sector,
                    train.Total.Energy.Consumed.by.the.Industrial.Sector,
                    train.Total.Energy.Consumed.by.the.Residential.Sector,
                    train.Total.Energy.Consumed
                    )

# Fit VAR Model
var_model_select <- VARselect(train_data, lag.max=20)
var_model_select$selection

var_model <- VAR(train_data, p=13)
var_model_sum <- capture.output(summary(var_model))
writeLines(var_model_sum, glue("../Models/MovingAverages/Monthly/VAR/var_summary.txt"))


