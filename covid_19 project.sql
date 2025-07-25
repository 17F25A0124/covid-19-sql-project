CREATE DATABASE covid19;

USE covid19;

-- 1.total cases globally

SELECT SUM(totalcases) AS total_cases FROM worldometer_data;

-- 2.top 5 countries with highest cases

SELECT Country_Region,SUM(confirmed) AS total_cases
FROM country_wise_latest
GROUP BY country_region
ORDER BY total_cases DESC
LIMIT 5;

-- 3. top 5 countries with maximum active cases

SELECT country_region,active 
FROM country_wise_latest
ORDER BY active DESC
LIMIT 5;

-- 4. 5 least affected countries

SELECT country_region,confirmed
FROM country_wise_latest
ORDER BY confirmed
LIMIT 5;

-- 5.daily new cases for india

SELECT country_region, `new cases`
FROM country_wise_latest
WHERE country_region = 'India';

-- 6. death rate by country

SELECT country_region,(SUM(deaths)/SUM(confirmed))*100 AS death_rate
FROM country_wise_latest
GROUP BY country_region
ORDER BY death_rate DESC;

-- 7. countries with zero deaths

SELECT DISTINCT country_region
FROM country_wise_latest
WHERE deaths = 0;

-- 8. countries with recovery rate > 80%

SELECT country_region,
       ROUND(SUM(recovered)/SUM(confirmed),2)*100 AS recovery_rate
FROM country_wise_latest
GROUP BY country_region
ORDER by recovery_rate DESC;

--

WITH daily AS (
    SELECT
        `country/region`,
        date,
        confirmed - LAG(confirmed) OVER (PARTITION BY `country/region` ORDER BY date) AS new_cases
FROM full_grouped
)
SELECT `country/Region`, MAX(new_cases) AS max_single_day_increase
FROM daily
GROUP BY `country/region`
ORDER BY max_single_day_increase DESC;

-- 10.  creating view 

CREATE VIEW country_summary  AS 
SELECT  country_region AS country,
		SUM(confirmed) AS total_confirmed,
        SUM(deaths) AS total_deaths,
        SUM(recovered) AS total_recoverd
FROM country_wise_latest
GROUP BY country;

SELECT * FROM country_summary;


