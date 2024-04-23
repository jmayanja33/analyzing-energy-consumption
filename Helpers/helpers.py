from datetime import datetime
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.holtwinters import ExponentialSmoothing
from matplotlib import pyplot as plt
import pandas as pd
import numpy as np
import pickle
import os


def make_directory(filepath, directory):
    """Function to make a directory if it does not already exist"""
    dir_path = os.path.join(filepath, directory)
    if not os.path.exists(dir_path):
        os.mkdir(dir_path)


def format_column_name(column, filename=True):
    """Function to remove spaces and periods from column names"""
    if filename:
        return column.replace(' ', '_').replace('.', '_').lower()
    else:
        return column.replace('.', ' ')


def format_as_datetime(df):
    """Function to format data as datetime for plotting"""
    datetimes = []

    for i in range(len(df)):
        year = df['DATE'][i]
        month = df['Month'][i]

        date = datetime.strptime(f"{month} {year}", "%B %Y")
        datetimes.append(date)

    return datetimes


def plot_ts(data, column, quarterly, directory, data_type):
    """Function to plot a time series"""
    print(f"Plotting time series for: {quarterly} - {directory} - {column}")

    # Create figure
    plt.figure(figsize=(10, 8))
    plt.xlabel("Date")
    plt.ylabel(format_column_name(column, filename=False))
    plt.title(f"USA {format_column_name(column, filename=False)} (1973-2022)")

    # Plot GDP
    x_data = format_as_datetime(data)
    y_data = data[column]
    plt.plot(x_data, y_data)

    # Save figure
    make_directory("../Visualizations", quarterly)
    make_directory(f"../Visualizations/{quarterly}", directory)
    make_directory(f"../Visualizations/{quarterly}/{directory}", "TSPlots")
    make_directory(f"../Visualizations/{quarterly}/{directory}/TSPlots", data_type)
    plt.savefig(f"../Visualizations/{quarterly}/{directory}/TSPlots/{data_type}/{format_column_name(column)}.png")
    plt.clf()


def acf(data, column, quarterly, directory, data_type, lags=None):
    """Function to plot an ACF plot"""
    print(f"Plotting ACF for: {quarterly} - {directory} - {column}")

    if lags is None:
        plot_acf(data, lags=24*4)
    else:
        plot_acf(data, lags=lags)
    plt.title(f"{format_column_name(column, filename=False)} ACF Plot")
    plt.xlabel("Lags")
    plt.ylabel("ACF Value")

    # Save figure
    make_directory("../Visualizations", quarterly)
    make_directory(f"../Visualizations/{quarterly}", directory)
    make_directory(f"../Visualizations/{quarterly}/{directory}", "ACF")
    make_directory(f"../Visualizations/{quarterly}/{directory}/ACF", data_type)
    plt.savefig(f"../Visualizations/{quarterly}/{directory}/ACF/{data_type}/{format_column_name(column)}.png")


def pacf(data, column, quarterly, directory, data_type, lags=None):
    """Function to plot a PACF plot"""
    print(f"Plotting ACF for: {quarterly} - {directory} - {column}")

    if lags is None:
        plot_pacf(data, lags=len(data)/10)
    else:
        plot_pacf(data, lags=lags)
    plt.title(f"{format_column_name(column, filename=False)} PACF Plot")
    plt.xlabel("Lags")
    plt.ylabel("PACF Value")

    # Save figure
    make_directory("../Visualizations", quarterly)
    make_directory(f"../Visualizations/{quarterly}", directory)
    make_directory(f"../Visualizations/{quarterly}/{directory}", "PACF")
    make_directory(f"../Visualizations/{quarterly}/{directory}/PACF", data_type)
    plt.savefig(f"../Visualizations/{quarterly}/{directory}/PACF/{data_type}/{format_column_name(column)}.png")


def dickey_fuller(data, column, quarterly, directory, data_type, significance=0.05, autolag="AIC"):
    """Function to perform a Dickey-Fuller test for stationarity and save the results to a file"""
    print(f"Performing Dickey-Fuller for: {quarterly} - {directory} - {column} ")

    # Perform a Dickey-Fuller test
    df_test = adfuller(data, autolag=autolag, regression="ct")

    # Determine null hypothesis
    p_value = df_test[1]
    if p_value < significance:
        null_hypothesis_decision = f"Since the p-value ({p_value}) is less than the significance value ({significance}), the null hypothesis IS rejected, so the series IS deemed stationary."
        stationary = True
    else:
        null_hypothesis_decision = f"Since the p-value ({p_value}) is not less than the significance value ({significance}), the null hypothesis IS NOT rejected, so the series IS NOT deemed stationary."
        stationary = False

    # Make directory for file
    make_directory("../StatisticalTests/StationarityTest", quarterly)
    make_directory(f"../StatisticalTests/StationarityTest/{quarterly}", directory)
    make_directory(f"../StatisticalTests/StationarityTest/{quarterly}/{directory}", data_type)
    make_directory(f"../StatisticalTests/StationarityTest/{quarterly}/{directory}/{data_type}/", "DickeyFuller")

    # Write results to a file
    df_test_file = open(f"../StatisticalTests/StationarityTest/{quarterly}/{directory}/{data_type}/DickeyFuller/{format_column_name(column)}_dickey_fuller.txt", "w")
    df_test_file.write(f"""DICKEY-FULLER TEST RESULTS:
    - Model: {directory}
    - Data Type: {data_type}
    - Time Series: {column}
    
    - Null Hypothesis: The series is stationary
    
    - ADF-Statistic: {df_test[0]}
    - P-Value: {p_value}
    - Number of Lags: {df_test[2]}
    - Number of Observations: {df_test[3]}
    - Critical Values: {df_test[4]}
    
** {null_hypothesis_decision} **

    """)

    df_test_file.close()

    return stationary


def count_stationary_series(stationary_series, non_stationary_series, quarterly, directory, data_type):
    """Function to count how many series are stationary. Results are saved in a .txt file"""
    print(f"Counting stationary series for: {quarterly} - {directory}")

    # Make directory for file
    make_directory(f"../StatisticalTests/StationarityTest/", quarterly)
    make_directory(f"../StatisticalTests/StationarityTest/{quarterly}", directory)
    make_directory(f"../StatisticalTests/StationarityTest/{quarterly}/{directory}", data_type)

    # Write file
    stationary_file = open(f"../StatisticalTests/StationarityTest/{quarterly}/{directory}/{data_type}/stationary_series_counts.txt", "w")
    stationary_file.write(f"""STATIONARY SERIES COUNT:

- Model: {directory}
- Data Type: {data_type}
- Monthly or Quarterly: {quarterly}

- Number of stationary time series: {len(stationary_series)}
- Stationary time series: {[format_column_name(i, filename=False) for i in stationary_series]} 

- Number of non-stationary time series: {len(non_stationary_series)}
- Non-stationary time series: {[format_column_name(i, filename=False) for i in non_stationary_series]}
"""
                          )
    stationary_file.close()

