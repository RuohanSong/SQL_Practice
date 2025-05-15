SELECT 
  *
FROM 
  `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality` 
WHERE 
  County_of_Residence = 'Erie County, NY'
  OR County_of_Residence = 'Niagara County, NY'
  OR County_of_Residence = 'Chautauqua County, NY'
ORDER BY
  Births DESC;
