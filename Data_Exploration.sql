
select * from Covidvaccination
select * from Coviddeath

select location, date,total_cases,new_cases, total_deaths,population
from Coviddeath
order by 1,2

-- looking at total cases vs total deaths



select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Percentageofdeaths
from Coviddeath
where location = 'India'
order by date

--Looking at Total cases vs population
--shows what percentage of the population got Covid

select location, date,total_cases,population,(total_cases/population)*100 as Percentageofinfection
from Coviddeath
where location like '%states%'
order by 1,2

-- Lookig at countries with highest infection rate compared to population 


select location,population, max(total_cases)as Highest_cases,
max(( total_cases/population))*100 as percentageofpopulationinected from Coviddeath
group by location,
population
order by percentageofpopulationinected desc

select location,population, max(total_cases)as Highest_cases,
max(( total_cases/population))*100 as percentageofpopulationinected from Coviddeath
where location = 'india'
group by location,
population
order by 1,2

--looking countries with highest deaths count per population


with c 
as
(
select location, population, max(cast(total_deaths as int))as highest_death
from coviddeath
where location ='united kingdom'
group by location,
population
)
select location,population,(highest_death/population)*100 as percentageofdeaths
from c

select location, population, max(cast(total_deaths as int))as highest_death
from coviddeath
where location  ='united kingdom'
group by location, population




--Total Deaths By Continent

select location, sum(cast(total_deaths as int)) as Total_Deaths from Coviddeath
where continent is null
group by location


--Global numbers

select  Date,sum(new_cases) Total_Cases, sum (cast(new_deaths as int))Total_Deaths,
sum (cast(new_deaths as int))/sum(new_cases)*100  as Percentageofdeaths
from Coviddeath
where  continent is not null
group by date 


-- Total Golbal numbers

select  sum(new_cases) Total_Cases, sum (cast(new_deaths as int))Total_Deaths,
sum (cast(new_deaths as int))/sum(new_cases)*100  as Percentageofdeaths
from Coviddeath
where  continent is not null

--Looking at total population vs vaccination 

select * from Covidvaccination
select * from Coviddeath

select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date)
from Coviddeath dea
join Covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null

order by 2,3 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea. location order by dea.location,dea.date) as rolling
from Coviddeath dea
join Covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--percentage of population vaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea. location order by dea.location,dea.date) as rolling,
(sum(convert(bigint,vac.new_vaccinations)) 
over (partition by dea. location order by dea.location,dea.date)/dea.population)*100 as percentageofvaccinated
from Coviddeath dea
join Covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
and dea.location ='India'
order by 2,3

--creating a view to store the data for later visualizaton

create view percentageofpeoplevaccinated 
as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea. location order by dea.location,dea.date) as rolling,
(sum(convert(bigint,vac.new_vaccinations)) 
over (partition by dea. location order by dea.location,dea.date)/dea.population)*100 as percentageofvaccinated
from Coviddeath dea
join Covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select * from percentageofpeoplevaccinated
