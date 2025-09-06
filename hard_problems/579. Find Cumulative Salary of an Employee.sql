-- DON'T CONSIDER MOST RECENT MONTH 
-- CUM SUM OF LAST 3 MONTHS MTH=7 SALARY -> MTH=7 + MTH=6 + MTH=5

-- STEP:1 JOIN WITH PAST THREE MONTHS 
-- STEP:2 CALC THE CUM SUM 
-- STEP:3 EXCLUDE LATEST MONTH 

WITH emp_last_3_months AS (
    SELECT 
        E1.id, 
        E1.month AS curr_month, 
        E1.salary AS curr_month_salary, 
        E2.month AS prev_month, 
        E2.salary AS prev_month_salary, 
        E3.month AS prev_prev_month, 
        E3.salary AS prev_prev_month_salary
    FROM Employee E1 
    LEFT JOIN Employee E2 
    ON E1.id = E2.id AND E1.month-1 = E2.month 
    LEFT JOIN Employee E3 
    ON E1.id = E3.id AND E1.month-2 = E3.month  
), emp_cumulative_salary AS (
    SELECT 
        *, 
        curr_month_salary + 
        IFNULL(prev_month_salary, 0) + 
        IFNULL(prev_prev_month_salary, 0) AS salary, 
        ROW_NUMBER() OVER(
            PARTITION BY id 
            ORDER BY curr_month DESC
        ) AS rnk
    FROM emp_last_3_months
)

SELECT 
    id, 
    curr_month AS month, 
    salary
FROM emp_cumulative_salary 
WHERE rnk <> 1 
ORDER BY id ASC, month DESC