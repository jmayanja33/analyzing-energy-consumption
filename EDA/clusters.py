"""
Script to create clusters of quarters based on energy consumption and GDP.
"""

import matplotlib.pyplot as plt
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA

# Load Data
data = pd.read_csv('../Data/formatted_data.csv')
test_data = data.drop(['DATE', 'Quarter'], axis=1)

# Fit K-means to optimal number of clusters
kmeans = KMeans(n_clusters=4)
kmeans.fit(test_data)

# Reduce dimension of test data to 2 so that it can be plotted
pca = PCA(n_components=2)
pca_data = pca.fit_transform(test_data)

# Plot results
x_data = [i[0] for i in pca_data]
y_data = [i[1] for i in pca_data]
point_data = [data['Quarter'][i] for i in range(len(data))]
colors = ['red', 'blue', 'green', 'black']
color_map = [colors[i] for i in kmeans.labels_]

plt.figure(figsize=(6, 4))
for i in range(len(x_data)):
    plt.scatter(x_data[i], y_data[i], marker=f'${point_data[i]}$', c=color_map[i], s=100)

plt.title('Clustered Quarterly Energy Data')
plt.savefig('clusters.png')
