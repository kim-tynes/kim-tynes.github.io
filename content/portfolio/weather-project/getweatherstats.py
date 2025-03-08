#!/usr/bin/env python3

import os
import sys
import sqlite3
import pandas as pd
from datetime import datetime

currentYear = datetime.now().year
currentMonth = datetime.now().month - 1
db_path = os.path.join(os.environ['HOME'],'data','misc','weather')

if len(sys.argv) > 1:
    db_file = sys.argv[1]
    if os.path.isfile(db_file):
        filename = db_file.split("/")[-1]
    else:
        filename = str(currentYear) + '-weather.db'
        db_file = os.path.join(db_path,str(currentYear),filename)

    if os.path.isfile(db_file):
        test_for_year = db_file.split("/")

        if currentYear > int(test_for_year[-2]):
            currentMonth = 12
        if (test_for_year[-2].isnumeric()):
            currentYear = test_for_year[-2]

else:
    filename = str(currentYear) + '-weather.db'
    db_file = os.path.join(db_path,str(currentYear),filename)

f = db_path + str(currentYear) + "/" + str(currentMonth) + ".log"
logfile = open(f, "a")

# Ensure all rows are displayed, rather than 
#
# 0
# 1
# 2
# .. .....
# 98
# 99
pd.set_option('display.max_rows', None)

print('Using db file:', db_file, file=logfile)
con = sqlite3.connect(db_file)

cur = con.cursor()
res = cur.execute("""
    SELECT code, MAX(temp_f) max_temp, the_date, the_time
    FROM the_weather
    GROUP BY 1;
""")
columns = ['code', 'max_temp', 'the_date', 'the_time']
df = pd.DataFrame(res.fetchall(), columns=columns)
print('Max Temperatures:', file=logfile)
print(df, file=logfile)
# pprint.pprint(res.fetchall())

print('\nMin Temperatures:', file=logfile)
res = cur.execute("""
    SELECT code, MIN(temp_f) min_temp, the_date, the_time
    FROM the_weather
    GROUP BY 1;
""")
columns = ['code', 'min_temp', 'the_date', 'the_time']
df = pd.DataFrame(res.fetchall(), columns=columns)
# pprint.pprint(res.fetchall())
print(df, file=logfile)

print('\nAverage Temperatures:', file=logfile)
res = cur.execute("""
    SELECT code, ROUND(AVG(temp_f), 1) avg_temp
    FROM the_weather
    GROUP BY 1;
""")
columns = ['code', 'avg_temp']
df = pd.DataFrame(res.fetchall(), columns=columns)
# print(res.fetchall())
# pprint.pprint(res.fetchall())
print(df, file=logfile)

print('\nBest Air Quality:', file=logfile)
res = cur.execute("""
    SELECT code, MIN(aqi_index) air_quality, the_date, the_time
    FROM the_weather
    GROUP BY 1;
""")
columns = ['code', 'air_quality', 'the_date', 'the_time']
df = pd.DataFrame(res.fetchall(), columns=columns)
print(df, file=logfile)

print('\nWorst Air Quality:', file=logfile)
res = cur.execute("""
    SELECT code, MAX(aqi_index) as air_quality, the_date, the_time
    FROM the_weather
    GROUP BY 1
    ORDER BY 2 DESC;
""")
columns = ['code', 'air_quality', 'the_date', 'the_time']
df = pd.DataFrame(res.fetchall(), columns=columns)
print(df, file=logfile)

print('\nSky Conditions:', file=logfile)
res = cur.execute("""
    SELECT code, sky, COUNT(sky) count
    FROM the_weather
    GROUP BY 1, 2
    ORDER BY 3 DESC;
""")
columns = ['code', 'sky', 'count']
df = pd.DataFrame(res.fetchall(), columns=columns)
print(df, file=logfile)

logfile.close()
con.close()
