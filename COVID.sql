-- Check the data tables

-- SELECT * 
-- FROM PortfolioProject..CovidDeaths
-- ORDER by 3,4

-- SELECT * 
-- FROM PortfolioProject..Vacinations
-- ORDER by 3,4

-- Select data to use during the queries
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER by 1,2

-- Total cases VS total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location like Ukraine
and continent is not null
ORDER by 1,2

-- Total cases vs population
-- Shows what percentage of population infected with Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as infected_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER by 1,2

-- Countries with highest infection rate VS population
SELECT location, max(total_cases) as highest_infection_count, max(total_cases/population)*100 as infected_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by location, population
ORDER by infected_percentage desc

-- Countries with highest death count VS population
SELECT location, max(cast(total_deaths as int)) as total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by location
ORDER by total_death_count desc

-- Breakdown by continent
-- Shows continents with highest death counts
SELECT continent, max(cast(total_deaths as int)) as total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by continent
ORDER by total_death_count desc

-- Global numbers
SELECT date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
-- GROUP by date
ORDER by 1,2

-- Join datasets and use CTE
-- Total vaccinations VS porpulation
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location ORDER by dea.location, dea.date) as rolling_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (rolling_vaccinated/population)*100
FROM pop_vs_vac

GO

-- Create view for visualization
CREATE VIEW perc_pop_vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location ORDER by dea.location, dea.date) as rolling_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null