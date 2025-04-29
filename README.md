# 📘 SQL Practical — PostgreSQL Version

This repository contains a PostgreSQL-based solution for a SQL practical problem involving user orders, products, and order tracking. It includes table creation with proper constraints, data insertion, and complex queries for fetching and summarizing order data.

---

## 🗂️ Table Structure

### 1. `users`

- `user_id` (Primary Key)
- `name`
- `email` (Unique)

### 2. `products`

- `product_id` (Primary Key)
- `name`
- `price`

### 3. `orders`

- `order_id` (Primary Key)
- `user_id` (Foreign Key to `users`)
- `order_date`
- `expected_delivery_date`
- `status`

### 4. `order_details`

- `order_detail_id` (Primary Key)
- `order_id` (Foreign Key to `orders`)
- `product_id` (Foreign Key to `products`)

---

## 📦 Sample Data

Sample data is inserted into each table for demonstrating the queries.

```sql
-- USERS
INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eva'),
('Frank');

-- PRODUCTS
INSERT INTO products (name, price) VALUES
('Laptop', 75000.00),
('Smartphone', 30000.00),
('Headphones', 2000.00),
('Keyboard', 1500.00),
('Monitor', 12000.00),
('Tablet', 18000.00);

-- ORDERS
INSERT INTO orders (user_id, order_date, order_status, expected_delivery_date) VALUES
(1, '2025-04-20', 'Delivered', '2025-04-25'),
(2, '2025-04-22', 'Pending', '2025-04-29'),
(1, '2025-04-25', 'Cancelled', '2025-05-01'),
(3, '2025-04-26', 'Delivered', '2025-04-30'),
(4, '2025-04-27', 'Pending', '2025-05-03'),
(5, '2025-04-28', 'Delivered', '2025-05-02');

-- ORDER_DETAILS
INSERT INTO order_details (order_id, product_id) VALUES
(1, 1), -- Alice - Laptop
(1, 3), -- Alice - Headphones
(2, 2), -- Bob - Smartphone
(3, 4), -- Alice - Keyboard
(4, 5), -- Charlie - Monitor
(4, 6), -- Charlie - Tablet
(5, 3), -- David - Headphones
(5, 4), -- David - Keyboard
(6, 1), -- Eva - Laptop
(6, 2); -- Eva - Smartphone

```

---

## 📄 Required Queries

### 1. 📋 Fetch All User Orders

Displays:

- Customer name
- Product names in the order
- Order date
- Expected delivery duration (in X days)

```sql
SELECT
    u.name AS customer_name,
    o.order_date,
    CONCAT(EXTRACT(DAY FROM o.expected_delivery_date - o.order_date), ' days') AS expected_delivery_in,
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
    u.name, o.order_date, o.expected_delivery_date
ORDER BY
    o.order_date;
```

### 2. Create summary report which provide information about

- All undelivered Orders
  ```sql
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
  ```
- 5 Most recent orders
  ```sql
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
  ```
- Top 5 active users (Users having most number of orders)
  ```sql
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
  ```
- Inactive users (Users who hasn’t done any order)
  ```sql
  SELECT
    u.name AS inactive_user
  FROM
      users u
  LEFT JOIN
      orders o ON u.user_id = o.user_id
  WHERE
      o.order_id IS NULL;
  ```
- Top 5 Most purchased products
  ```sql
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
  ```
- Most expensive and most cheapest orders.

  ```sql
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

  ```
