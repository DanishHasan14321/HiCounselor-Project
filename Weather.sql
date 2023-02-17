CREATE database weather;

CREATE TABLE `weather`.`weather_data` (
  `Date` DATE NULL,
  `Temperature` FLOAT NULL,
  `Average Humidity(%)` FLOAT NULL,
  ` Average dewpoint (A°F)` FLOAT NULL,
  ` Average barometer (in)` FLOAT NULL,
  ` Average windspeed (mph)` FLOAT NULL,
  ` Average gustspeed (mph)` FLOAT NULL,
  ` Average direction (A°deg)` FLOAT NULL,
  ` Rainfall for month (in)` FLOAT NULL,
  `Rainfall for year (in)` FLOAT NULL,
  ` Maximum rain per minute` FLOAT NULL,
  ` Maximum temperature (A°F)` FLOAT NULL,
  ` Minimum temperature (Â°F)` FLOAT NULL,
  ` Maximum humidity (%)` FLOAT NULL,
  ` Minimum humidity (%)` FLOAT NULL,
  ` Maximum pressure` FLOAT NULL,
  ` Minimum pressure` FLOAT NULL,
  ` Maximum windspeed (mph)` FLOAT NULL,
  ` Maximum gust speed (mph)` FLOAT NULL,
  ` Maximum heat index (Â°F)` FLOAT NULL,
  ` Month` INT NULL,
  ` diff_pressure` FLOAT NULL);
  
ALTER TABLE weather.weather_data MODIFY ` Maximum heat index (Â°F)` DECIMAL(5,2);
ALTER TABLE weather.weather_data MODIFY ` Minimum temperature (Â°F)` DECIMAL(5,2);
ALTER TABLE weather.weather_data MODIFY ` Maximum temperature (A°F)` DECIMAL(5,2);
ALTER TABLE weather.weather_data MODIFY ` Average dewpoint (A°F)` DECIMAL(5,2);
ALTER TABLE weather.weather_data MODIFY `Temperature` DECIMAL(5,2);

-- 1. Give the count of the minimum number of days for the time when temperature reduced
SELECT COUNT(*) FROM (SELECT Date, Temperature, LAG(Temperature) 
OVER(ORDER BY Date) AS prev_temp 
FROM Weather.Weather_data)t WHERE temperature<prev_temp;


-- 2. Find the temperature as Cold / hot by using the case and avg of values of the given data set
SELECT 
    date,
    temperature,
    AVG(temperature) AS avg_temp,
    CASE
        WHEN temperature > 25 THEN 'HOT'
        ELSE 'COLD'
    END AS HOTorCOLD
FROM
    weather.weather_data
GROUP BY date;


-- 3. Can you check for all 4 consecutive days when the temperature was below 30 Fahrenheit
-- SELECT Date, Temperature FROM (ELECT Date, Temperature,SUM(CASE WHEN Temperature < 30 THEN 1 ELSE 0 END) OVER 
-- (ORDER BY Date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS below_30_countFROM weather.weather_data) t WHERE below_30_count = 4;-
CREATE TEMPORARY TABLE t1 SELECT Date, Temperature,
         SUM(CASE WHEN Temperature < 30 THEN 1 ELSE 0 END) 
           OVER (ORDER BY Date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS below_30_count
  FROM weather.weather_data;
  SELECT date, temperature FROM t1 WHERE below_30_count = 4;

-- SELECT date, temperature, SUM(CASE WHEN Temperature < 30 THEN 1 ELSE 0 END) FROM weather.weather_data;
-- CREATE TEMPORARY TABLE temporary_table_name SELECT * FROM weather.weather_data;
-- SELECT 'below',date, temperature FROM weather.weather_data WHERE CASE WHEN id = 1;


-- 4. Can you find the maximum number of days for which temperature dropped
SELECT MAX(count_days) FROM (
SELECT
t1.Date,
t1.temperature,
(
SELECT COUNT(*)
FROM weather.weather_data t2
WHERE t2.Date < t1.Date AND t2.Temperature < t1.Temperature
) AS count_days
FROM weather.weather_data t1
) AS temp_diff
WHERE Temperature < (
SELECT Temperature FROM weather.weather_data t2
WHERE t2.Date < temp_diff.Date
ORDER BY Date DESC
LIMIT 1
);

With weather_data_temp as (select date, temperature, lag(temperature, 1) OVER (order by date) as prev_temp from weather.weather_Data)
select date, temperature, prev_temp, case when prev_temp <= temperature then 0 else 1
end as drop_temp_indicator,
sum(case when prev_temp <= temperature then 0 else 1
end) OVER (order by date rows between unbounded preceding and current row) as drop_temp from weather_data_temp order by date;


-- 5. Can you find the average of average humidity from the dataset 
-- ( NOTE: should contain the following clauses: group by, order by, date )
SELECT 
    AVG(avg_humidity) AS avg_of_avg_hum
FROM
    (SELECT 
        date, AVG(`Average Humidity(%)`) AS avg_humidity
    FROM
        weather.weather_data
    GROUP BY date
    ORDER BY date) as derivedtable;
    

-- 6. Use the GROUP BY clause on the Date column and make a query to fetch details for average windspeed ( which is now windspeed done in task 3 )
SELECT 
    date, ` Average windspeed (mph)` AS avg_wind_speed
FROM
    weather.weather_data
GROUP BY date
LIMIT 25;


-- 7. Please add the data in the dataset for 2034 and 2035 as well as forecast predictions for these years 
-- ( NOTE: data consistency and uniformity should be maintained )


-- 8. If the maximum gust speed increases from 55mph, fetch the details for the next 4 days
 SELECT 
   *
 FROM weather_data
 WHERE 
   Date >= (
     SELECT MIN(Date) 
     FROM weather_data 
     WHERE ` Maximum gust speed (mph)` >= 55
   ) 
   AND Date <= (
     SELECT MIN(Date) + INTERVAL 4 DAY 
     FROM weather_data 
     WHERE ` Maximum gust speed (mph)` >= 55
   );


-- 9. Find the number of days when the temperature went below 0 degrees Celsius
SELECT 
    COUNT(temperature) AS number_of_days
FROM
    (SELECT 
        date, temperature
    FROM
        weather.weather_data
    WHERE
        temperature < 0) AS temp;
        
        
-- 10. Create another table with a “Foreign key” relation with the existing given data set.

ALTER TABLE weather.weather_data ADD column id INT AUTO_INCREMENT PRIMARY KEY FIRST;

CREATE TABLE weather.order_or (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    id int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (id) REFERENCES weather.weather_data(id)
);