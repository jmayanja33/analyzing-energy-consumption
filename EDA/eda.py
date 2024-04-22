from matplotlib import pyplot as plt
from Helpers.helpers import *
import pandas as pd


if __name__ == '__main__':

    # Load data
    data = pd.read_csv("../Data/formatted_data.csv")

    # Create figure
    plt.figure(figsize=(10, 8))
    plt.xlabel("Date")
    plt.ylabel("GDP")
    plt.title("United States GDP (1973-2022)")

    # Plot GDP
    x_data = format_as_datetime(data)
    y_data = data['GDP']
    plt.plot(x_data, y_data)

    plt.savefig("../Visualizations/RawData/TSPlots/gdp.png")

