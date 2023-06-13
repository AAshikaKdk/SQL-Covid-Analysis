


---1 Total cases vs total Deaths
Select
	location, date, total_cases,total_deaths, Round((total_deaths/total_cases)*100, 2) as Death_percentage
from [Covid-19]..CovidDeaths

where [Covid-19]..CovidDeaths.location= 'Nepal'
order by 2


---2 Total cases vs total Deaths in Nepal
Select
	location, date, total_cases,total_deaths, Round((total_deaths/total_cases)*100, 2) as Death_percentage
from [Covid-19]..CovidDeaths

where [Covid-19]..CovidDeaths.location= 'Nepal'
order by 2


----3 Total Cases vs population
Select
	location, date, total_cases,population, Round((total_cases/population)*100, 2) as totalcases_percentage
from [Covid-19]..CovidDeaths
where [Covid-19]..CovidDeaths.location = 'India'
order by 2

---4 Countries with highest infection rate compared to population

Select
	location,population, max(total_cases) as Higest_InfectionCount,  Round(Max((total_cases/population))*100, 2) as PercentageHighestInfections
from [Covid-19]..CovidDeaths
Group by location, population
order by PercentageHighestInfections desc


---5 COntinents with Highest Death Count per population

Select
	continent, max(cast(total_deaths as int)) as Highest_Deaths
	
from [Covid-19]..CovidDeaths
where continent is not null
Group by continent
order by Highest_Deaths desc



--6 Total Population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinations
from
	[Covid-19]..CovidDeaths dea
Join
	[Covid-19]..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 1,2,3



--6 Total Percentage of Popultion Vaccinated with CTE
Drop table if exists #PopVsVac;
With PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinations)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinations
from
	[Covid-19]..CovidDeaths dea
Join
	[Covid-19]..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
)
Select*, Round((RollingPeopleVaccinations/population)*100,2) as VaccinatedPopulation
From PopVsVac 





---7 Create a view

Create view VaccinatedPopulations as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinations
from
	[Covid-19]..CovidDeaths dea
Join
	[Covid-19]..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null


