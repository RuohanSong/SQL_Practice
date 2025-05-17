SELECT
	station_id,
	name
FROM
	bigquery-public-data.new_york.citibike_stations
WHERE
	station_id IN
	(
		SELECT
			CAST(start_station_id AS STRING) AS start_station_id_str 
		FROM
	    	bigquery-public-data.new_york.citibike_trips
	  	WHERE
			usertype = 'Subscriber'
  	);