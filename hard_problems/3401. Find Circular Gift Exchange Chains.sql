WITH RECURSIVE valid_emp AS (  
    SELECT 
        * 
    FROM SecretSanta 
    WHERE 
        giver_id IN (
            SELECT 
                giver_id 
            FROM SecretSanta 
            GROUP BY giver_id 
            HAVING COUNT(receiver_id) = 1 
        ) AND 
        receiver_id IN (
            SELECT 
                receiver_id  
            FROM SecretSanta 
            GROUP BY receiver_id  
            HAVING COUNT(giver_id) = 1     
        )
), chain_length_calc AS (

    SELECT 
        giver_id, 
        receiver_id, 
        gift_value, 
        1 AS chain_length, 
        gift_value AS total_gift_value
    FROM SecretSanta  
    UNION ALL 
    SELECT 
        L.giver_id, 
        R.receiver_id, 
        R.gift_value,  
        L.chain_length + 1 AS chain_length, 
        L.total_gift_value + R.gift_value AS total_gift_value
    FROM chain_length_calc L 
    INNER JOIN SecretSanta R
    ON L.receiver_id = R.giver_id AND L.giver_id <> R.giver_id 
), chain_length_and_gift_val AS (
    SELECT 
        DISTINCT chain_length, 
        total_gift_value,  
        DENSE_RANK() OVER(
            ORDER BY chain_length DESC, total_gift_value DESC
        ) AS rnk
    FROM chain_length_calc
    WHERE giver_id = receiver_id
) 

SELECT 
    rnk AS chain_id, 
    chain_length, 
    total_gift_value 
FROM chain_length_and_gift_val




