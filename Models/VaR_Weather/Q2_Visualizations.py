import pandas as pd
import numpy as np
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.api import VAR
from statsmodels.tsa.seasonal import seasonal_decompose
import matplotlib.pyplot as plt

# Load the data
data = pd.read_csv("./Data/formatted_data.csv")
data['DATE'] = data['Formatted Data'].astype(str) + data['Month']
data.set_index('DATE', inplace=True)
data.index.freq = 'Q' 

# Step 1: Calculate 'Total Energy Consumed' by summing all relevant columns
energy_cols = [col for col in data.columns if 'Total Energy Consumed' in col]
data['Total Energy Consumed'] = data[energy_cols].sum(axis=1)

# Step 2: Decompose 'Total Energy Consumed' and GDP into trend, seasonality, and residuals
decompose_cols = energy_cols + ['GDP']
decomposed = {col: seasonal_decompose(data[col], model='additive',period=4)  for col in decompose_cols}
for col, dec in decomposed.items():
    data[f'{col} Trend'] = dec.trend
    data[f'{col} Seasonal'] = dec.seasonal
    data[f'{col} Residual'] = dec.resid
    
decompose_cols = ['Total Energy Consumed', 'GDP']
decomposed = {col: seasonal_decompose(data[col], model='additive', period = 4) for col in decompose_cols if col in data.columns}

# Plotting the decomposition
for col, dec in decomposed.items():
    plt.figure(figsize=(14, 8))
    plt.subplot(411)
    plt.plot(data[col], label='Original', color='blue')
    plt.legend(loc='upper left')
    plt.title(f'Original Series: {col}')

    plt.subplot(412)
    plt.plot(dec.trend, label='Trend', color='red')
    plt.legend(loc='upper left')
    plt.title('Trend')

    plt.subplot(413)
    plt.plot(dec.seasonal, label='Seasonal', color='green')
    plt.legend(loc='upper left')
    plt.title('Seasonal')

    plt.subplot(414)
    plt.scatter(dec.resid, label='Residual', color='black')
    plt.legend(loc='upper left')
    plt.title('Residual')
    
    plt.tight_layout()
    plt.show()

# Step 3: Model order selection for the VAR model
# Filter to include only the necessary columns
model_data = data[['Total Energy Consumed', 'GDP']].dropna()
model = VAR(model_data)
selected_order = model.select_order(maxlags=12)
best_lag = selected_order.selected_orders['aic']
print(best_lag)

# Step 4: Fit the VAR model with the best lag
var_model = model.fit(best_lag)
print(var_model.summary())

# Forecasting with the VAR model
forecast_steps = 5
forecast = var_model.forecast(model_data.values[-var_model.k_ar:], steps=forecast_steps)
forecast_df = pd.DataFrame(forecast, index=pd.date_range(start=model_data.index[-1], periods=forecast_steps + 1, freq='Q')[1:], columns=model_data.columns)

print("Forecasted Values:")
print(forecast_df)
