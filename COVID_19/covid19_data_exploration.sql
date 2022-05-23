/*
Covid 19 Data Exploration with SQL
Skills used: Aggregate Functions, CTE, Joins, Temp Tables, Data Types, Views
*/

-- Checking Tables (data contains empty values)
SELECT *
FROM coviddeath
WHERE continent <> '' 
ORDER BY 3;

SELECT *
FROM covidvax
WHERE continent <> '' 
ORDER BY 3;

-- Selecting data to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeath
WHERE continent <> ''
ORDER BY 1, 2;

-- CALCULATIONS

-- Calculate the percentage of COVID deaths for selected countries

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeath
WHERE location like '%Brazil%'
and continent <> '' 
order by 2 DESC;

-- Calculate the percentage of population infected with Covid for selected country
SELECT location, date, population, total_cases, (total_cases/population)*100 AS infected_percentage
FROM coviddeath
WHERE location like '%Brazil%'
and continent <> '' 
order by 2 DESC;

-- Find the countries with the highest infection rate compared to its population

SELECT location, population, MAX(total_cases) AS highest_infection_count,  Max((total_cases/population))*100 AS highest_infected_percentage
FROM coviddeath
GROUP BY location, population
ORDER BY highest_infected_percentage DESC;

-- Find countries with the highest death-count

SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeath
WHERE continent <> ''
GROUP BY location
ORDER BY total_death_count DESC;

-- Show contintents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeath
WHERE continent <> ''
GROUP BY continent
ORDER BY total_death_count DESC;

-- Total Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_Cases)*100 AS death_percentage
FROM coviddeath
WHERE continent <> '';

-- Calculate percentage of population that has recieved at least one covid vaccine

SELECT d.continent, d.date, d.location, d.population, v.new_vaccinations,
		SUM(CONVERT(v.new_vaccinations, UNSIGNED)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_vax_people
FROM coviddeath d
JOIN covidvax v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent <> ''
ORDER BY 3, 2 DESC;

-- Using CTE to perform calculations

WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_vax_people)
AS
(SELECT d.continent, d.date, d.location, d.population, v.new_vaccinations,
		SUM(CONVERT(v.new_vaccinations, UNSIGNED)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_vax_people
FROM coviddeath d
JOIN covidvax v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent <> ''
-- ORDER BY 2 DESC
)
Select *, (rolling_vax_people/population)*100
From PopvsVac;

-- Using Temp Table to perform calculations
DROP Table if exists PercentVax;
CREATE TABLE Percentvax
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vax_people numeric
);
INSERT INTO Percentvax
SELECT d.continent, d.date, d.location, d.population, v.new_vaccinations,
		SUM(CONVERT(v.new_vaccinations, UNSIGNED)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_vax_people
FROM coviddeath d
JOIN covidvax v
	ON d.location = v.location
	AND d.date = v.date;
-- WHERE d.continent <> ''
-- ORDER BY 2 DESC

SELECT *, (rolling_vax_people/population)*100
FROM Percentvax;

-- Creating View to store data for later visualitations
Create View PercentPop as
SELECT d.continent, d.date, d.location, d.population, v.new_vaccinations,
		SUM(CONVERT(v.new_vaccinations, UNSIGNED)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_vax_people
FROM coviddeath d
JOIN covidvax v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent <> ''

