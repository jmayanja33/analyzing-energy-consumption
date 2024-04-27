# Analyzing Energy Consumption in the US (Topic 2)

In this analysis, we explored the dynamics of energy consumption within the United States over a period from 1973 to 2022 (Topic 2). This time period, characterized by significant changes in technology, economic conditions, and energy policies, provides a good ground for understanding how energy consumption has evolved and what factors influence it. The core motivation behind this study was to gain insights into the factors driving energy consumption and to investigate the relationship between energy consumption trends and GDP. Through this exploration, we aimed to identify key characteristics of the energy consumption time series that contribute to its predictability and to analyze how energy consumption and economic growth are linked. Finally, we focused on examining any external factors that might influence energy consumption dynamics. 

This repository holds all code used for the project, which was mainly in python and R. View descriptions of the repository below.

## Dependencies

This repository requires python 3.10.x and all libraries specified in the requirements.txt file. R 4.2.x is also required.

## Code Description

### File Structure

The sub folders in each of the top level folders hold test results/plots for different kinds of data. To find the test result/visualization for a certain variable of a certain data type, follow the folder structure down to the raw files, then the file names will be named after the variable it represents.
For example to find the results of the Augmented Dickey Fuller test for the Monthly Residential Sector Electrical System Energy Losses variable transformed by the Moving Averages algorithm, this filepath would be followed:

StatisticalTests --> StationarityTest --> Monthly --> MovingAverages --> Raw Data --> DickeyFuller --> residential_sector_electrical_system_energy_losses_dickey_fuller.txt.

To find the ACF plot of this same variable, the path below would be followed:

Visualizations --> Monthly --> MovingAverages --> ACF --> residential_sector_electrical_system_energy_losses.png

### Folders

* `Data` --> Holds all data used for this project. The provided data were `Energy Consumption_r.csv` and `GDP-1.csv`. These wre transformed into monthly and quarterly csv files `formatted_data_mothly.csv` and `formatted_data.csv` using the scripts `format_data.py` and `format_monthly_data.py`. The `MovingAverages` folder holds these two csv files but transformed into stationary data.
* `EDA` --> Holds two scripts used during the early phases of this project to plot and cluster time series.
* `Helpers` --> Holds all helper functions and data structures which automates performing various tests and making various plots.
* `Models` --> Holds summary results of VAR models fit to examine variable correlation with Total Energy Consumed and GDP
* `Processing` --> Holds 2 R scripts which make the monthly and quarterly data stationary, and then fits a VAR model to each of those datasets. Also holds 2 python scripts which perform ADF Stationarity tests and Granger Causality tests on all variables.
* `Statistical Tests` --> Holds .txt files with results of all Granger Causality tests and ADF tests. `granger_causality_summary.txt` and `stationary_series_counts.txt` are files that provide full summaries of the tests performed on the whole dataset. The rest of the files provide results for a single variable.
* `Visualizations` --> Holds all Time Series plots, ACF plots, and PACF plots created in this project.