SELECT  
    starttime,
    start_station_id,
    tripduration,
    (
        SELECT ROUND(AVG(tripduration), 2)
        FROM `bigquery-public-data.new_york_citibike.citibike_trips`
        WHERE start_station_id = outer_trips.start_station_id
    ) AS avg_duration_for_station,
    
    ROUND(tripduration - (
        SELECT AVG(tripduration)
        FROM `bigquery-public-data.new_york_citibike.citibike_trips`
        WHERE start_station_id = outer_trips.start_station_id), 2) AS difference_from_avg
FROM 
    `bigquery-public-data.new_york_citibike.citibike_trips` AS outer_trips
ORDER BY
    difference_from_avg DESC
LIMIT 25;
   
