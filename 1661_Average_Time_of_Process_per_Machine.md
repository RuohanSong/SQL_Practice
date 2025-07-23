# 1661. Average Time of Process per Machine

#### Table: Activity

```
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
```
The table shows the user activities for a factory website.
(`machine_id`, `process_id`, `activity_type`) is the primary key (combination of columns with unique values) of this table.
`machine_id` is the ID of a machine.
`process_id` is the ID of a process running on the machine with ID machine_id.
`activity_type` is an ENUM (category) of type ('start', 'end').
`timestamp` is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
It is guaranteed that each (machine_id, process_id) pair has a 'start' and 'end' timestamp.
 

There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.

The result format is in the following example.

 

## Example:

#### Input: 
Activity table:
```ruby
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
```
#### Output: 
```ruby
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
```

#### Explanation: 
There are 3 machines running 2 processes each.
Machine 0's average time is ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
Machine 1's average time is ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
Machine 2's average time is ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456


##  Solution 1
##### Transform Values with CASE WHEN to negative values and then Calculate

1. Set the `timestamp` values to negative by multiplying them by -1 when its `activity_type` is 'start'
2. SUM them together to return the result of the total processing time of a machine
3. Calculate the average processing time by dividing the total time by the number of processes
4. ROUND the average processing time to 3 decimal places

```ruby
SELECT
    machine_id,
    ROUND (SUM(CASE
                WHEN activity_type = 'start' THEN timestamp * -1
                ELSE timestamp
                END
            ) * 1.0 / (
                SELECT
                COUNT(DISTINCT process_id)
            ), 3) AS processing_time
FROM 
    Activity
GROUP BY
    machine_id
```
> [!NOTE]
> It matters to multiply the SUM by 1.0 to force floating-point division
> to make sure the result is floating-point type
> in cases that the division might perform integer division in some SQL engines when the timestamp values are integers


## Solution 2
##### Calling the original Table twice and Calculate as two colums
To create the table alias, we give the original table `Activity` two different names, `a` and `b`
and filter each table by the activity_type. 
We also make sure the two tables are joined on the `machine_id` and `process_id`, 
so the output will have the `start timestamp` and `end timestamp` stored in two different columns for each machine and process.

```ruby
SELECT a.machine_id, 
       ROUND(AVG(b.timestamp - a.timestamp), 3) AS processing_time
FROM Activity a, 
     Activity b
WHERE 
    a.machine_id = b.machine_id
AND 
    a.process_id = b.process_id
AND 
    a.activity_type = 'start'
AND 
    b.activity_type = 'end'
GROUP BY machine_id
```
