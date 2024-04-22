import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from Helpers.helpers import *


def test_stationarity(data, directory, data_type):
    """Function to evaluate which columns in the data are stationary"""

    # Initialize lists
    stationary_series = []
    non_stationary_series = []

    # Plot ACFs and perform Dickey-Fuller tests for all columns in the data
    for column in data.columns:
        if column not in {'DATE', 'Month', 'Quarter'}:
            # Plot ACF
            acf(data[column], column, directory, data_type)

            # Plot PACF
            pacf(data[column], column, directory, data_type)

            # Perform Dickey-Fuller test
            stationary = dickey_fuller(data[column], column, directory, data_type)

            # If GDP is stationary, make the data stationary
            if stationary:
                stationary_series.append(column)
            else:
                non_stationary_series.append(column)

    # Record number of stationary time series in the data
    count_stationary_series(stationary_series, non_stationary_series, directory, data_type)

    return stationary_series, non_stationary_series


# Main to run
if __name__ == '__main__':

    # Load data
    data = pd.read_csv("../Data/formatted_data.csv")

    # Evaluate stationarity on raw data
    stationary_series, non_stationary_series = test_stationarity(data, "RawData", "RawData")

    # Detrend each time series
    detrended_data = data
    for series in non_stationary_series:

        # Use Holt-Winters to detrend data
        detrended_data[series] = holt_winters(data, series, "RawData")

    # Evaluate stationarity
    stationary_series, non_stationary_series = test_stationarity(detrended_data, "HoltWinters", "RawData")


