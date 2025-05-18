SELECT 
  products_industry_name,
  COUNT(report_number) AS count_hospitalizations
FROM 
  `bigquery-public-data.fda_food.food_events` 
WHERE products_industry_name IN
  (
    SELECT products_industry_name FROM `bigquery-public-data.fda_food.food_events` 
    GROUP BY products_industry_name
    ORDER BY COUNT(report_number) DESC 
    LIMIT 10
  )
  AND outcomes LIKE '%Hospitalization%'
GROUP BY products_industry_name
ORDER BY count_hospitalizations DESC;
