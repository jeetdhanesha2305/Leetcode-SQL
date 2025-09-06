WITH all_ips AS (
    SELECT
        *, 
        REGEXP_REPLACE(ip, '[0-9]', '') AS dot_count, 
        SUBSTRING_INDEX(ip, '.', 1) AS octet_1, 
        SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) AS octet_2, 
        SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) AS octet_3,
        SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 4), '.', -1) AS octet_4 
         
    FROM logs 
)

SELECT 
    ip, 
    COUNT(*) AS invalid_count
FROM all_ips 
WHERE 
    CHAR_LENGTH(dot_count) <> 3 OR 
    CAST(octet_1 AS UNSIGNED) > 255 OR 
    CAST(octet_2 AS UNSIGNED) > 255 OR 
    CAST(octet_3 AS UNSIGNED) > 255 OR 
    CAST(octet_4 AS UNSIGNED) > 255 OR 
    octet_1 LIKE '0%' AND CHAR_LENGTH(octet_1) > 1 OR
    octet_2 LIKE '0%' AND CHAR_LENGTH(octet_1) > 1 OR
    octet_3 LIKE '0%' AND CHAR_LENGTH(octet_1) > 1 OR
    octet_4 LIKE '0%' AND CHAR_LENGTH(octet_1) > 1
GROUP BY ip 
ORDER BY invalid_count DESC, ip DESC

    