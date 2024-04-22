from matplotlib import pyplot as plt
from Helpers.helpers import *
import pandas as pd


if __name__ == '__main__':

    # Load data
    data = pd.read_csv("../Data/formatted_data.csv")

    # Plot time series
    for column in data.columns:
        if column not in {'DATE', 'Month', 'Quarter'}:
            plot_ts(data, column, "RawData", "RawData")

