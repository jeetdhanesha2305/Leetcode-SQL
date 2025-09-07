

WITH dept_salary_monthwise AS (
    SELECT 
        DATE_FORMAT(S.pay_date, '%Y-%m') AS  pay_month, 
        E.department_id, 
        S.amount
    FROM Salary S 
    INNER JOIN Employee E 
    ON S.employee_id  = E.employee_id 
), dept_avg_salary AS (
    SELECT 
        pay_month, 
        department_id, 
        AVG(amount) AS dept_avg
    FROM dept_salary_monthwise
    GROUP BY pay_month, department_id 
), company_avg_salary AS (
    SELECT 
        pay_month, 
        AVG(amount) AS cmpy_avg
    FROM dept_salary_monthwise
    GROUP BY pay_month 
)

SELECT 
    C.pay_month, 
    D.department_id, 
    CASE 
        WHEN D.dept_avg < C.cmpy_avg THEN 'lower'
        WHEN D.dept_avg = C.cmpy_avg THEN 'same'
        ELSE 'higher'
    END AS comparison 
FROM dept_avg_salary D 
INNER JOIN company_avg_salary C 
ON D.pay_month = C.pay_month


