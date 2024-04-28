# %%
from statsmodels.tsa.seasonal import seasonal_decompose
import plotly.tools as tls
import pandas as pd
from plotly.subplots import make_subplots
import plotly.graph_objects as go
import plotly.express as px
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
# %%
def plot_seasonal_decompose(title:str="Time Series Decomposition", df:pd.DataFrame=None):
    pd.DataFrame.iteritems = pd.DataFrame.items
    
    fig = make_subplots(rows=4, cols=len(df.columns), subplot_titles=df.columns)
    fig.update_layout(template='seaborn')
            
    for n, (column_name, Series) in enumerate(df.iteritems(), start=1):
        decomposition = seasonal_decompose(Series, model='additive', period=4)
        fig.add_trace(
            go.Scatter(x=Series.index, y=decomposition.observed, mode="lines", name='Observed', line=dict(color='teal')),
            row=1,
            col=n,)
        fig.update_annotations(dict(font_size=25))
        fig.add_trace(
            go.Scatter(x=Series.index, y=decomposition.trend, mode="lines", name='Observed', line=dict(color='darkslategray')),
            row=2,
            col=n,)
        fig.update_annotations(dict(font_size=25))
        fig.add_trace(
            go.Scatter(x=Series.index, y=decomposition.seasonal, mode="lines", name='Seasonal', line=dict(color='darkgray')),
            row=3,
            col=n,)
        fig.update_annotations(dict(font_size=25))
        fig.add_trace(
            go.Scatter(x=Series.index, y=decomposition.resid, mode="lines", name='Residual', line=dict(color='cadetblue')),
            row=4,
            col=n, 
        )
        fig.update_annotations(dict(font_size=25))
             
    [fig.update_yaxes(title_text = x, row = n, col=1,title_font=dict(size=24),) for n,x in enumerate(["Observed", "Trend", "Seasonal", "Residuals"], start=1)]
    fig.update_layout(height=900, title=f'<b>{title}</b>',title_font=dict(size=24), margin={'t':100}, title_x=0.5, showlegend=False)
    
    return fig
data = pd.read_csv("./Data/formatted_data.csv")
data = pd.read_csv(data_path, index_col=19, parse_dates=True)
#drop column Q1 from my data

energy_cols = [col for col in data.columns if 'Total Energy Consumed' in col]
data['Total Energy Consumed'] = data[energy_cols].sum(axis=1).round(0)

fig = px.scatter(data, x="GDP", y="Total Energy Consumed", color='Quarter',  trendline="lowess", trendline_options=dict(frac=0.5),
                 color_discrete_sequence=["darkslategray", "chocolate", "indianred", "teal"])
                                          #text=['{:.1f}k'.format(x / 1000)  for x in data['Total Energy Consumed']])
fig.update_traces(marker=dict(size=15))
#tickvals = [*range(1_000, 100_000, 1000)]
#ticktext = [f"{t // 1000:,}B" for t in tickvals]
#fig.update_xaxes(tickvals=tickvals, ticktext=ticktext)
fig.update_traces(textposition='bottom center', marker=dict(size=10))
fig.update_yaxes(title="Total Energy Consumed (k)",title_font=dict(size=24))
fig.update_xaxes(title="GDP in Billion (USD)", title_font=dict(size=24))
fig.update_annotations(dict(font_size=24))
fig.update_layout(title_text="Scatter plot of GDP vs Total Energy Consumed",  title_font=dict(size=24), legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1))
#fig.show()

decompose_cols = energy_cols + ['GDP']
data = data[decompose_cols]
#RENAME THE COLUMN
data.rename(columns={'Total Energy Consumed by the Commercial Sector':'Commercial',
                     'Total Energy Consumed by the Industrial Sector':'Industrial',
                     'Total Energy Consumed by the Residential Sector':'Residential',
                     'Total Energy Consumed':'All Sectors'}, inplace=True)
fig = plot_seasonal_decompose(df=data)
#fig.show()
#data_diff = data.diff().dropna()
#decompose data and save the residuals in a separate dataframe
decomposed = {col: seasonal_decompose(data[col], model='additive', period=4) for col in data.columns}
residuals = pd.DataFrame({col: dec.resid for col, dec in decomposed.items()})
#calcaulte correlation matrix
corr_matrix = residuals.corr()
mask = np.triu(np.ones_like(corr_matrix, dtype=bool))

f, ax = plt.subplots(figsize=(5, 4))
cmap = sns.diverging_palette(87, 123, n=129, as_cmap=True)
sns.heatmap(corr_matrix, 
            mask=mask, 
            cmap=cmap, 
            vmax=1, 
            vmin = -.25,
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
# plt.savefig('corrTax.png', dpi = 600)
#plt.show()
# %%

