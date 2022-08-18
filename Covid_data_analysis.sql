/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

/* CREATE database then import data using either the import wizrd or code below. */

/* Check a table is made.. with some parameters*/
Select *
From covid_data.covid_deaths
Where continent is not null 
order by 3,4;
/* Check again for the second table, if it is made.. and pull up table with some parameters applied*/

SELECT * FROM covid_vaccinations WHERE continent = '' AND location LIKE '%a';

/* Population and Total Vaccinations of each Continent. Need to join the two relevant tables by matching location and date */

Select dea.continent, dea.location, dea.date as date,  dea.population, CAST(vac.total_vaccinations as SIGNED)
	FROM covid_deaths dea
    JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent = ''
order by 2,5 ;

/*  Creating a table to insert our data  + Drop table table if already present */
DROP TABLE IF EXISTS PercentagePopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date date,
Population INT,
New_vaccinations INT,
RollingPeopleVaccinated INT
);

/* insert data into new table *  + Also need to change data type to date for the date field */
Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, str_to_date(dea.date, '%d/%m/%Y'), CAST(dea.population as SIGNED), CAST(vac.new_vaccinations as SIGNED), CAST(vac.total_vaccinations as SIGNED)
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;
    
/* Create View for visualisations in the future. */
Create View PercentPopulationVaccinated_view as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From covid_deaths dea
JOIN covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
    
where dea.continent is not null ;
 
