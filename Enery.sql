CREATE DATABASE IF NOT EXISTS ENERGYDB2;
USE ENERGYDB2;

-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

SELECT * FROM COUNTRY;

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
	energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT 
    *
FROM
    CONSUMPTION;

-- -------------------------------------------------------------- /*Data Analysis Questions*/ ---------------------------------------------------------------------------

/* General & Comparative Analysis*/

-- 1. What is the total emission per country for the most recent year available?
SELECT 
    country, year, SUM(emission) AS total_emission
FROM
    emission_3
WHERE
    year = (SELECT 
            MAX(year)
        FROM
            emission_3)
GROUP BY country , year
ORDER BY total_emission DESC;

-- 2. What are the top 5 countries by GDP in the most recent year?
SELECT 
    country, year, SUM(value) AS GDP
FROM
    gdp_3
WHERE
    year = (SELECT 
            MAX(year)
        FROM
            gdp_3)
GROUP BY country , year
ORDER BY GDP DESC
LIMIT 5;

-- 3. Compare energy production and consumption by country and year. 
SELECT 
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    SUM(c.consumption) AS total_consumption
FROM
    production p
        JOIN
    CONSUMPTION c ON p.country = c.country
        AND p.year = c.year
GROUP BY p.country , p.year
ORDER BY total_production DESC , total_consumption DESC;

-- 4. Which energy types contribute most to emissions across all countries?
SELECT 
    energy_type, SUM(emission) AS emission
FROM
    emission_3
GROUP BY energy_type
ORDER BY emission DESC; 

/* Trend Analysis Over Time*/

-- 5. How have global emissions changed year over year?
SELECT 
    SUM(emission) / (SELECT 
            SUM(emission)
        FROM
            emission_3) AS Rate_of_emission,
    year
FROM
    emission_3
GROUP BY year
ORDER BY Rate_of_emission DESC;

-- 6. What is the trend in GDP for each country over the given years?
SELECT 
    country,
    year,
    (SUM(value) / (SELECT 
            SUM(value)
        FROM
            gdp_3)) * 100 AS rate_of_global_gdp
FROM
    gdp_3
GROUP BY country , year
ORDER BY country , year DESC;

-- 7.  How has population growth affected total emissions in each country?
SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    p.value AS population,
    (SUM(e.emission) / p.value) * 100 AS per_capita_emission
FROM
    emission_3 e
        JOIN
    population p ON e.country = p.countries
        AND e.year = p.year
GROUP BY e.country , e.year , p.value
ORDER BY e.country , e.year;

-- 8. Has energy consumption increased or decreased over the years for major economies?
SELECT
    c1.country,
    c1.year,
    SUM(c1.consumption) AS total_consumption
FROM
    consumption c1
JOIN (
    SELECT country
    FROM gdp_3
    WHERE year = (SELECT MAX(year) FROM gdp_3)
    ORDER BY value DESC
    LIMIT 5
) AS c2
    ON c1.country = c2.country 
GROUP BY
    c1.country,
    c1.year
ORDER BY
    c1.country,
    c1.year DESC;
    
-- 9.  What is the average yearly change in emissions per capita for each country?
SELECT
    t1.country,t1.year,
    AVG(t1.Change_Percapita_Emission) AS Avg_Yearly_Change_Per_Capita_Emission
FROM
    (
        SELECT
            country,year,
            (per_capita_emission - 
             LAG(per_capita_emission, 1) OVER (PARTITION BY country ORDER BY year)
            ) AS Change_Percapita_Emission
        FROM
            emission_3
    ) t1
WHERE
    t1.Change_Percapita_Emission IS NOT NULL
GROUP BY
    t1.country,t1.year
ORDER BY
    Avg_Yearly_Change_Per_Capita_Emission DESC;
    
select * from emission_3;

/*Ratio & Per Capita Analysis*/

-- 10. What is the emission-to-GDP ratio for each country by year?
SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    g.value AS gdp,
    CONCAT(ROUND((SUM(e.emission) / g.value) * 100, 2),
            '%') AS emission_to_gdp_rate
FROM
    emission_3 e
        JOIN
    gdp_3 g ON e.country = g.country
        AND e.year = g.year
GROUP BY e.country , e.year , g.value
ORDER BY e.year DESC , gdp DESC;

-- 11. What is the energy consumption per capita for each country over the last decade?
SELECT
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    MAX(p.value) AS population,
    ROUND((SUM(c.consumption) / NULLIF(MAX(p.value), 0)), 8) AS consumption_per_capita
FROM
    consumption c
JOIN
    population p 
    ON c.country = p.countries AND c.year = p.year
WHERE
    c.year >= (SELECT MAX(year) - 10 FROM consumption)
GROUP BY 
    c.country, 
    c.year
ORDER BY 
    consumption_per_capita DESC;

-- 12. How does energy production per capita vary across countries?
SELECT 
    p.country,
    p.year,
    ROUND((SUM(p.production) / p2.value) * 100, 2) AS production_per_capita
FROM
    production p
        JOIN
    population p2 ON p.country = p2.countries
        AND p.year = p2.year
GROUP BY p.country , p.year , p2.value
ORDER BY production_per_capita DESC;

-- 13. Which countries have the highest energy consumption relative to GDP?
SELECT 
    c.country,
    c.year,
    round((SUM(c.consumption) / SUM(g.value) )*100,2)  AS consumption_to_gdp_ratio
FROM
    consumption c
        JOIN
    gdp_3 g ON c.country = g.country
        AND c.year = g.year
GROUP BY c.country , c.year
ORDER BY consumption_to_gdp_ratio DESC;

-- 14. What is the correlation between GDP growth and energy production growth?
SELECT
    g.Country,
    g.year,
    (g.Value - prev_gdp.Value) / NULLIF(prev_gdp.Value, 0) AS GDP_Growth_Rate,
    (p.Total_Production - prev_prod.Total_Production) / NULLIF(prev_prod.Total_Production, 0) AS Production_Growth_Rate
FROM
    gdp_3 g
JOIN
    (SELECT Country, year, Value FROM gdp_3) prev_gdp
    ON g.Country = prev_gdp.Country AND g.year = prev_gdp.year + 1
JOIN
    (SELECT country, year, SUM(production) AS Total_Production FROM production GROUP BY country, year) p
    ON g.Country = p.country AND g.year = p.year
JOIN
    (SELECT country, year, SUM(production) AS Total_Production FROM production GROUP BY country, year) prev_prod
    ON p.country = prev_prod.country AND p.year = prev_prod.year + 1
WHERE
    prev_gdp.Value IS NOT NULL AND prev_prod.Total_Production IS NOT NULL
ORDER BY
    g.Country, g.year,Production_Growth_Rate desc;
    
    
 /*Global Comparisons*/

-- 15. What are the top 10 countries by population and how do their emissions compare?
WITH latest_population AS (
    SELECT countries AS country, year, value AS population
    FROM population
    WHERE year = (SELECT MAX(year) FROM population)
),
latest_emissions AS (
    SELECT country, SUM(emission) AS total_emissions
    FROM emission_3
    WHERE year = (SELECT MAX(year) FROM emission_3)
    GROUP BY country
)
SELECT 
    p.country,
    p.population,
    e.total_emissions,
    ROUND(e.total_emissions / NULLIF(p.population, 0), 6) AS emission_per_capita
FROM latest_population p
LEFT JOIN latest_emissions e
    ON p.country = e.country
ORDER BY p.population DESC
LIMIT 10;

-- 16. Which countries have improved (reduced) their per capita emissions the most over the last decade?
WITH last_decade AS (
  SELECT DISTINCT 
    e.country,e.year,e.emission,p.value AS population,
    (CAST(e.emission AS DECIMAL(30, 20)) / NULLIF(p.value, 0)) AS per_capita_emission
  FROM emission_3 e
  JOIN population p
    ON e.country = p.countries AND e.year = p.year
  WHERE e.year >= (SELECT MAX(year) - 10 FROM emission_3)
),
start_end AS (
  SELECT country,MIN(year) AS start_year,MAX(year) AS end_year
  FROM last_decade
  GROUP BY country
)
SELECT
  se.country,
  AVG(s.per_capita_emission) AS start_per_capita,
  AVG(e.per_capita_emission) AS end_per_capita,
  (AVG(s.per_capita_emission) - AVG(e.per_capita_emission)) AS reduction_in_per_capita
FROM start_end se
JOIN last_decade s
  ON se.country = s.country AND se.start_year = s.year
JOIN last_decade e
  ON se.country = e.country AND se.end_year = e.year
GROUP BY
    se.country
ORDER BY
    reduction_in_per_capita DESC; 

-- 17. What is the global share (%) of emissions by country?
SELECT 
    country,
    SUM(emission) AS total_emission,
    CONCAT(ROUND((SUM(emission) / (SELECT 
                            SUM(emission)
                        FROM
                            emission_3)) * 100,
                    2),
            '%') AS global_share_percent
FROM
    emission_3
GROUP BY country
ORDER BY (SUM(emission) / (SELECT 
        SUM(emission)
    FROM
        emission_3)) DESC;

-- 18. What is the global average GDP, emission, and population by year?
SELECT 
    e.year,
    AVG(g.value) AS avg_gdp,
    AVG(e.emission) AS avg_emission,
    AVG(p.value) AS avg_population
FROM
    emission_3 e
        JOIN
    gdp_3 g ON e.country = g.country
        AND e.year = g.year
        JOIN
    population p ON e.country = p.countries
        AND e.year = p.year
GROUP BY e.year
ORDER BY e.year;