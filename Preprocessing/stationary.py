import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from Helpers.helpers import *


if __name__ == '__main__':

    # Load data
    data = pd.read_csv("../Data/formatted_data.csv")

    for column in data.columns:
        if column not in {'DATE', 'Month', 'Quarter'}:
            # Plot ACF
            acf(data[column], title=f"{column} ACF Plot", filename=column, directory="RawData")

            # Perform Dickey-Fuller test
            stationary = dickey_fuller(data[column], column, directory="RawData")

            # If GDP is stationary, make the data stationary

    pass
