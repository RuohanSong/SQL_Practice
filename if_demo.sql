SELECT  
  stn,
  date,
  IF (
    temp = 9999.9,
    NULL,
    temp
  ) AS temperature,
  IF (
    wdsp = '999.9',
    NULL,
    CAST(wdsp AS FLOAT64) 
  ) AS wind_speed,
  IF (
    prcp = 99.99,
    0,
    prcp
  ) AS precipitation
FROM 
  `bigquery-public-data.noaa_gsod.gsod2020` 
WHERE
  stn = '725030'  -- La Guardia
  OR stn = '744860' -- JFK
ORDER BY
  date DESC,
  stn ASC
