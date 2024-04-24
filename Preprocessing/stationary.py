import pandas as pd
from Helpers.helpers import *


def test_stationarity(data, quarterly, directory, data_type):
    """Function to evaluate which columns in the data are stationary"""

    # Initialize lists
    stationary_series = []
    non_stationary_series = []

    # Plot ACFs and perform Dickey-Fuller tests for all columns in the data
    for column in data.columns:
        if column not in {'DATE', 'Month', 'Quarter', 'Formatted Data'}:
            # Plot data
            plot_ts(data, column, quarterly, directory, data_type)

            # Plot ACF
            acf(data[column], column, quarterly, directory, data_type)

            # Plot PACF
            pacf(data[column], column, quarterly, directory, data_type)

            # Perform Dickey-Fuller test
            stationary = dickey_fuller(data[column], format_column_name(column), quarterly, directory, data_type)

            # If GDP is stationary, make the data stationary
            if stationary:
                stationary_series.append(column)
            else:
                non_stationary_series.append(column)

    # Record number of stationary time series in the data
    count_stationary_series(stationary_series, non_stationary_series, quarterly, directory, data_type)

    return stationary_series, non_stationary_series


# Main to run
if __name__ == '__main__':

    # Load data
    quarterly_data = pd.read_csv("../Data/formatted_data.csv")
    monthly_data = pd.read_csv("../Data/formatted_data_monthly.csv")
    quarterly_ma = pd.read_csv("../Data/MovingAverages/quarterly_moving_averages_data.csv")
    monthly_ma = pd.read_csv("../Data/MovingAverages/monthly_moving_averages_data.csv")

    # Evaluate stationarity on raw data
    test_stationarity(quarterly_data, "Quarterly", "RawData", "RawData")
    test_stationarity(quarterly_ma, "Quarterly", "MovingAverages", "RawData")
    test_stationarity(monthly_data, "Monthly", "RawData", "RawData")
    test_stationarity(monthly_ma, "Monthly", "MovingAverages", "RawData")

