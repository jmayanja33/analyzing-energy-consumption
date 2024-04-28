import pandas as pd
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import grangercausalitytests
from statsmodels.tsa.vector_ar.var_model import VAR
import matplotlib.pyplot as plt
import warnings
from statsmodels.tools.sm_exceptions import ValueWarning
warnings.simplefilter(action='ignore', category=ValueWarning)
from statsmodels.tsa.stattools import grangercausalitytests
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

import plotly.express as px

data = pd.read_csv("./Data/formatted_data_monthly.csv")
data.set_index('Formatted Data', inplace=True)
data = data.select_dtypes(include='number')

residuals = pd.DataFrame()
for column in data.columns:
    decomposition = seasonal_decompose(data[column], period=12)
    residuals[column] = decomposition.resid

residuals.dropna(inplace=True)
# Initialize the best order and best AIC to None and infinity, respectively
model = VAR(residuals)
model_fit = model.fit(4)
params_df = model_fit.params

p_values_df = pd.DataFrame(columns=['Variable', 'P-Value'])
p_value_threshold = 0.05
percentage_threshold = 0.5
variables = params_df.columns
causal_variables = []
for variable in variables:
    test_result = model_fit.test_causality([variable], causing='Avg.Temp', kind='wald', signif=p_value_threshold)
    p_value = test_result.pvalue
    row_df = pd.DataFrame({'Variable': [variable], 'P-Value': [p_value]})
    p_values_df = pd.concat([p_values_df, row_df], ignore_index=True)
p_values_df.to_csv('Q_3_Granger_p_values.csv', index=False)

energy_cols = [col for col in data.columns if 'Total Energy Consumed' in col]
decompose_cols = energy_cols + ['Avg.Temp']
residuals = residuals[decompose_cols]
residuals.rename(columns={'Total Energy Consumed by the Commercial Sector':'Commercial',
                     'Total Energy Consumed by the Industrial Sector':'Industrial',
                     'Total Energy Consumed by the Residential Sector':'Residential',
                     'Total Energy Consumed':'All Sectors'}, inplace=True)
corr_matrix = residuals.corr()
mask = np.triu(np.ones_like(corr_matrix, dtype=bool))

f, ax = plt.subplots(figsize=(5, 4))
cmap = sns.diverging_palette(87, 123, n=129, as_cmap=True)
sns.heatmap(corr_matrix, 
            mask=mask, 
            cmap=cmap, 
            vmax=1, 
            vmin = -1,
            center=0,
            square=True, 
            linewidths=.5,
            annot = True,
            fmt='.2f', 
            annot_kws={'size': 10},
            cbar_kws={"shrink": .75})
plt.title('Correlation Matrix Residuals')
ax.xaxis.set_ticks_position('top')
ax.yaxis.set_ticks_position('right')
ax.tick_params(axis = 'x', labelsize = 8)
ax.tick_params(axis = 'y', labelsize = 8)
ax.set_ylim(len(corr_matrix)+1, -1)
plt.tight_layout()
plt.show()

