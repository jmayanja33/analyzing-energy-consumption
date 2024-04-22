from datetime import datetime
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.stattools import adfuller
from matplotlib import pyplot as plt

residential_cols = [
    "Primary Energy Consumed by the Residential Sector",
    "Electricity Sales to Ultimate Customers in the Residential Sector",
    "End-Use Energy Consumed by the Residential Sector",
    "Residential Sector Electrical System Energy Losses",
    "Total Energy Consumed by the Residential Sector"
]

commercial_cols = [
    "Primary Energy Consumed by the Commercial Sector",
    "Electricity Sales to Ultimate Customers in the Commercial Sector",
    "End-Use Energy Consumed by the Commercial Sector",
    "Commercial Sector Electrical System Energy Losses",
    "Total Energy Consumed by the Commercial Sector"
]

industrial_cols = [
    "Primary Energy Consumed by the Industrial Sector",
    "Electricity Sales to Ultimate Customers in the Industrial Sector",
    "End-Use Energy Consumed by the Industrial Sector",
    "Industrial Sector Electrical System Energy Losses",
    "Total Energy Consumed by the Industrial Sector"
]


def format_as_datetime(df):
    """Function to format data as datetime for plotting"""
    datetimes = []

    for i in range(len(df)):
        year = df['DATE'][i]
        month = df['Month'][i]

        date = datetime.strptime(f"{month} {year}", "%B %Y")
        datetimes.append(date)

    return datetimes


def acf(data, title, filename, directory, lags=None):
    """Function to plot an ACF plot"""
    if lags is None:
        plot_acf(data, lags=len(data)/10)
    else:
        plot_acf(data, lags=lags)
    plt.title(title)
    plt.xlabel("Lags")
    plt.ylabel("ACF Value")

    plt.savefig(f"../Visualizations/{directory}/ACF/{filename.replace(' ', '_').lower()}.png")


def dickey_fuller(data, filename, directory, significance=0.05, autolag="AIC"):
    """Function to perform a Dickey-Fuller test for stationarity and save the results to a file"""

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

    # Write results to a file
    df_test_file = open(f"../StatisticalTests/StationarityTest/{directory}/DickeyFuller/{filename.replace(' ', '_').lower()}_dickey_fuller.txt", "w")
    df_test_file.write(f"""DICKEY-FULLER TEST RESULTS:
    
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

