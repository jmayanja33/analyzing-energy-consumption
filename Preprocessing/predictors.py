import pandas as pd
from Helpers.helpers import *


if __name__ == '__main__':

    # Load data
    quarterly_ma = pd.read_csv("../Data/MovingAverages/quarterly_moving_averages_data.csv")
    monthly_ma = pd.read_csv("../Data/MovingAverages/monthly_moving_averages_data.csv")

    granger_causality(monthly_ma, "Monthly", "MovingAverages", "RawData",
                      target_cols=["Total.Energy", "Total.Energy.Consumed.by.the.Residential.Sector",
                                   "Total.Energy.Consumed.by.the.Commercial.Sector",
                                   "Total.Energy.Consumed.by.the.Industrial.Sector"])

    granger_causality(quarterly_ma, "Quarterly", "MovingAverages", "RawData",
                      target_cols=["Total.Energy", "GDP", "Total.Energy.Consumed.by.the.Residential.Sector",
                                   "Total.Energy.Consumed.by.the.Commercial.Sector",
                                   "Total.Energy.Consumed.by.the.Industrial.Sector"])
