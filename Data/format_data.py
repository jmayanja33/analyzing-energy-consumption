"""
Script to format all data into quarters and join the two datasets into a single csv file.
"""

import os
import pandas as pd

month_dict = {
    "enero": "Q1",
    "febrero": "Q1",
    "marzo": "Q1",
    "abril": "Q2",
    "mayo": "Q2",
    "junio": "Q2",
    "julio": "Q3",
    "agosto": "Q3",
    "septiembre": "Q3",
    "octubre": "Q4",
    "noviembre": "Q4",
    "diciembre": "Q4"
}

quarter_dict = {
    "Q1": "January", "Q2": "April", "Q3": "July", "Q4": "October"
}


def create_quarter_data_dict(df):
    """Function to create an object to hold quarter data while it is calculated"""
    return {col: 0 for col in df.columns}


def format_quarter_data(df, data):
    """Function to format quarter data to be saved in the final dataset"""
    formatted_data = []
    for col in df.columns:
        if col == 'Month':
            formatted_data.append(data["DATE"])
            formatted_data.append(data["Quarter"])
        else:
            formatted_data.append(data[col])

    return formatted_data


def format_final_date(item):
    """Function to remove Quarter from the date column"""
    return item[0:4]


# Main to run
if __name__ == "__main__":
    # Load data
    energy_consumption = pd.read_csv('Energy Consumption_r.csv')
    gdp = pd.read_csv('GDP-1.csv')

    # Map data together
    data = []
    quarter_data = create_quarter_data_dict(energy_consumption)
    counter = 0

    # Process energy data
    for i in range(len(energy_consumption)):
        date = energy_consumption["Month"][i].split()
        quarter = f"{date[0]}{month_dict[date[1]]}"

        # Calculate quarter data
        for col in energy_consumption.columns:
            if col == 'Month':
                quarter_data["DATE"] = quarter
                quarter_data["Quarter"] = month_dict[date[1]]
            else:
                quarter_data[col] += energy_consumption[col][i]
        counter += 1

        # Reset quarter
        if counter == 3:
            formatted_quarter_data = format_quarter_data(energy_consumption, quarter_data)
            data.append(formatted_quarter_data)
            quarter_data = create_quarter_data_dict(energy_consumption)
            counter = 0


    # Initialize columns
    columns = ['DATE', 'Quarter']
    for col in energy_consumption.columns:
        if col != 'Month':
            columns.append(col)

    # Create final data frame
    df = pd.DataFrame(data, columns=columns)

    # Concatenate with GDP data
    df = pd.merge(df, gdp, on='DATE', how='inner')
    df['DATE'] = df['DATE'].apply(lambda x: format_final_date(x))
    df['Month'] = [quarter_dict[i] for i in df['Quarter']]

    # Save formatted data
    df.to_csv('formatted_data.csv', index=False)
