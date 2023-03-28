-------To change and Modify the Database name
ALTER DATABASE march MODIFY NAME = Covidproject

-------other way to see whole data table with help of database name
select * 
from Covidproject..Coviddeaths
order by 1,2

select * 
from Covidproject..Covidvaccination
order by 3,4

Select Data that we are going to using
select location, date, total_cases, new_cases, total_deaths, population
from Coviddeaths


select location, date, total_cases, new_cases, total_deaths, population
from Coviddeaths
order by 1,2

select location, date, total_cases, new_cases, total_deaths, population
from Coviddeaths
order by 3,4

-------Using DML command to change 'Null' to '0' in total Cases, total deaths, new_cases 
update Coviddeaths
Set total_cases = 0
where total_cases is Null

update Coviddeaths
Set total_deaths = 0
where total_deaths is Null

update Coviddeaths
Set new_cases = 0
where new_cases is Null

select coalesce(total_deaths,0) from Coviddeaths

------Change the Data type 
ALTER TABLE Coviddeaths ALTER COLUMN total_deaths int

ALTER TABLE Coviddeaths ALTER COLUMN new_cases int

ALTER TABLE Coviddeaths ALTER COLUMN total_cases int

select * 
from Coviddeaths

------Looking  at Total Cases , Total Deaths and Find the Death Percentage 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from Coviddeaths 
order by 1,2

------we have Death Percentage Not show properly beacuse Total Cases , Total Deaths are in Int. So , we have first convert into int to float  
select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 as DeathPercentage 
from Coviddeaths 
order by 1,2

------now find Death Percentage of particular loaction

---------first way
select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 as DeathPercentage 
from Coviddeaths
where location like '%States%' and continent is not Null
order by 1,2

---------second way
select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 as DeathPercentage 
from Coviddeaths
where location = 'United States' and continent is not Null
order by 1,2

------RESULT--- In USA so far in 2023-03-16 total cases are 102417985, total death is 1113229 and percentage is 1.08694678966785,
-------------- Data shows, if we contract Covid in 'USA' then 1.08694678966785 percent will die


------Looking  at Total Cases , Population and Find the pouplation Percentage got Covid 
select location, date,population, total_cases, (CAST(total_cases AS float) / CAST(population AS float))*100 as CovidaffectpouplationPercentage 
from Coviddeaths
where location = 'United States' and continent is not Null
order by 1,2
  
------Looking at countries with highest infection rate compared to population
select location,population, max(total_cases) as HighestInfectionCount, Max(CAST(total_cases AS float) / CAST(population AS float))*100 as CovidaffectpouplationPercentage 
from Coviddeaths
where continent is not Null
group by location,population 

------Descreasing order in CovidaffectpouplationPercentage
select location,population, max(total_cases) as HighestInfectionCount, Max(CAST(total_cases AS float) / CAST(population AS float))*100 as CovidaffectpouplationPercentage 
from Coviddeaths
where continent is not Null
group by location,population 
order by CovidaffectpouplationPercentage desc

------Showing "Countries" with highest death count per population
select location, max(total_cases) as TotalDeathCount 
from Coviddeaths
where continent is not Null
group by location,population 
order by TotalDeathCount desc

------Showing "Continent" with highest death count per population
select continent, max(total_cases) as TotalDeathCount 
from Coviddeaths
where continent is not Null
group by continent 
order by TotalDeathCount desc

------Across the World Global Data show new cases, total cases, new death, total death
select date, sum(total_cases) as Global_total_cases , sum(new_cases) as Global_total_new_cases ,sum(total_deaths) as Global_total_deaths, sum(new_deaths) as Global_total_new_deaths
from Coviddeaths
where continent is not Null
group by date 
order by 1,2

select date, total_cases as Global_total_cases , total_deaths as Global_total_deaths , (total_deaths / total_cases)*100 as Death_Percentage
from Coviddeaths
where continent is not Null
order by 1,2

select date, sum(new_cases) as Global_total_cases , sum(new_deaths) as Global_total_deaths , sum(new_deaths) / sum(new_cases)*100 as Global_Death_Percentage
from Coviddeaths
where continent is not Null
group by date
order by 1,2

select sum(new_cases) as Global_total_cases , sum(new_deaths) as Global_total_deaths , sum(new_deaths)/sum(new_cases)*100 as Global_Death_Percentage
from Coviddeaths
where continent is not Null
order by 1,2

-----result--Accross the world global data Global_total_cases 760384896 , Global_total_deaths 6876500 ,Global_Death_Percentage 0.904344633378936

-----Looking at Data of Both the tables
select * 
from Coviddeaths dea
join Covidvaccination vac
on dea.location = vac.location and dea.date = vac.date

-----Looking at total Population vs Vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from Coviddeaths dea
join Covidvaccination vac
on dea.location = vac.location and dea.date = vac.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from Coviddeaths dea
join Covidvaccination vac
on dea.location = vac.location and dea.date = vac.date
order by 1,2,3

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from Coviddeaths dea
join Covidvaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not NULL
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) 
from Coviddeaths dea
join Covidvaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not NULL
order by 2,3

