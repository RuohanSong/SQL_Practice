SELECT
    tripduration,
    start_station_id,
FROM bigquery-public-data.new_york_citibike.citibike_trips
WHERE start_station_id IN
    (
        SELECT
            start_station_id
        FROM
        (
            SELECT
                start_station_id,
                AVG(tripduration) AS avg_duration
            FROM bigquery-public-data.new_york_citibike.citibike_trips
            GROUP BY start_station_id
        )
        ORDER BY avg_duration DESC
        LIMIT 5
    );