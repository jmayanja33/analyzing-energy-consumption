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
        if column not in {'DATE', 'Month', 'Quarter', 'Formatted Data'}:
            # Plot data
            plot_ts(data, column, directory, data_type)

            # Plot ACF
            acf(data[column], column, directory, data_type)

            # Plot PACF
            pacf(data[column], column, directory, data_type)

            # Perform Dickey-Fuller test
            stationary = dickey_fuller(data[column], format_column_name(column), directory, data_type)

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
    splines = pd.read_csv("../Data/Splines/splines_data.csv")
    splines_resid = pd.read_csv("../Data/Splines/splines_data_residuals.csv")

    # Evaluate stationarity on raw data
    test_stationarity(data, "RawData", "RawData")
    test_stationarity(splines, "Splines", "RawData")
    test_stationarity(splines_resid, "Splines", "Residuals")



