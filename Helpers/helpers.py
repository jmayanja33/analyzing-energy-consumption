from datetime import datetime
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.stattools import grangercausalitytests
from matplotlib import pyplot as plt
# from sector_columns import *
import pandas as pd
import numpy as np
import pickle
import os


predictor_cols = [
    "Primary.Energy.Consumed.by.the.Residential.Sector",
    "Electricity.Sales.to.Ultimate.Customers.in.the.Residential.Sector",
    "End.Use.Energy.Consumed.by.the.Residential.Sector",
    "Residential.Sector.Electrical.System.Energy.Losses",
    "Total.Energy.Consumed.by.the.Residential.Sector",
    "Primary.Energy.Consumed.by.the.Commercial.Sector",
    "Electricity.Sales.to.Ultimate.Customers.in.the.Commercial.Sector",
    "End.Use.Energy.Consumed.by.the.Commercial.Sector",
    "Commercial.Sector.Electrical.System.Energy.Losses",
    "Total.Energy.Consumed.by.the.Commercial.Sector",
    "Primary.Energy.Consumed.by.the.Industrial.Sector",
    "Electricity.Sales.to.Ultimate.Customers.in.the.Industrial.Sector",
    "End.Use.Energy.Consumed.by.the.Industrial.Sector",
    "Industrial.Sector.Electrical.System.Energy.Losses",
    "Total.Energy.Consumed.by.the.Industrial.Sector"

]


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


def format_dir_name(column):
    """Function to format column name for directories"""
    return column.replace(' ', '').replace('.', '')


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


def granger_causality(data, quarterly, directory, data_type, target_cols, significance=0.05, threshold=0.8, maxlag=5):
    """Function to perform a granger causality test"""
    for target in target_cols:
        for column in predictor_cols:
            if column not in {'DATE', 'Month', 'Quarter', 'Formatted.Data'} and column != target:

                print(f"Performing granger causality test for: {quarterly} - {directory} - {format_column_name(column, filename=False)}")

                gc_test = grangercausalitytests(data[[target, column]], maxlag=maxlag)

                content = f"""GRANGER CAUSALITY TEST RESULTS

Null Hypothesis: {format_column_name(column, filename=False)} DOES NOT CAUSE Total Energy            
"""
                p_values = []

                # Add statistics to file
                for item in gc_test:
                    # Get and save P-Values
                    ssr_f_test_p = round(gc_test[item][0]['ssr_ftest'][1], 4)
                    ssr_chi2_p = round(gc_test[item][0]['ssr_chi2test'][1], 4)
                    lrtest_p = round(gc_test[item][0]['lrtest'][1], 4)
                    params_ftest_p = round(gc_test[item][0]['params_ftest'][1], 4)

                    p_values.append(ssr_f_test_p)
                    p_values.append(ssr_chi2_p)
                    p_values.append(lrtest_p)
                    p_values.append(params_ftest_p)

                    # Write to file
                    lag_content = f"""\n- Lag {item}:
    - SSR Based Test P-Value: {ssr_f_test_p}
    - SSR Based chi2 Test P-Value: {ssr_chi2_p}
    - Likelihood Ratio Test P-Value: {lrtest_p}
    - Parameter F Test P-Value: {params_ftest_p}"""

                    content += lag_content

                # Determine if null hypothesis is accepted or not
                num_significant = len([j for j in p_values if j < significance])
                significant_percent = round(num_significant / len(p_values), 4) * 100


                if significant_percent >= threshold:
                    hypothesis_content = f"""\nRESULT:
                
    {significant_percent} % of the P-Values are lower than the significance level of {significance}.
    This number is greater than/equal to the Causal Threshold set at {threshold*100} %.
    Therefore, the null hypothesis will be REJECTED, and it is concluded that {format_column_name(column, filename=False)} CAUSES {format_column_name(target, filename=False)}.
    """

                else:
                    hypothesis_content = f"""\nRESULT:

    {significant_percent} % of the P-Values are lower than the significance level of {significance}.
    This number is less than the Causal Threshold set at {threshold * 100}.
    Therefore, the null hypothesis will be ACCEPTED, and it is concluded that {format_column_name(column, filename=False)} DOES NOT CAUSE {format_column_name(target, filename=False)}. 
    """

                # Write to file
                content += hypothesis_content

                # Make directories to save test results
                make_directory(f"../StatisticalTests", "GCTest")
                make_directory(f"../StatisticalTests/GCTest", quarterly)
                make_directory(f"../StatisticalTests/GCTest/{quarterly}", directory)
                make_directory(f"../StatisticalTests/GCTest/{quarterly}/{directory}", data_type)
                make_directory(f"../StatisticalTests/GCTest/{quarterly}/{directory}/{data_type}", format_dir_name(target))

                # Write file
                gc_file = open(f"../StatisticalTests/GCTest/{quarterly}/{directory}/{data_type}/{format_dir_name(target)}/{format_column_name(column)}_granger_causality.txt", "w")
                gc_file.write(content)
                gc_file.close()
