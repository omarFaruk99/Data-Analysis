


use portfolioProject;

-- Q1: select data that we are going to start

select continent, Location, date,new_cases, total_cases, new_deaths, total_deaths, population 
from portfolioProject..covidDeaths
where continent is not null
order by Location, date;



-- Q2: propability of death(%) in a particular country

select continent, Location, date, new_cases, total_cases, new_deaths, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from covidDeaths
where Location like '%states%'
order by date;



-- Q3: show what percentage(%) affected by covid

select Location, date,  population, total_cases, (total_cases/population)*100 as Percent_Affected_Population
from covidDeaths
order by date;




-- Q4: Which country have highest DeatahsNumber

select location, max(cast(total_deaths as int)) as highest_Deaths
from portfolioProject..covidDeaths
where continent is not null
group by location
order by highest_Deaths Desc;


select continent, location from portfolioProject..covidDeaths
order by location;


--Q5: Showing which Continent have highest number Deaths

select continent, max(cast(total_deaths as int)) as Highest_death_continent
from portfolioProject..covidDeaths
--where continent is not null
group by continent 
order by Highest_death_continent desc;




-- Q6: show total number of Deaths all over the world per day

select sum(total_cases) as total_ffected, sum(cast(total_deaths as int)) as total_affected, sum(cast(total_deaths as int))/sum(total_cases)*100 as total_deaths_world
from portfolioProject..covidDeaths
where continent is not null
order by total_deaths_world desc;


-- Q7: Totall new vaccination at every country per day/date

select d.continent, d.location, d.date, d.population, v.new_vaccinations,sum(cast(v.new_vaccinations as bigint))
over (partition by d.location order by d.location, d.date) as total_vaccination
from portfolioProject..covidDeaths d join portfolioProject..covidVaccination v
on d.date = v.date
and d.location = v.location
where d.continent is not null
order by 2,3;


-- Q8: Use CTE for further calculation(New vaccination per country).... with previous

with cte_table(continent, location, date, population, new_vaccinations, total_vaccination)
as
(select d.continent, d.location, d.date, d.population, v.new_vaccinations,sum(cast(v.new_vaccinations as bigint))
over (partition by d.location order by d.location, d.date) as total_vaccination
from portfolioProject..covidDeaths d join portfolioProject..covidVaccination v
on d.date = v.date
and d.location = v.location
where d.continent is not null
)
select *, (total_vaccination/population)*100 as t_vacc_per from cte_table;



-- Q9: use Temp table with previous

drop table if exists #Temp_table
create table #Temp_table(

continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_vaccination numeric
)

insert into #Temp_table
select d.continent, d.location, d.date, d.population, v.new_vaccinations,sum(cast(v.new_vaccinations as bigint))
over (partition by d.location order by d.location, d.date) as total_vaccination
from portfolioProject..covidDeaths d join portfolioProject..covidVaccination v
on d.date = v.date
and d.location = v.location
where d.continent is not null


select *, (total_vaccination/population)*100 as t_vacc_per from #Temp_table;



-- Q10: Creating View to Store Data

Create View vtotalVacciniedPercentage as 
select d.continent, d.location, d.date, d.population, v.new_vaccinations,sum(cast(v.new_vaccinations as bigint))
over (partition by d.location order by d.location, d.date) as total_vaccination
from portfolioProject..covidDeaths d join portfolioProject..covidVaccination v
on d.date = v.date
and d.location = v.location
where d.continent is not null




select * from vtotalVacciniedPercentage