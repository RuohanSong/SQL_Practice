SELECT  
  station_id,
  name,
  number_of_rides AS number_of_rides_starting_at_station
FROM 
  (
    SELECT
      CAST(start_station_id AS STRING) AS start_station_id_str,
      COUNT(*) AS number_of_rides
    FROM
      `bigquery-public-data.new_york.citibike_trips`
    GROUP BY
      CAST(start_station_id AS STRING)
  ) 
  AS station_num_trips
  INNER JOIN
    bigquery-public-data.new_york.citibike_stations
  ON 
    station_id = start_station_id_str
  ORDER BY
    number_of_rides DESC;
