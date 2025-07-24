# 1280. Students and Examinations

#### Table: `Students`
```ruby
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
```
`student_id` is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one student in the school.
 

#### Table: `Subjects`
```ruby
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
```
`subject_name` is the primary key (column with unique values) for this table.
Each row of this table contains the name of one subject in the school.
 

#### Table: `Examinations`
```ruby
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
```
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each student from the `Students` table takes every course from the `Subjects` table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 


> Write a solution to find the number of times each student attended each exam.

> Return the result table ordered by `student_id` and `subject_name`.

> The result format is in the following example.

 
## Example

#### Input: 

`Students` table:
```ruby
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
```

`Subjects` table:
```ruby
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
```

`Examinations` table:
```ruby
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
```

#### Output: 
```ruby
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
```

###### Explanation:
The result table should contain all students and all subjects.
Alice attended the Math exam 3 times, the Physics exam 2 times, and the Programming exam 1 time.
Bob attended the Math exam 1 time, the Programming exam 1 time, and did not attend the Physics exam.
Alex did not attend any exams.
John attended the Math exam 1 time, the Physics exam 1 time, and the Programming exam 1 time.


# Solution
```ruby
SELECT
    Students.student_id,
    Students.student_name,
    Subjects.subject_name,
    COUNT(Examinations.student_id) AS attended_exams
FROM 
    Students 
    CROSS JOIN Subjects
    LEFT JOIN Examinations ON Students.student_id = Examinations.student_id
                          AND Subjects.subject_name = Examinations.subject_name
GROUP BY Students.student_id, Students.student_name, Subjects.subject_name
ORDER BY Students.student_id, Subjects.subject_name;
```

### Step-by-step Process:

1. Join the `Students` table with `Subjects` table with `CROSS JOIN` to create a combined table with 12 rows including all the students and all the subjects.
```ruby
SELECT Students.student_id, Students.student_name, Subjects.subject_name
FROM Students  
CROSS JOIN Subjects;
```
> [!NOTE]
> `CROSS JOIN` performs a cartesian product between two tables, returning all possible combinations of all rows.
> It has no `ON` clause because we are just joining everything to everything.

2. `LEFT JOIN` the table from the first step with `Examinations` table to create a new table containing rows where the `student_id` and `subject_name` match.

```ruby
SELECT Students.student_id, Students.student_name, Subjects.subject_name
FROM Students  
CROSS JOIN Subjects 
LEFT JOIN Examinations ON Students.student_id = Examinations.student_id 
                      AND Subjects.subject_name = Examinations.subject_name;
```

> [!NOTE]
> Now the newly created table looks as below:

```ruby
| student_id | student_name | subject_name |
| ---------- | ------------ | ------------ |
| 1          | Alice        | Programming  |
| 1          | Alice        | Physics      |
| 1          | Alice        | Physics      |
| 1          | Alice        | Math         |
| 1          | Alice        | Math         |
| 1          | Alice        | Math         |
| 2          | Bob          | Programming  |
| 2          | Bob          | Physics      |
| 2          | Bob          | Math         |
| 13         | John         | Programming  |
| 13         | John         | Physics      |
| 13         | John         | Math         |
| 6          | Alex         | Programming  |
| 6          | Alex         | Physics      |
| 6          | Alex         | Math         |
```

> Three rows from the right table (Examinations) that get matched to the single row (1, Alice, Math) from the left table."

3. Count how many times each student took for one subject.
```ruby
SELECT Students.student_id, Students.student_name, Subjects.subject_name, COUNT(Examinations.student_id) as attended_exams
FROM Students  
CROSS JOIN Subjects 
LEFT JOIN Examinations ON Students.student_id = Examinations.student_id 
                      AND Subjects.subject_name = Examinations.subject_name
GROUP BY Students.student_id, Students.student_name, Subjects.subject_name;
```
> [!TIP]
> To count only matching exam records, count a column that is NULL when there's no match, i.e., a column from the right-side table of the LEFT JOIN.

4. Order the result with `ORDER BY` clause as requested.
```ruby
SELECT Students.student_id, Students.student_name, Subjects.subject_name, COUNT(Examinations.student_id) as attended_exams
FROM Students  
CROSS JOIN Subjects 
LEFT JOIN Examinations ON Students.student_id = Examinations.student_id 
                      AND Subjects.subject_name = Examinations.subject_name
GROUP BY Students.student_id, Students.student_name, Subjects.subject_name
ORDER BY Students.student_id, Subjects.subject_name;
```

### Final Output
```ruby
| student_id | student_name | subject_name | attended_exams |
| ---------- | ------------ | ------------ | -------------- |
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
```

