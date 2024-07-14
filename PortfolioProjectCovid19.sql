SELECT *
FROM PortfolioProjects..CovidDeaths
WHERE continent is not null
ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects..CovidDeaths
ORDER BY 1,2

-- Total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in India

SELECT location, date, total_cases, total_deaths,
       CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)*100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths
WHERE location = 'india'
ORDER BY 1, 2

-- Looking at the Total cases vs Population
-- Shows what percentage of population got covid in India

SELECT location, date, total_cases, population,
       CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)*100 AS CovidConfirmPercentage
FROM PortfolioProjects..CovidDeaths
WHERE location = 'india'
ORDER BY 1, 2

-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases) / CAST(population AS FLOAT))*100 AS PercentPopulationInfected
FROM PortfolioProjects..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing the countries with highest deathcounts per population

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProjects..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- By Continent

-- Showing the continents with the highest death counts per population

SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProjects..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, 
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'india'
WHERE continent is not null
--GROUP BY date
ORDER BY 1, 2

-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS dea
JOIN PortfolioProjects..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- USE OF CTE
WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS dea
JOIN PortfolioProjects..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

-- USE of Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS dea
JOIN PortfolioProjects..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS dea
JOIN PortfolioProjects..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

