/*
1. Fetch all the User order list and include atleast following details in that.
	- Customer name
	- Product names
	- Order Date
	- Expected delivery date (in days, i.e. within X days)
*/

SELECT 
    u.name AS customer_name,
    o.order_date,
    (o.expected_delivery_date - o.order_date) || ' days' AS expected_delivery_in,
    STRING_AGG(p.name, ', ') AS product_names
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    products p ON od.product_id = p.product_id
GROUP BY 
    u.name, o.order_id, o.order_date, o.expected_delivery_date
ORDER BY 
    o.order_date;


/*
2. Create summary report which provide information about
	- All undelivered Orders
	- 5 Most recent orders
	- Top 5 active users (Users having most number of orders)
	- Inactive users (Users who hasn’t done any order)
	- Top 5 Most purchased products
	- Most expensive and most cheapest orders.
*/

-- All undelivered Orders
SELECT 
    o.order_id,
    u.name AS customer_name,
    o.order_date,
    o.order_status,
    o.expected_delivery_date
FROM 
    orders o
JOIN 
    users u ON o.user_id = u.user_id
WHERE 
    o.order_status != 'Delivered'
ORDER BY 
    o.order_date DESC;


-- 5 Most recent orders
SELECT 
    o.order_id,
    u.name AS customer_name,
    o.order_date,
    o.order_status
FROM 
    orders o
JOIN 
    users u ON o.user_id = u.user_id
ORDER BY 
    o.order_date DESC
LIMIT 5;


--  Top 5 active users (Users having most number of orders)

SELECT 
    u.name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
GROUP BY 
    u.name
ORDER BY 
    total_orders DESC
LIMIT 5;


-- Inactive users (Users who hasn’t done any order)
SELECT 
    u.name AS inactive_user
FROM 
    users u
LEFT JOIN 
    orders o ON u.user_id = o.user_id
WHERE 
    o.order_id IS NULL;

-- Top 5 Most purchased products
SELECT 
    p.name AS product_name,
    COUNT(od.product_id) AS times_purchased
FROM 
    products p
JOIN 
    order_details od ON p.product_id = od.product_id
GROUP BY 
    p.name
ORDER BY 
    times_purchased DESC
LIMIT 5;


-- Most expensive and most cheapest orders.
-- Order cost summary (subquery)
WITH order_total AS (
    SELECT 
        o.order_id,
        SUM(p.price) AS total_price
    FROM 
        orders o
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        products p ON od.product_id = p.product_id
    GROUP BY 
        o.order_id
)
SELECT * FROM order_total 
WHERE total_price = (SELECT MAX(total_price) FROM order_total)
   OR total_price = (SELECT MIN(total_price) FROM order_total);
