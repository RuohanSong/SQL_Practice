# 1251. Average Selling Price
`easy`

##### Table: `Prices`
```ruby
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
```
(`product_id`, `start_date`, `end_date`) is the primary key (combination of columns with unique values) for this table.

Each row of this table indicates the price of the `product_id` in the period from `start_date` to `end_date`.

For each `product_id` there will be no two overlapping periods. That means there will be no two intersecting periods for the same `product_id`.
 

##### Table: `UnitsSold`
```ruby
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
```

This table may contain duplicate rows.

Each row of this table indicates the date, units, and product_id of each product sold. 
 


* Write a solution to find the average selling price for each product.
* `average_price` should be __rounded to 2 decimal places__.
* If a product does not have any sold units, its average selling price is assumed to be __0__.
* Return the result table in __any order__.
* The result format is in the following example.

 

## Example:

##### Input: 
`Prices` table:
| product_id | start_date | end_date   | price |
| ---------- | ---------- | ---------- | ----- |
| 1          | 2019-02-17 | 2019-02-28 | 5     |
| 1          | 2019-03-01 | 2019-03-22 | 20    |
| 2          | 2019-02-01 | 2019-02-20 | 15    |
| 2          | 2019-02-21 | 2019-03-31 | 30    |
`UnitsSold` table:
| product_id | purchase_date | units |
| ---------- | ------------- | ----- |
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
##### Output: 
| product_id | average_price |
| ---------- | ------------- |
| 1          | 6.96          |
| 2          | 16.96         |
##### Explanation: 
* Average selling price = Total Price of Product / Number of products sold.
* Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
* Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96

# Solution
```ruby
SELECT
    p.product_id,
    IFNULL(ROUND((SUM(price * units) / SUM(units)), 2), 0) AS average_price
FROM
    Prices p
LEFT JOIN
    UnitsSold u
ON 
    p.product_id = u.product_id
    AND purchase_date BETWEEN start_date AND end_date
GROUP BY
    p.product_id;
```
1. Select the `product_id` and calculate the average selling price by dividing the __total revenue__ by the __total units__ sold for each product.

2. `Left join` table `UnitsSold` on the table `Prices` based on the `product_id`.

3. Filter Data: Select rows where the `purchase_date` falls within the inclusive range of `start_date` and `end_date`.

4. Group the results by `product_id`.

>[!NOTE]
> Notice how to calculate the average price in the example and the `IFNULL` clause to put a default value `0` if there is no unit sold for a product.
