library(zoo,warn.conflicts=FALSE)
library(lubridate,warn.conflicts=FALSE)
library(mgcv,warn.conflicts=FALSE)
library(rugarch,warn.conflicts=FALSE)
library(forecast)
library(MLmetrics)
library(glue)

# Load data
data <- read.csv("../Data/formatted_data.csv", head=TRUE)
data$Formatted.Data <- as.Date(data$Formatted.Data, format="%B %d, %Y")
cols <- names(data)
num_cols <- length(names(data))

# Initialize data frame to hold spline model results
stationary_data <- head(data, -4)

  
# Iterate through each column and remove trend/seasonality with moving averages
for (i in 1:num_cols){
  column <- cols[i]
  
  if (column != "DATE" & column != "Month" & column != "Quarter" & column != "Formatted.Data"){
    
    # Create time series for the data
    ts_column <- ts(data[column], start=c(1973), freq=4)
    
    # Remove seasonality from data
    decompose <- decompose(ts_column)
    ts_column_season_removed <- seasadj(decompose)
    
    # Difference resulting data by 4 quarters (1 year) to remove trend
    ts_column_trend_season_removed <- diff(ts_column_season_removed, differences=4)
    
    # Save data to dataframe
    stationary_data[column] <- unclass(ts_column_trend_season_removed)
  }
}


# Save detrended data to a csv file
write.csv(stationary_data, "../Data/MovingAverages/quarterly_moving_averages_data.csv", row.names=FALSE)

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

# GDP
train.GDP <- ts(head(stationary_data$GDP, -12),start=c(1973), freq=12)
test.GDP <- ts(tail(stationary_data$GDP, 12), start=c(2021), freq=12)



# Merge training and test data
train_data <- cbind(train.Primary.Energy.Consumed.by.the.Residential.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector,
                    train.End.Use.Energy.Consumed.by.the.Residential.Sector,
                    train.Total.Energy.Consumed.by.the.Residential.Sector,
                    train.Primary.Energy.Consumed.by.the.Commercial.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector,
                    train.End.Use.Energy.Consumed.by.the.Commercial.Sector,
                    train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector,
                    train.Industrial.Sector.Electrical.System.Energy.Losses,
                    train.GDP)


# Fit VAR Model
var_model_select <- VARselect(train_data, lag.max=50)
var_model_select$selection

var_model <- VAR(train_data, p=14)

# Calculate residual correlation for each variable
gdp_resid <- resid(var_model$varresult$train.GDP)
resid1 <- resid(var_model$varresult$train.Primary.Energy.Consumed.by.the.Residential.Sector)
resid2 <- resid(var_model$varresult$train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector)
resid3 <- resid(var_model$varresult$train.End.Use.Energy.Consumed.by.the.Residential.Sector)
resid4 <- resid(var_model$varresult$train.Total.Energy.Consumed.by.the.Residential.Sector)
resid5 <- resid(var_model$varresult$train.Primary.Energy.Consumed.by.the.Commercial.Sector)
resid6 <- resid(var_model$varresult$train.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector)
resid7 <- resid(var_model$varresult$train.End.Use.Energy.Consumed.by.the.Commercial.Sector)
resid8 <- resid(var_model$varresult$train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector)
resid9 <- resid(var_model$varresult$train.Industrial.Sector.Electrical.System.Energy.Losses)

# Calculate correlations
corr1 <- cor(gdp_resid, resid1)
corr2 <- cor(gdp_resid, resid2)
corr3 <- cor(gdp_resid, resid3)
corr4 <- cor(gdp_resid, resid4)
corr5 <- cor(gdp_resid, resid5)
corr6 <- cor(gdp_resid, resid6)
corr7 <- cor(gdp_resid, resid7)
corr8 <- cor(gdp_resid, resid8)
corr9 <- cor(gdp_resid, resid9)
gdp_corr <- cor(gdp_resid, gdp_resid)


# Make residual-correlation matrix for each variable
resid_rows <- c("train.Primary.Energy.Consumed.by.the.Residential.Sector",
                "train.Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector",
                "train.End.Use.Energy.Consumed.by.the.Residential.Sector",
                "train.Total.Energy.Consumed.by.the.Residential.Sector",
                "train.Primary.Energy.Consumed.by.the.Commercial.Sector",
                "train.Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector",
                "train.End.Use.Energy.Consumed.by.the.Commercial.Sector",
                "train.Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector",
                "train.Industrial.Sector.Electrical.System.Energy.Losses",
                "train.GDP")

correlations <- c(corr1, corr2, corr3, corr4, corr5, corr6, corr7, corr8, corr9,
                  gdp_corr)

# Write data frame
corr_resid_matrix <- data.frame(
  Variables = resid_rows,
  Residual.Correlation.to.GDP = correlations
)

# Save Matrix
write.csv(corr_resid_matrix, glue("../Models/MovingAverages/Quarterly/VAR/var_resid_correlation.csv"))


