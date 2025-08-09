# 1211. Queries Quality and Percentage
`easy`

Table: `Queries`
```ruby
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
```

> This table may have duplicate rows.

> This table contains information collected from some queries on a database.

> The `position` column has a value from 1 to 500.

> The `rating` column has a value from 1 to 5. Query with `rating` less than 3 is a poor query.
 


We define query `quality` as:

> The average of the ratio between query rating and its position.


We also define `poor query percentage` as:

> The percentage of all queries with rating less than 3.


Write a solution to find each `query_name`, the `quality` and `poor_query_percentage`.

Both `quality` and `poor_query_percentage` should be __rounded to 2 decimal places__.

Return the result table in __any order__.

The result format is in the following example.

 

## Example

#### Input: 

`Queries` table:

| query_name | result           | position | rating |
| ---------- | ---------------- | -------- | ------ |
| Dog        | Golden Retriever | 1        | 5      |
| Dog        | German Shepherd  | 2        | 5      |
| Dog        | Mule             | 200      | 1      |
| Cat        | Shirazi          | 5        | 2      |
| Cat        | Siamese          | 3        | 3      |
| Cat        | Sphynx           | 7        | 4      |

#### Output: 

| query_name | quality | poor_query_percentage |
| ---------- | ------- | --------------------- |
| Dog        | 2.5     | 33.33                 |
| Cat        | 0.66    | 33.33                 |

###### Explanation: 
Dog queries quality is ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50

Dog queries poor_ query_percentage is (1 / 3) * 100 = 33.33


Cat queries quality equals ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66

Cat queries poor_ query_percentage is (1 / 3) * 100 = 33.33


## Solution
```ruby
SELECT
    query_name,
    ROUND(AVG(rating/position), 2) AS quality,
    ROUND(AVG(rating < 3) * 100, 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;
```

In many SQL dialects (like MySQL, PostgreSQL, and some others), the expression:
```
AVG(rating < 3)
```
is valid and works as expected because:
* The expression `rating < 3` evaluates to a boolean.
* Booleans are treated as integers: `TRUE` = 1, `FALSE` = 0.
* So `AVG(rating < 3)` calculates the __proportion (average) of rows where `rating` is less than 3__.

> For each row, `rating < 3` is 1 if true, 0 otherwise.

> Taking the `AVG()` over these values gives the fraction of rows with rating less than 3.

> Multiplying by 100 converts it to a percentage.
