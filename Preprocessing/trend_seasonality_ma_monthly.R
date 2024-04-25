library(zoo,warn.conflicts=FALSE)
library(lubridate,warn.conflicts=FALSE)
library(mgcv,warn.conflicts=FALSE)
library(rugarch,warn.conflicts=FALSE)
library(forecast)
library(MLmetrics)
library(glue)
library(vars)

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
train.Total.Energy <- ts(head(stationary_data$Total.Energy.Consumed, -12),
                         start=c(1973), freq=12)
test.Total.Energy <- ts(tail(stationary_data$Total.Energy.Consumed, 12),
                        start=c(2021), freq=12)



# Merge training and test data
train_data <- cbind(train.Primary.Energy.Consumed.by.the.Residential.Sector, 
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector,
                    train.End.Use.Energy.Consumed.by.the.Residential.Sector,
                    train.Residential.Sector.Electrical.System.Energy.Losses,
                    train.Total.Energy.Consumed.by.the.Residential.Sector,
                    train.Primary.Energy.Consumed.by.the.Commercial.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector,
                    train.End.Use.Energy.Consumed.by.the.Commercial.Sector,
                    train.Commercial.Sector.Electrical.System.Energy.Losses,
                    train.Total.Energy.Consumed.by.the.Commercial.Sector,
                    train.Primary.Energy.Consumed.by.the.Industrial.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector,
                    train.End.Use.Energy.Consumed.by.the.Industrial.Sector,
                    train.Industrial.Sector.Electrical.System.Energy.Losses,
                    train.Total.Energy.Consumed.by.the.Industrial.Sector)

test_data <- cbind(test.Primary.Energy.Consumed.by.the.Residential.Sector,
                   test.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector,
                   test.End.Use.Energy.Consumed.by.the.Residential.Sector,
                   test.Residential.Sector.Electrical.System.Energy.Losses,
                   test.Total.Energy.Consumed.by.the.Residential.Sector,
                   test.Primary.Energy.Consumed.by.the.Commercial.Sector,
                   test.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector,
                   test.End.Use.Energy.Consumed.by.the.Commercial.Sector,
                   test.Commercial.Sector.Electrical.System.Energy.Losses,
                   test.Total.Energy.Consumed.by.the.Commercial.Sector,
                   test.Primary.Energy.Consumed.by.the.Industrial.Sector,
                   test.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector,
                   test.End.Use.Energy.Consumed.by.the.Industrial.Sector,
                   test.Industrial.Sector.Electrical.System.Energy.Losses,
                   test.Total.Energy.Consumed.by.the.Industrial.Sector)


# Fit VAR Model
var_model_select <- VARselect(train_data, lag.max=50)
var_model_select$selection

var_model <- VAR(train_data, p=10)
var_model_sum <- capture.output(summary(var_model))
writeLines(var_model_sum, glue("../Models/MovingAverages/Monthly/VAR/var_summary.txt"))


# Create linear model for total energy
total_model <- lm(Total.Energy.Consumed ~ Primary.Energy.Consumed.by.the.Residential.Sector + 
                    Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector + 
                    End.Use.Energy.Consumed.by.the.Residential.Sector + 
                    Residential.Sector.Electrical.System.Energy.Losses + 
                    Primary.Energy.Consumed.by.the.Commercial.Sector + 
                    Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector +
                    End.Use.Energy.Consumed.by.the.Commercial.Sector + 
                    Commercial.Sector.Electrical.System.Energy.Losses + 
                    Primary.Energy.Consumed.by.the.Industrial.Sector + 
                    Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector + 
                    Industrial.Sector.Electrical.System.Energy.Losses,
                  data=stationary_data
                  )
# Save to summary to .txt file
total_model_sum <- capture.output(summary(total_model))
writeLines(total_model_sum, glue("../Models/MovingAverages/Monthly/LM/total_energy_summary.txt"))


# Create linear model for total residential sector energy
residential_model <- lm(Total.Energy.Consumed.by.the.Residential.Sector ~ Primary.Energy.Consumed.by.the.Residential.Sector + 
                          Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector + 
                          End.Use.Energy.Consumed.by.the.Residential.Sector + 
                          Residential.Sector.Electrical.System.Energy.Losses + 
                          Primary.Energy.Consumed.by.the.Commercial.Sector + 
                          Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector +
                          End.Use.Energy.Consumed.by.the.Commercial.Sector + 
                          Commercial.Sector.Electrical.System.Energy.Losses + 
                          Primary.Energy.Consumed.by.the.Industrial.Sector + 
                          Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector + 
                          Industrial.Sector.Electrical.System.Energy.Losses +
                          Total.Energy.Consumed.by.the.Commercial.Sector +
                          Total.Energy.Consumed.by.the.Industrial.Sector,
                      data=stationary_data
)
# Save to summary to .txt file
residential_model_sum <- capture.output(summary(residential_model))
writeLines(residential_model_sum, glue("../Models/MovingAverages/Monthly/LM/residential_energy_summary.txt"))

# Create linear model for total residential sector energy
commercial_model <- lm(Total.Energy.Consumed.by.the.Commercial.Sector ~ Primary.Energy.Consumed.by.the.Residential.Sector + 
                         Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector + 
                         End.Use.Energy.Consumed.by.the.Residential.Sector + 
                         Residential.Sector.Electrical.System.Energy.Losses + 
                         Primary.Energy.Consumed.by.the.Commercial.Sector +
                         Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector +
                         End.Use.Energy.Consumed.by.the.Commercial.Sector + 
                         Commercial.Sector.Electrical.System.Energy.Losses + 
                         Primary.Energy.Consumed.by.the.Industrial.Sector + 
                         Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector +
                         Industrial.Sector.Electrical.System.Energy.Losses +
                         Total.Energy.Consumed.by.the.Residential.Sector +
                         Total.Energy.Consumed.by.the.Industrial.Sector,
                        data=stationary_data
)
# Save to summary to .txt file
commercial_model_sum <- capture.output(summary(commercial_model))
writeLines(commercial_model_sum, glue("../Models/MovingAverages/Monthly/LM/commercial_energy_summary.txt"))

# Create linear model for total residential sector energy
industrial_model <- lm(Total.Energy.Consumed.by.the.Industrial.Sector ~ Primary.Energy.Consumed.by.the.Residential.Sector + 
                         Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector + 
                         End.Use.Energy.Consumed.by.the.Residential.Sector + 
                         Residential.Sector.Electrical.System.Energy.Losses + 
                         Primary.Energy.Consumed.by.the.Commercial.Sector +
                         Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector +
                         End.Use.Energy.Consumed.by.the.Commercial.Sector + 
                         Commercial.Sector.Electrical.System.Energy.Losses + 
                         Primary.Energy.Consumed.by.the.Industrial.Sector + 
                         Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector +
                         Industrial.Sector.Electrical.System.Energy.Losses +
                         Total.Energy.Consumed.by.the.Residential.Sector +
                         Total.Energy.Consumed.by.the.Commercial.Sector,
                       data=stationary_data
)
# Save to summary to .txt file
industrial_model_sum <- capture.output(summary(industrial_model))
writeLines(industrial_model_sum, glue("../Models/MovingAverages/Monthly/LM/industrial_energy_summary.txt"))

# Run backwards stepwise regression on each model
step(lm(y~., data=var_model$varresult$train.Commercial.Sector.Electrical.System.Energy.Losses$model), 
                direction = 'backward', steps = 5)

