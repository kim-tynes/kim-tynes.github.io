#!/usr/bin/env python3

# Author: Kim Tynes
# Description: Grabs and stores into sqlite database 
#  weather information from WeatherAPI.

import os
import sys
import requests
import json
import datetime
import sqlite3
import pandas as pd

API_KEY='REDACTED'

if (len(sys.argv) > 1):
    LOCATION=sys.argv[1]
else:
    LOCATION='76021'

SAVE_HERE=os.path.join(os.environ['HOME'], 'data', 'misc', 'weather')
BASE_URL = 'https://api.weatherapi.com/v1'
FETCH_URL = BASE_URL + '/current.json' + '?key=' + API_KEY + '&q=' + LOCATION + '&aqi=yes'

response = requests.get(FETCH_URL)

if response.ok is True:
    json_text = response.json()
    tempf = json_text['current']['temp_f']
    tempc = json_text['current']['temp_c']
    skies = json_text['current']['condition']['text']
    humid = json_text['current']['humidity']
    date = pd.to_datetime(json_text['current']['last_updated'], format='%Y-%m-%d %H:%M')
    thetime = date.strftime('%H:%M')
    thedate = date.strftime('%Y-%m-%d')
    feels_f = json_text['current']['feelslike_f']
    feels_c = json_text['current']['feelslike_c']
    wind_speed = json_text['current']['wind_mph']
    wind_dir = json_text['current']['wind_dir']
    uv = json_text['current']['uv']
    aqi_pm25 = json_text['current']['air_quality']['pm2_5']
    aqi_pm10 = json_text['current']['air_quality']['pm10']
    aqi_co = json_text['current']['air_quality']['co']
    aqi_ozone = json_text['current']['air_quality']['o3']
    aqi_nitro = json_text['current']['air_quality']['no2']
    aqi_sulph = json_text['current']['air_quality']['so2']
    aqi_index = json_text['current']['air_quality']['us-epa-index']
    visibility = json_text['current']['vis_miles']

    year = date.strftime('%Y')
    storehere = os.path.join(os.environ['HOME'], 'data', 'misc', 'weather', year)

    if os.path.isdir(storehere) is False:
        os.makedirs(storehere)

    DB = storehere + '/' + year + '-weather.db'

    # Save weather data to SQLite database
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()
    weatherfile = 'the_weather'

    # Create database table
    query = 'CREATE TABLE IF NOT EXISTS ' + weatherfile + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
    query += """code TEXT NOT NULL,
        the_date TEXT,
        the_time TEXT,
        temp_f REAL,
        temp_c REAL,
        feelslike_f REAL,
        feelslike_c REAL,
        humidity REAL,
        uv REAL,
        pm2_5 REAL,
        pm10 REAL,
        carbon_monoxide REAL,
        ozone REAL,
        nitrogen REAL,
        sulphur REAL,
        aqi_index INT,
        visible REAL,
        wind_speed REAL,
        wind_direction TEXT,
        sky TEXT
    )
    """
    cursor.execute(query)

    # Save weather values
    query = "INSERT INTO " + weatherfile
    query += ' (code,the_date,the_time,temp_f,temp_c,feelslike_f,feelslike_c,humidity,uv,pm2_5,pm10,carbon_monoxide,ozone,nitrogen,sulphur,aqi_index,visible,wind_speed,wind_direction,sky) VALUES (' + LOCATION + ','
    query += "'" + date.strftime('%Y-%m-%d') + "', "
    query += "'" + thetime + "', "
    query += str(tempf) + ', '
    query += str(tempc) + ', ' 
    query += str(feels_f) + ', '
    query += str(feels_c) + ', '
    query += str(humid) + ', '
    query += str(uv) + ', '
    query += str(aqi_pm25) + ', '
    query += str(aqi_pm10) + ', '
    query += str(aqi_co) + ', '
    query += str(aqi_ozone) + ', '
    query += str(aqi_nitro) + ', '
    query += str(aqi_sulph) + ', '
    query += str(aqi_index) + ', '
    query += str(visibility) + ', '
    query += str(wind_speed) + ', '
    query += "'" + wind_dir + "', "
    query += "'" + skies + "');"

    cursor.execute(query)
    conn.commit()
    conn.close()

    # Save JSON to file, overwrites
    path = '/tmp'
    filename = path + '/weather_' + LOCATION + '/' + date.strftime('%Y%m%d') + '.json'

    if os.path.isdir(path + '/weather_' + LOCATION + '/') is False:
        os.makedirs(path + '/weather_' + LOCATION)

    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(response.json(), f, ensure_ascii=False, indent=4)
    
else:
    print("Error {}".format(response.status_code))
    print(response.json())
