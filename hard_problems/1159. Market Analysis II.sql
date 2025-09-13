WITH seller_brand_stats AS (
    SELECT 
        O.seller_id, 
        I.item_brand AS sold_brand, 
        O.seller_order_num, 
        O.sellers_total_orders
    FROM (
        SELECT 
            *, 
            ROW_NUMBER() OVER(
                PARTITION BY seller_id 
                ORDER BY order_date ASC 
            ) AS seller_order_num, 
            COUNT(*) OVER(
                PARTITION BY seller_id 
            ) AS sellers_total_orders
        FROM Orders 
    ) O 
    INNER JOIN Items I 
    ON O.item_id = I.item_id
)



SELECT
    U.user_id AS seller_id,
    CASE 
        WHEN S.sellers_total_orders <= 1 OR S.sellers_total_orders IS NULL 
        THEN 'no'

        WHEN S.sellers_total_orders > 1 AND U.favorite_brand = S.sold_brand 
        THEN 'yes'

        ELSE 'no'
    END AS 2nd_item_fav_brand 
FROM users U 
LEFT JOIN seller_brand_stats S 
ON U.user_id = S.seller_id 
WHERE 
    (
        S.sellers_total_orders > 1 AND 
        S.seller_order_num = 2
    ) OR (
        S.sellers_total_orders <= 1 
    ) OR (
        S.sellers_total_orders IS NULL
    )









