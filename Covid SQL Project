/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views
*/

-- Total Cases vs Total Deaths
-- Shows liklihood of dying if you contract Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid

Select location, date, total_cases, population, (total_cases/population)*100 as population_infected_percentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select location, MAX(total_cases) as highest_infection_count, population, MAX((total_cases/population))*100 as population_infected_percentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location, population
order by population_infected_percentage desc

--Countries with Highest Death Count per Population

Select location, MAX(total_deaths) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location
order by total_death_count desc

-- Breaking Things Down by Continent

Select continent, MAX(total_deaths) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent
order by total_death_count desc

-- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group By date
order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition By dea.location Order by dea.location, dea.date) as rolling_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Using CTE to preform calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition By dea.location Order by dea.location, dea.date) as rolling_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null
)
Select *, (rolling_vaccinations/population)*100 as population_vaccinated
From PopvsVac

--Using Temp Table to preform calculation on Partition By in previous query

Drop Table if exists #Population_Vaccinated
Create Table #Population_Vaccinated
(
contient NVARCHAR(50),
location NVARCHAR(50),
date DATETIME,
population FLOAT,
new_vaccination FLOAT,
rolling_vaccinations FLOAT
)

Insert into #Population_Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition By dea.location Order by dea.location, dea.date) as rolling_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null

Select *, (rolling_vaccinations/population)*100 as population_vaccinated
From #Population_Vaccinated

-- Creating Views to Store Data for Later Visualizations

Create View DeathPercentage as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where continent is not null

Create View PopulationInfectedPercentage as
Select location, date, total_cases, population, (total_cases/population)*100 as population_infected_percentage
From PortfolioProject..CovidDeaths
Where continent is not null

Create View CountryDeathCount as
Select location, MAX(total_deaths) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location

Create View ContinentDeathCount as 
Select continent, MAX(total_deaths) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent

Create View RollingVaccinations as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition By dea.location Order by dea.location, dea.date) as rolling_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null