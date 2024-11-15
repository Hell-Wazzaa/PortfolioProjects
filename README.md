**Data Cleaning Project**

This SQL project focuses on comprehensive data cleaning techniques applied to a Nashville housing dataset. The goal was to ensure data consistency, integrity, and readiness for further analysis.

**Key Features:**
- **Date Standardization**: Reformatted date columns for consistency.
- **Address Completion**: Filled in missing property addresses using related records.
- **Data Parsing**: Split complex address fields into separate columns (address, city, state) for clarity.
- **Field Transformation**: Converted 'Y' and 'N' values in categorical columns (e.g., "Sold as Vacant") to more descriptive 'Yes' and 'No'.
- **Duplicate Removal**: Used `ROW_NUMBER()` with `PARTITION BY` to identify and remove duplicate records.
- **Column Cleanup**: Dropped unnecessary columns to streamline the dataset.

**Usage**:
Clone the repository and run the provided SQL scripts to apply similar cleaning steps to any real estate or housing data project.

This project serves as a practical guide for data cleaning processes that enhance data quality for better analysis and insights.

**COVID-19 Data Analysis Project**

This project analyzes global COVID-19 data using SQL to extract meaningful insights about case trends, death rates, and vaccination progress. The dataset includes information on cases, deaths, and vaccinations from different countries and continents.

**Key Features:**
- **Death Rate Analysis**: Calculated the death percentage among confirmed cases, highlighting the impact of COVID-19 in countries like India.
- **Infection Rate Analysis**: Examined the proportion of the population infected, identifying countries with the highest infection rates relative to their population.
- **Continental Comparisons**: Assessed total deaths by continent to reveal regional impacts.
- **Global Summary**: Aggregated worldwide data for new cases, deaths, and overall death percentage.
- **Vaccination Tracking**: Used CTEs and temporary tables to compute rolling vaccination counts and the percentage of populations vaccinated over time.
- **Creation of a View**: Constructed a SQL view for easy visualization and further analysis of vaccination progress by country.

**Usage**:
This project serves as a comprehensive guide for performing SQL-based data analysis and building foundational reports for COVID-19 datasets. Perfect for analysts and data enthusiasts looking to understand global pandemic trends through SQL.
