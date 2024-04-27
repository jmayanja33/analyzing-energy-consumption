import pandas as pd

month_dict = {
    "enero": "January",
    "febrero": "February",
    "marzo": "March",
    "abril": "April",
    "mayo": "May",
    "junio": "June",
    "julio": "July",
    "agosto": "August",
    "septiembre": "September",
    "octubre": "October",
    "noviembre": "November",
    "diciembre": "December"
}


# Main to run
if __name__ == "__main__":
    # Load data
    energy_consumption = pd.read_csv('Energy Consumption_r.csv')

    # Initialize data structures
    date = []
    months = []
    formatted_data = []

    # Iterate through data and reformat
    for i in range(len(energy_consumption)):
        unformatted_data = energy_consumption['Month'][i].split()
        year = unformatted_data[0]
        month = month_dict[(unformatted_data[1])]

        date.append(year)
        months.append(month)
        formatted_data.append(f"{month} 1, {year}")

    # Add new columns
    energy_consumption['DATE'] = date
    energy_consumption['Month'] = months
    energy_consumption['Formatted Data'] = formatted_data

    # Filter data and save
    df = energy_consumption[['DATE', 'Primary Energy Consumed by the Residential Sector', 'Electricity Sales to Ultimate Customers in the Residential Sector', 'End-Use Energy Consumed by the Residential Sector', 'Residential Sector Electrical System Energy Losses', 'Total Energy Consumed by the Residential Sector', 'Primary Energy Consumed by the Commercial Sector', 'Electricity Sales to Ultimate Customers in the Commercial Sector', 'End-Use Energy Consumed by the Commercial Sector', 'Commercial Sector Electrical System Energy Losses', 'Total Energy Consumed by the Commercial Sector', 'Primary Energy Consumed by the Industrial Sector', 'Electricity Sales to Ultimate Customers in the Industrial Sector', 'End-Use Energy Consumed by the Industrial Sector', 'Industrial Sector Electrical System Energy Losses', 'Total Energy Consumed by the Industrial Sector', 'Month', 'Formatted Data']]
    df['Total Energy Consumed'] = df['Total Energy Consumed by the Residential Sector'] + df ['Total Energy Consumed by the Commercial Sector'] + df['Total Energy Consumed by the Industrial Sector']
    df.to_csv("formatted_data_monthly.csv", index=False)




