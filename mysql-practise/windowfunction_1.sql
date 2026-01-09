USE campusx;

SELECT *,AVG(marks) OVER (PARTITION BY branch) FROM campusx.marks;


SELECT *,
       AVG(marks) OVER() AS avg_marks,
       MIN(marks) OVER() AS min_marks,
       MAX(marks) OVER() AS max_marks
FROM marks
ORDER BY students_id;

-- find all the students who have higher marks than avg marks of their respective branch
SELECT * FROM (SELECT *, 
AVG(marks) OVER(PARTITION BY branch) AS 'branch_avg'
FROM marks) t
WHERE t.marks > t.branch_avg;

-- RANK/DENSE_RANK/ROW_NUMBER

SELECT * ,
RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;

-- DENSE_RANK()
SELECT * ,
DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;


-- ROW_NUMBER

SELECT *,
CONCAT(branch,'-',ROW_NUMBER() OVER(PARTITION BY branch))
FROM marks;

-- find the top 2 customer
USE zomato;

SELECT *
FROM (
    SELECT 
        MONTH(date) AS month_no,
        MONTHNAME(date) AS month,
        user_id,
        SUM(amount) AS total_amount,
        RANK() OVER (
            PARTITION BY MONTH(date)
            ORDER BY SUM(amount) DESC
        ) AS month_rank
    FROM orders
    GROUP BY MONTH(date), MONTHNAME(date), user_id
) t
WHERE t.month_rank <= 2
ORDER BY month_no, month_rank;

-- FIRST_VALUE/LAST_VALUE/NTH_VALUE


SELECT * FROM marks;

SELECT *,
FIRST_VALUE(marks) OVER(ORDER BY marks DESC)
FROM marks;

SELECT *,
LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
FROM marks;


SELECT *,
NTH_VALUE(name,3) OVER(PARTITION BY branch 
                       ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
FROM marks;


-- Find the branch toppers

SELECT name,branch,marks FROM (SELECT *,
FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) AS 'topper_name',
FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC) AS 'topper_marks'
FROM marks) t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks;



-- Modified version
SELECT name,branch,marks FROM (SELECT *,
FIRST_VALUE(name) OVER W AS 'topper_name',
FIRST_VALUE(marks) OVER W AS 'topper_marks'
FROM marks) t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks
WINDOW W AS (PARTITION BY branch ORDER BY marks DESC);


-- LEAD AND LAG

SELECT *,
LAG(marks) OVER(ORDER BY student_id)
FROM marks;


SELECT *,
LEAD(marks) OVER(PARTITION BY branch ORDER BY student_id)
FROM marks;

-- find MoM revenue growth of zomato
USE zomato;

SELECT 
    month,
    total_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month_no))
        / LAG(total_revenue) OVER (ORDER BY month_no) * 100,
        2
    ) AS mom_growth_percentage
FROM (
    SELECT 
        MONTH(date) AS month_no,
        MONTHNAME(date) AS month,
        SUM(amount) AS total_revenue
    FROM orders
    GROUP BY MONTH(date), MONTHNAME(date)
) t
ORDER BY month_no;

