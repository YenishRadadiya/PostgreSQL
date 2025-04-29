-- USERS table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- PRODUCTS table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

-- ENUM type for order_status
CREATE TYPE order_status_enum AS ENUM ('Pending', 'Delivered', 'Cancelled');

-- ORDERS table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_status order_status_enum NOT NULL,
    expected_delivery_date DATE NOT NULL
);

-- ORDER_DETAILS table
CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id)
);


-- data insertion
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
