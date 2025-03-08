---
title: "Weather Project"
date: 2025-03-08T13:05:16-05:00
draft: false
tags: 
 - Python
 - SQL
 - SQLite
 - API
---

The purpose of this project is to keep track of weather 
conditions for specific locations, and to analyze weather 
trends for those areas..

## Environment Setup
This project utilizes Python and SQLite.

 - Python 3
   - Package: requests
   - Package: pandas
 - SQLite 3

For larger datasets, SQLite can be switched for another 
RDBMS such as MySQL.

## The Data
### Data Source
The data used is publicly available from 
[weatherAPI](https://www.weatherapi.com). The data contains 
information including the temperature, wind direction, UV 
level, and more.

### Dataset Limitation
The data extracted is not all-inclusive, but this can be 
modified as desired.

## Data Cleaning
Current data is obtained every hour using the command: 

```
python3 weather.py "76021"
```

I change the "76021" with the appropriate zip code or 
location data I am interested in tracking long term.

The Python code used for the data extraction and cleaning 
process can be found [here](../weather.py).

## Data Analysis
On a monthly basis, I run some analysis on the data using 
the command:

```
python3 getweatherstats.py
```

The Python code used for the data analysis can be found 
[here](../getweatherstats.py).

Which gives [results](../2.log) similar to:

```
Using db file: /home/kim/data/misc/weather/2025/2025-weather.db
Max Temperatures:
    code  max_temp    the_date the_time
0  30228      77.2  2025-02-07    16:15
1  44060      52.0  2025-02-03    14:30
2  44114      54.0  2025-02-03    14:30
3  76021      86.7  2025-02-08    14:30

Min Temperatures:
    code  min_temp    the_date the_time
0  30228      12.0  2025-01-22    07:30
1  44060      -4.9  2025-01-22    08:15
2  44114      -5.1  2025-01-22    08:15
3  76021      12.9  2025-02-19    07:30

Average Temperatures:
    code  avg_temp
0  30228      45.3
1  44060      26.1
2  44114      27.2
3  76021      45.9

Best Air Quality:
    code  air_quality    the_date the_time
0  30228            1  2025-01-01    00:30
1  44060            1  2025-01-01    01:00
2  44114            1  2025-01-01    00:30
3  76021            1  2025-01-01    00:30

Worst Air Quality:
    code  air_quality    the_date the_time
0  76021            4  2025-01-15    14:00
1  30228            4  2025-01-02    17:30
2  44114            3  2025-02-02    13:30
3  44060            3  2025-01-10    05:15

Sky Conditions:
     code                                  sky  count
0   44060                             Overcast    894
1   76021                        Partly cloudy    637
2   44114                             Overcast    450
3   30228                                Clear    336
4   30228                                Sunny    318
5   30228                        Partly cloudy    315
6   76021                             Overcast    282
7   30228                             Overcast    272
8   44114                                Clear    241
9   44114                        Partly cloudy    212
10  44060                                Clear    195
11  76021                                Clear    186
12  44114                           Light snow    178
13  44060                        Partly cloudy    175
14  44114                                Sunny    140
15  44060                                Sunny    124
16  76021                                Sunny    100
17  30228                                 Mist     72
18  44114                                 Mist     70
19  76021                                 Mist     68
20  44114                           Light rain     56
21  30228                           Light rain     51
22  76021                           Light rain     50
23  44114                    Patchy light snow     30
24  30228                                  Fog     17
25  76021                        Light drizzle     17
26  76021                    Patchy light snow     14
27  76021                           Light snow     11
28  76021                                  Fog     10
29  44114                         Freezing fog      7
30  76021       Patchy light rain with thunder      7
31  44114                                  Fog      5
32  30228                           Heavy rain      4
33  44060                               Cloudy      4
34  44060                           Light snow      4
35  44114                  Light freezing rain      4
36  76021                        Partly Cloudy      4
37  30228                         Freezing fog      3
38  30228  Moderate or heavy rain with thunder      3
39  44060                        Partly Cloudy      3
40  44114                        Moderate snow      3
41  44114                        Partly Cloudy      3
42  76021  Moderate or heavy rain with thunder      3
43  30228                        Light drizzle      2
44  30228                  Light freezing rain      2
45  30228                           Light snow      2
46  30228                        Moderate rain      2
47  76021                               Cloudy      2
48  76021                           Heavy rain      2
49  76021                  Light freezing rain      2
50  76021                        Moderate snow      2
51  30228                               Cloudy      1
52  30228                        Partly Cloudy      1
53  30228       Patchy light rain with thunder      1
54  30228                 Patchy snow possible      1
55  44060                                  Fog      1
56  44060                         Freezing fog      1
57  44060                           Light rain      1
58  44060                    Patchy light snow      1
59  44114                               Cloudy      1
60  44114                           Heavy snow      1
61  44114  Moderate or heavy rain with thunder      1
62  44114       Patchy light rain with thunder      1
63  76021                           Heavy snow      1
64  76021                          Ice pellets      1
65  76021                          Light sleet      1
66  76021          Thundery outbreaks possible      1
```