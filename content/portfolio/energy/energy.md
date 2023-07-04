---
title: "Energy Usage"
date: 2023-05-05T14:49:59-04:00
draft: false
tags:
 - R
 - SQL
 - mariaDB
 - LibreOffice
---

![](../report.gif)

## The Data
The data was obtained from [Our World in Data website](https://ourworldindata.org/explorers/energy). I used the available ```owid-energy-data.csv``` file as source data to be imported into SQL database.

Analysis for power usage was limited to only countries that use all energy sources: coal, gas, oil, hydro, biofuels, solar, wind, and nuclear. Less than 30 countries filfill this requirement.

The energy sources examined can be classified as renewable/carbon-free or non-renewable/carbon-nonfree. I chose not to analyze nuclear energy due to it not fitting nicely into the category of 'green energy' or 'fossil fuel'. Nuclear energy is technically clean energy, however, it is not renewable. Renewable energy is: solar, wind, hydro, and biofuel. Non-renewable is: gas, coal, and oil.

The code described for this project can also be found [here](https://github.com/kim-tynes/EnergySourcesPortfolioProject/) on my github account.

I performed data cleaning with SQL, and then used R to create the visualizations. The final report shown above was created with LibreOffice Impress and then remade into a gif with ImageMagick.

## Data Cleaning
I filtered out countries that did not satisfy my original requirement regarding countries utilizing all energy sources. The results of the SQL queries were saved to CSV, which were imported into R for the creation of visualizations.

The SQL queries can be found [here](https://github.com/kim-tynes/EnergySourcesPortfolioProject/blob/main/energy.sql).

## Data Analysis
The R code can be found [here](https://github.com/kim-tynes/EnergySourcesPortfolioProject/blob/main/energy.R).

## Conclusion
- The United States dominates energy consumption in gas, oil, and biofuel.
- China dominates the coal, solar, hydro, and wind consumption category.
  - India is a distant 2nd in coal consumption.
  - Canada is a distant 2nd in hydro consumption.
  - The United States is a distant 2nd in solar consumption.
