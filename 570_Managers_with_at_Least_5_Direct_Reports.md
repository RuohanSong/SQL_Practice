# 570. Managers with at Least 5 Direct Reports

### Table: `Employee`
```ruby
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
```
`id` is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If `managerId` is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

> Write a solution to find managers with at least five direct reports.
> Return the result table in any order.
> The result format is in the following example.

 

# Example

#### Input: 
`Employee` table:
```ruby
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
```
#### Output: 
```
+------+
| name |
+------+
| John |
+------+
```

# Solution
```ruby
SELECT
    name
FROM 
    (SELECT managerID, COUNT(managerID) AS num_reports
     FROM Employee
     GROUP BY managerID
     HAVING managerID IS NOT NULL AND num_reports >= 5
    ) AS manager
JOIN 
    Employee ON manager.managerID = Employee.id
```

The inner query identifies all managers who have five or more direct reports.
The outer query retrieves the names of employees who match the managers found in the inner query.

> [!NOTE]
> `IS NOT NULL` is not always necessary, but it's better to keep it to avoid unwanted `NULL` group in the subquery and ensure clean joins.
