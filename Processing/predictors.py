"""
Script to perform Granger Causality tests between two variables. Results will be saved in the
StatisticalTests/GCTest Folder.
"""

import pandas as pd
from Helpers.helpers import *


if __name__ == '__main__':

    # Load data
    quarterly_ma = pd.read_csv("../Data/MovingAverages/quarterly_moving_averages_data.csv")
    monthly_ma = pd.read_csv("../Data/MovingAverages/monthly_moving_averages_data.csv")

    granger_causality(monthly_ma, "Monthly", "MovingAverages", "RawData",
                      target_cols=["Total.Energy.Consumed"])

    granger_causality(quarterly_ma, "Quarterly", "MovingAverages", "RawData",
                      target_cols=["Total.Energy.Consumed", "GDP"])
