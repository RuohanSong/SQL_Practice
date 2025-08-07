# 1633. Percentage of Users Attended a Contest
`easy`

Table: `Users`
```ruby
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
```
`user_id` is the primary key (column with unique values) for this table.

Each row of this table contains the name and the id of a user.
 

Table: `Register`
```ruby
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
```

(`contest_id`, `user_id`) is the primary key (combination of columns with unique values) for this table.

Each row of this table contains the id of a user and the contest they registered into.
 

* Write a solution to find the percentage of the users registered in each contest rounded to __two decimals__.

* Return the result table ordered by `percentage` in __descending order__. In case of a tie, order it by `contest_id` in __ascending order__.

* The result format is in the following example.

 

## Example

#### Input: 

`Users` table:

| user_id | user_name |
| ------- | --------- |
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |

`Register` table:

| contest_id | user_id |
| ---------- | ------- |
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |

#### Output: 

| contest_id | percentage |
| ---------- | ---------- |
| 208        | 100        |
| 209        | 100        |
| 210        | 100        |
| 215        | 66.67      |
| 207        | 33.33      |

##### Explanation: 
> All the users registered in contests 208, 209, and 210.
> The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
> Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
> Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%


# Soultion
```ruby
SELECT
    contest_id,
    ROUND(
        (COUNT(DISTINCT user_id) * 100 / 
        (SELECT COUNT(user_id) FROM Users)
    ), 2) AS percentage
FROM
    Register
GROUP BY
    contest_id
ORDER BY
    percentage DESC,
    contest_id ASC;
```

* A subquery within the `SELECT` statement calculates the total number of users by counting entries in the `Users` table.
* Use the `GROUP BY` clause on `contest_id` to aggregate registrations and count distinct `user_id` for each contest.
* The count of distinct users per contest is then divided by the total user count, multiplied by 100, and rounded to two decimal places to derive the percentage.
* The final step involves ordering the results by `percentage` in a descending manner and by `contest_id` in ascending order for equal percentages.


> [!NOTE]
> In this question, the word `tie` refers to __two or more rows having the same value in the column(s) you're sorting by__.


> If two or more contests have the __same percentage__ of registered users, then break the tie by ordering them using contest_id (smallest first).
