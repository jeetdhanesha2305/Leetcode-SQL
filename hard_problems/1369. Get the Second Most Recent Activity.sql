WITH user_activity_stats AS (
    SELECT 
        Ua.username, 
        Ua.activity, 
        Ua.startDate, 
        Ua.endDate, 
        Ac.activity_count, 
        ROW_NUMBER() OVER(
            PARTITION BY username 
            ORDER BY endDate DESC
        ) AS rnk
    FROM UserActivity Ua
    INNER JOIN (
        SELECT 
            username, 
            COUNT(*) AS activity_count
        FROM UserActivity
        GROUP BY username 
    ) Ac 
    ON Ua.username = Ac.username 
)

SELECT 
    username, 
    activity, 
    startDate, 
    endDate 
FROM user_activity_stats 
WHERE 
    activity_count = 1 OR 
    ( activity_count > 1 AND rnk = 2 )




