---
title: "COVID Deaths"
date: 2023-05-03T12:03:06-04:00
draft: true
tags:
 - R
 - SQL
---

This is a hobby project I conducted to find any kind of insights about COVID deaths between the countries of the world.
## Data Cleaning
I used a combination of SQL and R to conduct data cleaning and data analysis.

## R environment setup
The packages used for this project include:
  - tidyverse
  - ggplot2
  - ggspatial
  - lwgeom
  - sf
  - rnaturalearth
  - rnaturalearthdata

### Install the needed packages.
```
if(!require("tidyverse")) {
	install.packages("tidyverse")
}
if(!require("ggplot2")) {
	install.packages("ggplot2")
}
if(!require("ggspatial")) {
	install.packages("ggspatial")
}
if(!require("lwgeom")) {
	install.packages("lwgeom")
}
if(!require("sf")) {
	install.packages("sf")
}
if(!require("rnaturalearth")) {
	install.packages("rnaturalearth")
}
if(!require("rnaturalearthdata")) {
	install.packages("rnaturalearthdata")
}
```

### Load the necessary packages into session.
```
library(tidyverse)
library(ggplot2)
library(ggspatial)
library(lwgeom)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
```

## The Data
I used the freely available datasets [here](https://ourworldindata.org/covid-deaths), the resulting download was for ```owid-covid-data.csv```, which has data stats up to April 26, 2023.

## Data Analysis
### Load the dataset into R environment.
```
dataset <- read.csv("owid-covid-data.csv")
```


### Examine the dataset.
```
head(dataset)
str(dataset)
colnames(dataset)
```

### Examine the total cases compared to the total deaths in Canada.
```
a <- dataset %>%
  filter(location == "Canada") %>%
  select(location, date, total_cases, total_deaths) %>%
  arrange(location, desc(date)) %>%
  mutate(deathPercentage = (total_deaths/total_cases)*100)

options(scipen=999)
ggplot(a, aes(total_cases, total_deaths, color = deathPercentage)) +
  geom_point() +

  # Change text labels
  ggtitle("Cases Vs Deaths In Canada", 
          subtitle="From ourworldindata.org covid dataset") + 
  xlab("Cases") + 
  ylab("Deaths") + 
  
  # Zoom in without clipping
  coord_cartesian(xlim=c(0,4500000), ylim=c(0, 55000)) +

  # Theme
  theme_classic()
```

![Graph of Cases Vs Deaths In Canada Since Jan 2020](../../covid/deathRateInCanada.png)


### Examine total cases compared to population in Canada.
```
gotCovid <- dataset %>%
  filter(location == "Canada") %>%
  select(location, date, population, total_cases) %>%
  arrange(location, date) %>%
  mutate(percent_population_infected = format(round(((total_cases/population)*100), 2), nsmall = 2))

ggplot(gotCovid, aes(total_cases, percent_population_infected)) + 
  # Set color to vary based on continent category
  geom_col(aes(col=percent_population_infected)) + 
  geom_smooth(se=FALSE) + 
  ggtitle("Cases Vs Infection Percentage In Canada", 
          subtitle="From covid dataset") + 
  xlab("Cases") + 
  ylab("Infections") + 
  scale_y_discrete(breaks=seq(0, 12, 0.5)) +
  theme_light() +
  theme(legend.position="None")
```

### Examine infection rate compared to population between the countries.
For this examination, I ended up using SQL as I experienced numerous issues using R to filter by location while removing NA values. I will need to research this for future reference. Exported the SQL query results to a CSV file which is imported in the below code.
```
SELECT cd.location, 
	cd.population,
	MAX(cd.total_cases) AS highest_infection_count, 
	MAX((cd.total_cases/cd.population))*100 AS percent_population_infected
FROM covid_data cd 
GROUP BY cd.location, cd.population 
ORDER BY percent_population_infected DESC 
```

```
infectionRate <- read.csv("infection-count.csv")
g <- infectionRate %>%
  #filter(!is.na(highest_infection_count) | !is.na(percent_population_infected)) %>%
  arrange(desc(percent_population_infected))

# Prepare data for map plot
mapData <- map_data("world")
dataToMap <- data.frame(highest_infection_count = g$highest_infection_count, region = g$location)

# Check for location name differences that need to be adjusted so they are 
# not omitted in map
#setdiff(mapData$region, dataToMap$region)
dataToMap <- dataToMap %>%
  mutate(region = ifelse(region == "United States", "USA", region),
         region = ifelse(region == "Democratic Republic of Congo", "Democratic Republic of the Congo", region),
         region = ifelse(region == "Congo", "Republic of Congo", region),
         region = ifelse(region == "Cote d'Ivoire", "Ivory Coast", region),
         region = ifelse(region == "Czechia", "Czech Republic", region),
         region = ifelse(region == "Eswatini", "Swaziland", region))

ggplot() +
  # World Map
  geom_map(data = mapData, map = mapData, 
           aes(x = mapData$long, y = mapData$lat, group = mapData$group, map_id = region),
           fill = "white", colour = "#7F7F7F", size = 0.5) +

  # Data on World Map
  geom_map(data = dataToMap, map = mapData,
           aes(fill = highest_infection_count, map_id = region),
           colour = "#7F7F7F", size = 0.5) + 

  # Change data colors
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +

  # Change labels
  xlab("") + ylab("") + 
  ggtitle("Highest COVID Infections Around The World", subtitle = "As of 2023-04-26") +

  # Set BW theme
  theme_bw()
```

![Map of Infection Rate Across Countries](../../covid/infectionRate.png)

### Examine countries with highest death count compared to population.
```
SELECT cd.location, 
	MAX(CAST(cd.total_deaths AS int)) AS total_death_count 
FROM covid_data cd 
WHERE cd.continent != ""
GROUP BY cd.location 
ORDER BY total_death_count DESC 
```

```
deathCount <- read.csv("death-by-country.csv")

# Prepare data or map plot
mapData <- map_data("world")
dataToMap <- data.frame(total_death_count = deathCount$total_death_count, region = deathCount$location)

# Check for location name differences that need to be adjusted so they are 
# not omitted in map
#setdiff(mapData$region, dataToMap$region)
dataToMap <- dataToMap %>%
  mutate(region = ifelse(region == "United States", "USA", region),
         region = ifelse(region == "Democratic Republic of Congo", "Democratic Republic of the Congo", region),
         region = ifelse(region == "Congo", "Republic of Congo", region),
         region = ifelse(region == "Cote d'Ivoire", "Ivory Coast", region),
         region = ifelse(region == "Czechia", "Czech Republic", region),
         region = ifelse(region == "Eswatini", "Swaziland", region))

ggplot() +
  # World Map
  geom_map(data = mapData, map = mapData, 
           aes(x = mapData$long, y = mapData$lat, group = mapData$group, map_id = region),
           fill = "white", colour = "#7F7F7F", size = 0.5) +

  # Data on World Map
  geom_map(data = dataToMap, map = mapData,
           aes(fill = total_death_count, map_id = region),
           , colour = "#7F7F7F", size = 0.5) + 

  # Change data colors
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +

  # Change labels
  xlab("") + ylab("") + 
  ggtitle("Total COVID Deaths Around The World", subtitle = "As of 2023-04-26") +

  # Set BW theme
  theme_bw()
```

![Map Showing Death Count Across The World](../../covid/totalDeathsByCountry.png)

## Conclusion
- The United States ranks highest with the amount of COVID deaths overall. The amount of deaths was highest during the start of data tracking, but has lowered since.
- The United States, India, Brazil, and Russia track the highest amount of COVID infections and deaths.
