# 1174. Immediate Food Delivery II
`medium`

Table: `Delivery`
```ruby
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
```

> `delivery_id` is the column of unique values of this table.
> The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the customer's preferred delivery date is the same as the order date, then the order is called __immediate__; otherwise, it is called __scheduled__.

The __first order__ of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, __rounded to 2 decimal places__.

The result format is in the following example.

 

## Example

#### Input: 
`Delivery` table:

| delivery_id | customer_id | order_date | customer_pref_delivery_date |
| ----------- | ----------- | ---------- | --------------------------- |
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |

#### Output: 

| immediate_percentage |
| -------------------- |
| 50                   |

##### Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.

The customer id 2 has a first order with delivery id 2 and it is immediate.

The customer id 3 has a first order with delivery id 5 and it is scheduled.

The customer id 4 has a first order with delivery id 7 and it is immediate.

Hence, half the customers have immediate first orders.


## Solution 1:

* The subquery in `WHERE` clause finds each customer's earliest `order_date` and this guarantees that we only evaluate __the first order__ per customer.
* `order_date = customer_pref_delivery_date` counts 1 if it's immediate, 0 otherwise.
> [!TIP]
> We do not need `CASE WHEN` here.
* `COUNT(DISTINCT customer_id)` ensures the percentage is based on the __number of customers__.
* `ROUND(..., 2)` rounds the result to 2 decimal places.

```ruby
SELECT
    ROUND(
        SUM(order_date = customer_pref_delivery_date) * 100 
        / COUNT(DISTINCT customer_id), 
        2
    ) AS immediate_percentage
FROM
    Delivery
WHERE
    (customer_id, order_date) IN (SELECT customer_id, MIN(order_date) 
                                  FROM Delivery
                                  GROUP BY customer_id);
```

> [!CAUTION]
> `(customer_id, order_date) IN (...)` is a tuple comparison that can be slow on large tables.
> We would like to make it optimal for big datasets.


## Solution 2:
Create `first_orders` table with all the customers and their first order and then `JOIN` it with the original table to get other information.

```ruby
SELECT 
    ROUND(
        SUM(d.order_date = d.customer_pref_delivery_date) * 100.0
        / COUNT(DISTINCT d.customer_id),
        2
    ) AS immediate_percentage
FROM (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
) first_orders
JOIN Delivery d
    ON d.customer_id = first_orders.customer_id
   AND d.order_date = first_orders.first_order_date;
```
##### Why this is better:
* __Avoids tuple comparisons: MYSQL can optimize `JOIN` conditions much better than `(col1, col2) IN (...)`.
* __No subquery per row__: `MIN(order_date) is computed once per customer, then joined.
* If the `Delivery` table is large, this can __run significantly faster__.


## Solution 3:

Create a CTE where uses `PARTITION` to group the original table by `customer_id` into independent windows 

Each customer's orders are processed seperately by the window function.

Inside each partition, the rows are sorted by `order_date`.
> This is important because `FIRST_VALUE` needs to know which row is the first.  

`order_date = customer_pref_delivery_date` is a boolean expression that returns:
* 1 if they’re the same
* 0 if they’re different

`FIRST_VALUE(...)` finds the value from the very first row (after sorting) in that partition.
> This determines whether the first order of a customer is an immediate order or not.

###### The `CustomerToIsImmediate` table will look like below:

| customer_id | is_immediate |
| ----------- | ------------ |
| 1           | 0            |
| 2           | 1            |
| 3           | 0            |
| 4           | 1            |

Then we can directly calculate the average of `is_immediate`

```ruby
WITH
  CustomerToIsImmediate AS(
    SELECT
      DISTINCT customer_id,
      FIRST_VALUE(order_date = customer_pref_delivery_date) 
        OVER(PARTITION BY customer_id ORDER BY order_date) AS is_immediate
    FROM Delivery
  )

SELECT ROUND(AVG(is_immediate) * 100, 2) immediate_percentage
FROM CustomerToIsImmediate;
```
