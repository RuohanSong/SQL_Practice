# 577. Employee Bonus

#### Table: `Employee`
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
```
`empId` is the column with unique values for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 

#### Table: `Bonus`
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
```
`empId` is the column of unique values for this table.
`empId` is a foreign key (reference column) to `empId` from the `Employee` table.
Each row of this table contains the id of an employee and their respective bonus.
 


Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.

The result format is in the following example.

 

### Example:

#### Input: 
##### `Employee` table:
```
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
```
##### `Bonus` table:
```
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
```
#### Output: 
```
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+
```

# Solution
#### Using `OUTER JOIN` and `WHERE` clause
1. Since some employees do not have bonus records in `Bonus` table, use `LEFT OUTER JOIN` or `LEFT JOIN` to make sure that the joint table has all the employees' records.

The output of the joint table with the sample data is as below:
```ruby
| name   | bonus |
|--------|-------|
| Dan    | 500   |
| Thomas | 2000  |
| Brad   |       |
| John   |       |
```
> [!NOTE]
> The bonus values for `Brad` and `John` is empty, which is actually `NULL` in the database, so we use `IS NULL` or `IS NOT NULL` in the `WHERE` clause to handle the `NULL` values.

2. Add a `WHERE` clause to filter the records

```ruby
SELECT
    E.name, B.bonus
FROM 
    Employee AS E
        LEFT JOIN 
        Bonus AS B ON E.empId = B.empId
WHERE
    bonus < 1000 OR bonus IS NULL;
```
