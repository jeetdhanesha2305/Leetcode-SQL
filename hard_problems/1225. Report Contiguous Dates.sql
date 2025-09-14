
WITH RECURSIVE event_stats AS (
    SELECT 
        success_date AS run_date, 'S' AS run_status
    FROM Succeeded 
    WHERE YEAR(success_date) = 2019
    UNION ALL 
    SELECT 
        fail_date AS run_date, 'F' AS run_status
    FROM Failed 
    WHERE YEAR(fail_date) = 2019
    ORDER BY run_date ASC  
), prev_curr_run_stats AS (
    ( SELECT 
        run_date, 
        run_status, -- S
        1 AS curr_seq 
    FROM event_stats  
    LIMIT 1 )
    UNION ALL 
    SELECT 
        P.run_date, 
        P.run_status, 
        CASE 
            WHEN C.run_status = P.run_status
            THEN curr_seq 
            ELSE curr_seq+1
        END AS curr_seq
    FROM  prev_curr_run_stats  C 
    INNER JOIN event_stats P 
    ON 
        DATEDIFF(P.run_date, C.run_date) = 1  

)

SELECT 
    CASE 
        WHEN run_status = 'S' THEN 'succeeded'
        ELSE 'failed'
    END AS period_state, 
    MIN(run_date) AS start_date, 
    MAX(run_date) AS end_date
FROM prev_curr_run_stats 
GROUP BY curr_seq, run_status