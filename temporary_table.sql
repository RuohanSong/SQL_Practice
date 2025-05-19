WITH longest_used_bike AS (
  SELECT 
    bike_id,
    SUM(duration_minutes) AS trip_duration
  FROM
    `bigquery-public-data.austin_bikeshare.bikeshare_trips` 
  GROUP BY 
    bike_id
  ORDER BY 
    trip_duration DESC
  LIMIT 1
)

## find station where the longest-used bike leaves most often

SELECT  
  trips.start_station_id,
  COUNT(*) AS trip_ct
FROM
  longest_used_bike AS longest
INNER JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
ON trips.bike_id = longest.bike_id
GROUP BY trips.start_station_id
ORDER BY trip_ct DESC
LIMIT 1
