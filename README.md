# Global Energy Consumption Analysis Using SQL 

## Project Overview
This project performs a comprehensive analysis of global energy trends by correlating data on **Energy Production, Consumption, GDP, Population, and Carbon Emissions**. Using advanced SQL querying techniques, the analysis aims to identify sustainability gaps, evaluate national energy efficiency, and quantify the trade-off between economic growth and environmental impact.

## Problem Statement
Energy consumption is increasing globally, yet this growth is uneven across nations, often leading to disproportionately higher carbon emissions.
* **Inequality:** Economic development and population growth influence energy demand differently across borders, making it difficult to pinpoint the primary drivers of pollution.
* **The Efficiency Gap:** International organizations and governmental bodies often struggle to identify which nations are growing sustainably versus those that are lagging in energy efficiency.
* **Quantification Challenge:** Without a proper analysis of the correlation between GDP, population, and emissions, it is impossible to quantify the specific trade-offs between economic prosperity and environmental sustainability.

## Objectives
* **Analyze Trends:** Examine how countries produce vs. consume energy and identify significant import/export imbalances.
* **Track Emissions:** Correlate carbon emissions with population growth and specific energy types (Coal, Oil, Renewables).
* **Evaluate Efficiency:** Calculate key sustainability metrics like the *Emission-to-GDP Ratio* and *Per Capita Consumption* to assess environmental performance fairly across nations.

## Tech Stack & Skills
* **Database:** MySQL
* **Language:** SQL
* **Key Techniques:**
    * **Complex Joins:** Integrating data across 6 interconnected tables.
    * **Window Functions:** Utilizing `LAG()` and `OVER()` for Year-Over-Year (YoY) trend analysis.
    * **CTEs & Subqueries:** Structuring complex logic for derived metrics and aggregations.
    * **Data Cleaning:** Handling `NULL` values and ensuring data integrity for accurate reporting.

## Database Schema
The analysis is built on a relational database schema where the **Country (CID)** serves as the primary key linking all datasets.

| Table Name | Description | Records |
| :--- | :--- | :--- |
| `country` | Master table containing 231 country names and IDs | 231 |
| `population` | Historical population data for each country | 1000 |
| `gdp_3` | Economic performance (GDP) data | 1000 |
| `production` | Energy production statistics | 5294 |
| `consumption` | Energy consumption statistics | 5277 |
| `emission_3` | CO2 emissions breakdown by fuel type | 3515 |

## Key Findings & Insights
The SQL analysis revealed five major insights regarding global sustainability:

1.  **Energy Imbalance:** There is a sharp disconnect between supply and demand in major economies. For instance, **China** is heavily dependent on energy imports (Consumption > Production), whereas **Russia** acts as a massive surplus energy exporter.
2.  **Emission Hotspots:** Fossil fuels—specifically **Coal and Coke**—remain the primary driver of global emissions, significantly outweighing natural gas and renewables.
3.  **Positive Sustainability Trends:** Data shows that specific nations (e.g., **France**) have successfully reduced their *per capita emissions* over the last decade, proving that economic stability can be achieved without increasing individual carbon footprints.
4.  **The Sustainability Gap:** The *Emission-to-GDP ratio* remains high for developing heavy-industry nations, indicating that the shift to renewable energy is still lagging behind the scale of fossil fuel dependency.
5.  **Population vs. Impact:** While high-population nations like **India and China** drive the highest overall energy demand, their *per capita* emissions vary drastically. This proves that the *type* of energy used (energy mix) is a more critical factor for sustainability than population size alone.

## Technical Challenges & Solutions
* **SQL Constraints:** Overcame MySQL Error 1235 (View constraints) by optimizing queries with Derived Table Joins.
* **Complex Logic:** Debugged intricate time-series logic to accurately calculate year-over-year growth rates across multiple joined tables.
* **Data Consistency:** Resolved SQL mode issues (Error 1055) to ensure accurate aggregations and compliance with strict SQL standards during reporting.

---
**Author:** G Leeladri Reddy
[LinkedIn Profile](https://www.linkedin.com/in/gandudi-leeladri-reddy) | [GitHub Profile](https://github.com/gandudileeladrireddy)
