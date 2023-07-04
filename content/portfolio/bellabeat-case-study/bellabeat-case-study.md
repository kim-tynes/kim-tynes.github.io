---
title: "Bellabeat Case Study"
date: 2023-05-25T10:22:55-04:00
draft: false
tags:
 - R
 - SQL
 - Tableau
---


## Introduction
Bellabeat is a high-tech company that manufactures health-focused 
smart products that are beautifully designed to inform and inspire 
women around the world. Collecting data on activity, sleep, stress, 
and reproductive health has allowed Bellabeat to empower women with 
knowledge about their own health and habits. Since it was founded in 
2013, Bellabeat has grown rapidly and quickly positioned itself as 
a tech-driven wellness company for women.

## Business Problem
Bellabeat has the potential to become a larger player in the global 
smart device market. Analyzing smart device fitness data could help 
unlock new growth opportunities for the company.

## Business Task
Analyze smart device fitness data to discover trends in order to find 
new growth opportunities for Bellabeat.

Key stakeholders:

- The founders of Bellabeat
- Marketing team of Bellabeat

## The Data
### Data Source
The dataset used is the public dataset available at 
https://www.kaggle.com/datasets/arashnic/fitbit. The dataset is licensed under 
CC0: Public Domain. The dataset contains personal fitness tracker from 
thirty fitbit users. Thirty eligible Fitbit users consented to the 
submission of personal tracker data, including minute-level output for 
physical activity, heart rate, and sleep monitoring. It includes 
information about daily activity, steps, and heart rate that can be used 
to explore users' habits.

### Dataset Limitation
The dataset is limited to one month of user daily mobile activity and sleep 
activity data.

## Data Cleaning
The R code used for the data cleaning and analysis process can be found 
[here](../case-study.R).

The SQL code used to populate ```activity-data.csv``` for a portion of the data 
cleaning:

```
SELECT Id,
	SUM(VeryActiveMinutes) AS TotalVeryActiveMinutes,
	SUM(SedentaryMinutes) AS TotalSedentaryMinutes
FROM dailyActivity_merged
GROUP BY Id
```

Upon loading the data into R, I noticed the data required some tidying 
in order to attempt any sort of analysis.
  - I standardized column names with ```clean_names()```.
  - I cleaned up dates from a character format to a date 
  format with ```as.Date()```.
  - I cleaned up id data from a number format to a character format 
  for easier plotting with ```as.numeric()```.

## Data Analysis
![](../analysis-1.png)
![](../analysis-2.png)
![](../analysis-3.png)
![](../analysis-4.png)
![](../analysis-5.png)
![](../analysis-6.png)
![](../analysis-7.png)
![](../analysis-8.png)

[Tableau visuals](https://public.tableau.com/views/BellabeatCaseStudy_16849396365620/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)
