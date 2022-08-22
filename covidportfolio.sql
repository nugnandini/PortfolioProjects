CREATE DATABASE covid;
USE covid;


SELECT location
FROM coviddeaths
GROUP BY location;


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;


-- 1
-- looking at the total cases vs total deaths
-- finding the liklihood of death by covid in a country
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM coviddeaths
WHERE Location = "India"
ORDER BY 1,2;


-- looking at the total cases vs the population
-- shows what percentage of population got covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
FROM coviddeaths
-- WHERE Location = "china"
ORDER BY 1,2;


-- 2
-- which country has the highest infection rate
-- where the ratio of the cases to the population is high

SELECT
	Location, population,
	max(total_cases) AS HighestInfection, max((total_cases/population)*100) as PercentPopulationInfected
FROM 
	coviddeaths
GROUP BY 
	Location, population
ORDER BY
	4 DESC;
    
  
-- highest infection rate in a specific country
-- where the ratio of the cases to the population is high

SELECT
	Location, population,
	max(total_cases) AS HighestInfection, max((total_cases/population)*100) as PercentPopulationInfected
FROM 
	coviddeaths
-- WHERE Location = "India"
GROUP BY 
	Location, population
ORDER BY
	4 DESC;
    
    -- checking the categories in continents
    
SELECT continent
FROM coviddeaths
Group by continent;
    
    -- countries with high highest death count
    -- countries with highest death vs population

	
-- 3
SELECT
	Location, continent, 
	max(cast(total_deaths AS UNSIGNED)) AS DeathCounts, 
    
FROM 
	coviddeaths
WHERE 
	continent = "North America" 
    or continent = "South America"
    or continent = "Africa" 
    or continent = "Europe"
    or continent = "Asia"
    or continent = "Oceania"
    
--  I specified the continents because there were rows where the location had the name of a continent and the continent column was null. Those were excluded. SQL could not read "is not null" function so I used this method

GROUP BY 
	Location, continent
ORDER BY
	DeathCounts DESC;
    
  
  
-- 4
-- breaking things down by continent


SELECT
	continent, 
	max(cast(total_deaths AS UNSIGNED)) AS DeathCounts 
   
FROM 
	coviddeaths
WHERE 
	continent = "North America" 
    or continent = "South America"
    or continent = "Africa" 
    or continent = "Europe"
    or continent = "Asia"
    or continent = "Oceania"
    
--  I specified the continents because there were rows where the location had the name of a continent and the continent column was null. Those were excluded. SQL could not read "is not null" function so I used this method

GROUP BY 
	continent
ORDER BY
	DeathCounts DESC;
  
  
  
/* need to check the code   
-- however the above query does not provide the total deaths in Asia, so I will insert a row with the death count in Asia present in the location
  -- the death counts in each continent
  
    
SELECT
	location, 
	max(cast(total_deaths AS UNSIGNED)) AS DeathCounts 
   
FROM 
	coviddeaths
WHERE 
	location = "North America" 
    or location = "South America"
    or location = "Africa" 
    or location = "Europe"
    or location = "Asia"
    or location = "Oceania"
    
--  I specified the continents because there were rows where the location had the name of a continent and the continent column was null. Those were excluded. SQL could not read "is not null" function so I used this method

GROUP BY 
	location
ORDER BY
	DeathCounts DESC;


SELECT SUM(max(total_deaths)) as DeathsAsia
FROM coviddeaths
WHERE continent = "Asia";

-- The above code did not work for me so I used an alternative way

-- first I found out the latest date for the entries

SELECT location, date, total_deaths
FROM coviddeaths
order by date desc;

-- the latest date will have the maximum total deaths, hence I will use that to find the total deaths in Asia so far

SELECT 
	SUM(cast(total_deaths AS UNSIGNED))
FROM 
	coviddeaths
WHERE 
	continent = "Asia"
    AND date = "2020-08-20";
    
    SELECT location, total_deaths
    FROM coviddeaths
    WHERE location = "Asia";
    */
    


-- global numbers

SELECT SUM(new_cases) AS totalcases, SUM(cast(new_deaths as unsigned)) AS totaldeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercent
FROM coviddeaths
-- WHERE Location = "India"
-- GROUP BY date
ORDER BY 1,2;



-- looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
FROM coviddeaths dea
JOIN covidvaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent = "North America" 
    or dea.continent = "South America"
    or dea.continent = "Africa" 
    or dea.continent = "Europe"
    or dea.continent = "Asia"
    or dea.continent = "Oceania"
ORDER BY 1,2,3;



-- Use CTE to find rolling vaccination percentage

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
FROM coviddeaths dea
JOIN covidvaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent = "North America" 
    or dea.continent = "South America"
    or dea.continent = "Africa" 
    or dea.continent = "Europe"
    or dea.continent = "Asia"
    or dea.continent = "Oceania"
	-- ORDER BY 1,2,3;
)

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentVaccinated
FROM PopvsVac;



/*
-- Using a temp table to calculate the rolling vaccination percentage
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
Continent char(255),
Location char(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPercentVaccinated FLOAT
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, CAST(dea.population AS UNSIGNED), CAST(vac.new_vaccinations AS UNSIGNED), SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
FROM coviddeaths dea
JOIN covidvaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent = "North America" 
    or dea.continent = "South America"
    or dea.continent = "Africa" 
    or dea.continent = "Europe"
    or dea.continent = "Asia"
    or dea.continent = "Oceania";
    
    
SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentVaccinated
FROM PercentPopulationVaccinated;
*/


-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PopvsVac AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
FROM coviddeaths dea
JOIN covidvaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent = "North America" 
    or dea.continent = "South America"
    or dea.continent = "Africa" 
    or dea.continent = "Europe"
    or dea.continent = "Asia"
    or dea.continent = "Oceania"
	ORDER BY 1,2,3;
    




    

    


    


    



    
    






