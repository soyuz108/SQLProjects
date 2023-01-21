-- Check the data tables

-- Select * 
-- From PortfolioProject..CovidDeaths
-- Order by 3,4

-- Select * 
-- From PortfolioProject..Vacinations
-- Order by 3,4

-- Select data to use during the queries
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Total cases VS total deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where location like Ukraine
Order by 1,2

-- Total cases vs population
-- Shows what percentage of population infected with Covid
Select location, date, total_cases, population, (total_cases/population)*100 as infected_percentage
From PortfolioProject..CovidDeaths
-- Where location like Ukraine
Order by 1,2

-- Countires with highest infection rate VS population
Select location, date, max(total_cases) as highest_infection_count, max(total_cases/population)*100 as infected_percentage
From PortfolioProject..CovidDeaths
Group by location, population
Order by 1,2
Order by infected_percentage desc