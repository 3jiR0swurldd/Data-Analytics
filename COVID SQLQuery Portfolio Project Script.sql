SELECT * 
FROM PortfolioProject..CovidDeaths 
-- where continent is not null 
ORDER by 3,4

-- Select * 
-- From PortfolioProject..CovidDeaths 
-- Order by 3,4



-- Select Data that we are going to be using 

Select location,date, total_cases, new_cases,total_deaths, population 
from PortfolioProject.dbo.CovidDeaths
order by 1,2



--  Looking at Total Cases vs Total Deaths

-- Shows the likelihood of dying if you contract covid in your country 

Select location,date, total_cases,total_deaths, (total_deaths * 100.000 /total_cases)   as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where location like '%kingdom%'
order by 1,2


-- Looking at the Total Cases vs Popluation


-- Shows what percentage of the population in your country contracted Covid 

Select LOCATION,date, total_cases, population, (total_cases * 100.0 / population) as PercentageOfPopulationInfected
from PortfolioProject.dbo.CovidDeaths
-- where LOCATION like '%kingdom%'
ORDER BY 1,2  


-- Looking at Countries with Highest Infection Rate compared to Population. 

Select LOCATION,population, max(total_cases) as HighestInfectionCount, MAX((total_cases * 100. / population)) as PercentageOfPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
-- where LOCATION like '%kingdom%'
where continent is not NULL
GROUP by LOCATION,population
ORDER BY PercentageOfPopulationInfected DESC


-- Showing Countries with the Highest Death Count per Population (Per 1000 People)

Select LOCATION,population,max(total_deaths) as DeathCount


-- MAX((total_deaths) * 1.0 /population) * 1000.00  as DeathCountPerPoulation per 1000 People

FROM PortfolioProject.dbo.CovidDeaths


-- where LOCATION like '%kingdom%'

where population > 0 and continent is not NULL
GROUP by LOCATION,population
ORDER BY DeathCount DESC 


-- BREAKING IT DOWN BY CONTINENT 

Select continent, max(total_deaths) as DeathCount
FROM PortfolioProject.dbo.CovidDeaths
-- where LOCATION like '%kingdom%'
where population > 0 and continent is NOT NULL
GROUP by continent
ORDER BY DeathCount DESC 


-- SHOWING THE CONTINENT WITH THE HIGHEST DEATH COUNT 

Select continent, max(total_deaths) as DeathCount
FROM PortfolioProject.dbo.CovidDeaths
-- where LOCATION like '%kingdom%'
where population > 0 and continent is NOT NULL
GROUP by continent
ORDER BY DeathCount DESC 


-- GLOBAL NUMBERS 

Select SUM(new_cases) AS GLOBALTOTALCASES, SUM(new_deaths)AS GLOBALTOTALDEATHS, (SUM(NEW_DEATHS) * 100.0)/SUM(NEW_CASES) as GLOBALDeathPercentage
from PortfolioProject.dbo.CovidDeaths
-- where location like '%kingdom%'
WHERE CONTINENT IS NOT NULL
-- GROUP BY DATE 
order by 1,2



--  GLOBAL CASES PER DAY 

Select DATE, SUM(new_cases) AS GLOBALTOTALCASES, SUM(new_deaths)AS GLOBALTOTALDEATHS, (SUM(NEW_DEATHS) * 100.0)/SUM(NEW_CASES) as GLOBALDeathPercentage
from PortfolioProject.dbo.CovidDeaths
-- where location like '%kingdom%'
WHERE CONTINENT IS NOT NULL
GROUP BY DATE 
order by 1,2


--  LOOKING AT TOTAL POPULATION VS VACINATION 

SELECT *
FROM PortfolioProject.DBO.CovidDeaths DEA
JOIN PortfolioProject.DBO.[CovidVaccinations ] VAC 
    ON DEA.[location] = VAC.[location]
    AND DEA.[date] = VAC.DATE



--  LOOKING AT TOTAL POPULATION VS VACINATION 

SELECT dea.continent, dea.[location], dea.[date], population, vac.new_vaccinations, SUM(VAC.new_vaccinations) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, 
DEA.DATE) AS ROLLINGPEOPLEVACCINATED 
-- , (ROLLINGPEOPLEVACCINATED)*100.00
FROM PortfolioProject.DBO.CovidDeaths DEA
JOIN PortfolioProject.DBO.[CovidVaccinations ] VAC 
    ON DEA.[location] = VAC.[location]
    AND DEA.[date] = VAC.DATE
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3 



--  USING A CTE 


WITH POPVSVAC (CONTINENT, LOCATION, DATE, POPULATION, new_vaccinations, ROLLINGPEOPLEVACCINATED)
AS 
(
SELECT dea.continent, dea.[location], dea.[date], population, vac.new_vaccinations, SUM(VAC.new_vaccinations) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, 
DEA.DATE) AS ROLLINGPEOPLEVACCINATED 
-- , (ROLLINGPEOPLEVACCINATED/POPULATION)*100.00
FROM PortfolioProject.DBO.CovidDeaths DEA
JOIN PortfolioProject.DBO.[CovidVaccinations ] VAC 
    ON DEA.[location] = VAC.[location]
    AND DEA.[date] = VAC.DATE
WHERE DEA.continent IS NOT NULL
-- ORDER BY 2,3 

)

SELECT * , (ROLLINGPEOPLEVACCINATED * 100.00 )/POPULATION AS VaccinationCoveragePercentage
FROM POPVSVAC



-- TEMP TABLE 
DROP TABLE IF EXISTS #PERCENTPOPLATIONVACCINATED 
CREATE TABLE #PERCENTPOPLATIONVACCINATED 
(
CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC
)

INSERT INTO #PERCENTPOPLATIONVACCINATED
SELECT dea.continent, dea.[location], dea.[date], population, vac.new_vaccinations, SUM(VAC.new_vaccinations) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, 
DEA.DATE) AS ROLLINGPEOPLEVACCINATED 
-- , (ROLLINGPEOPLEVACCINATED/POPULATION)*100.00
FROM PortfolioProject.DBO.CovidDeaths DEA
JOIN PortfolioProject.DBO.[CovidVaccinations ] VAC 
    ON DEA.[location] = VAC.[location]
    AND DEA.[date] = VAC.DATE
WHERE DEA.continent IS NOT NULL
-- ORDER BY 2,3 

SELECT * 
FROM #PERCENTPOPLATIONVACCINATED



-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS 

CREATE VIEW PERCENTPOPLATIONVACCINATED AS 
SELECT dea.continent, dea.[location], dea.[date], population, vac.new_vaccinations, SUM(VAC.new_vaccinations) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, 
DEA.DATE) AS ROLLINGPEOPLEVACCINATED 
-- , (ROLLINGPEOPLEVACCINATED/POPULATION)*100.00
FROM PortfolioProject.DBO.CovidDeaths DEA
JOIN PortfolioProject.DBO.[CovidVaccinations ] VAC 
    ON DEA.[location] = VAC.[location]
    AND DEA.[date] = VAC.DATE
WHERE DEA.continent IS NOT NULL
-- ORDER BY 2,3 

 SELECT * FROM PERCENTPOPLATIONVACCINATED


CREATE VIEW DEATHPERCENTAGE AS 
Select location,date, total_cases,total_deaths, (total_deaths * 100.000 /total_cases)   as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where location like '%kingdom%'
-- order by 1,2

SELECT * FROM DEATHPERCENTAGE


CREATE VIEW PercentageOfPopulationInfected AS 
Select LOCATION,date, total_cases, population, (total_cases * 100.0 / population) as PercentageOfPopulationInfected
from PortfolioProject.dbo.CovidDeaths
-- where LOCATION like '%kingdom%'
-- ORDER BY 1,2  

SELECT * FROM PercentageOfPopulationInfected 