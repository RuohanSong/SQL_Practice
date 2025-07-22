# 197. Rising Temperature

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).


## Solutions

### Using LAG() Function
This solution is the fastest one.
Internally, it is implemented with a single pass through the sorted data, which is much faster than a JOIN.

```
WITH WeatherData AS
(
    SELECT 
        id,
        recordDate,
        temperature,
        LAG(recordDate, 1) OVER (ORDER BY recordDate) AS PreviousDate,
        LAG(temperature, 1) OVER (ORDER BY recordDate) AS PreviousTemperature
    FROM 
        Weather
)

SELECT 
    id
FROM
    WeatherData
WHERE 
    temperature > PreviousTemperature
    AND
    recordDate = Date_ADD(PreviousDate, INTERVAL 1 DAY);
```


### Using JOIN and DATEDIFF()

```
SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2
ON 
    DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE 
    w1.temperature > w2.temperature;
```

### Using Cartesian Product and WHERE Clause
The speed of this one is similar as the JOIN one but more out-dated and not that clear.

```
SELECT 
    w2.id
FROM 
    Weather w1, Weather w2
WHERE 
    DATEDIFF(w2.recordDate, w1.recordDate) = 1 
AND 
    w2.temperature > w1.temperature;
```

