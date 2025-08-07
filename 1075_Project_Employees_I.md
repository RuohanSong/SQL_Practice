# 1075. Project Employees I
`easy`

Table: `Project`
```ruby
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
```
(`project_id`, `employee_id`) is the primary key of this table.

`employee_id` is a foreign key to `Employee` table.

Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

Table: `Employee`
```ruby
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
```

`employee_id` is the primary key of this table. 

It's guaranteed that experience_years is not NULL.

Each row of this table contains information about one employee.
 



* Write an SQL query that reports the __average__ experience years of all the employees for each project, __rounded to 2 digits__.

* Return the result table in any order.

* The query result format is in the following example.

 

## Example

#### Input: 

`Project` table:

| project_id | employee_id |
| ---------- | ----------- |
| 1          | 1           |
| 1          | 2           |
| 1          | 3           |
| 2          | 1           |
| 2          | 4           |

`Employee` table:

| employee_id | name   | experience_years |
| ----------- | ------ | ---------------- |
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |

#### Output: 
| project_id | average_years |
| ---------- | ------------- |
| 1          | 2             |
| 2          | 2.5           |

##### Explanation: 
The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50

## Solution
```ruby
SELECT
    project_id,
    ROUND(AVG(E.experience_years), 2) AS average_years
FROM
    Project AS P
LEFT JOIN
    Employee AS E
ON 
    P.employee_id = E.employee_id
GROUP BY
    P.project_id;
```

> Since the project assignment and employee information are stored in two separate tables, we need to join the table `Project` to `Employee` to calculate the average `experience_years` of all the employees associated with each project. Since multiple employees are working on the same project, the aggregate average `experience_years` is grouped at the `project_id` level. The result is rounded to 2 digits using the function `ROUND()` and renamed as `average_years` for the final output.
