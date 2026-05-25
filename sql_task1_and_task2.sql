------------------------------------------
--task 1
------------------------------------------

USE Grocery_shop;

CREATE TABLE mst_category (
    category_id INT IDENTITY(1,1) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),

    created_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) DEFAULT 'system',
    updated_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(100) DEFAULT 'system',
    is_active INT DEFAULT 1,

    PRIMARY KEY (category_id)
);

CREATE TABLE tbl_product (
    product_id INT IDENTITY(1,1) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    category_id INT,

    created_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) DEFAULT 'system',
    updated_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(100) DEFAULT 'system',
    is_active INT DEFAULT 1,

    PRIMARY KEY (product_id),

    FOREIGN KEY (category_id)
    REFERENCES mst_category(category_id)
);

INSERT INTO mst_category (category_name, description)
VALUES
    ('Beverages', 'Soft drinks and juices'),
    ('Dairy', 'Milk and dairy products'),
    ('Snacks', 'Chips and biscuits'),
    ('Bakery', 'Bread and cakes'),
    ('Vegetables', 'Fresh vegetables');

INSERT INTO tbl_product
(product_name, brand, price, stock_quantity, category_id)
VALUES
    ('Coca Cola', 'Coca Cola', 40.00, 100, 1),
    ('Milk', 'Amul', 30.00, 50, 2),
    ('Potato Chips', 'Lays', 20.00, 80, 3),
    ('Bread', 'Britannia', 35.00, 40, 4),
    ('Tomato', 'Fresh Farm', 25.00, 60, 5),
    ('Orange Juice', 'Tropicana', 90.00, 30, 1);

--view tables
SELECT * FROM mst_category;

SELECT * FROM tbl_product;

-- update tables
UPDATE tbl_product
SET
    price = 45.00,
    updated_on = CURRENT_TIMESTAMP,
    updated_by = 'admin_user'
WHERE product_name = 'Coca Cola'
AND is_active = 1;

-- delete product
UPDATE tbl_product
SET
    is_active = 0,
    updated_on = CURRENT_TIMESTAMP,
    updated_by = 'admin_user'
WHERE product_name = 'Potato Chips';

-- delete category
UPDATE mst_category
SET is_active = 0, updated_on = CURRENT_TIMESTAMP, updated_by = 'admin_user'
WHERE category_name = 'Bakery';

-- set active products
SELECT *
FROM tbl_product
WHERE is_active = 1;

-- count active products
SELECT COUNT(*) AS ActiveProducts
FROM tbl_product
WHERE is_active = 1;

-- search products
SELECT *
FROM tbl_product
WHERE product_name LIKE 'M%';

-- insert new product
INSERT INTO tbl_product
(product_name, brand, price, stock_quantity, category_id)
VALUES
('Butter', 'Amul', 55.00, 25, 2);

-- join query
SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.price,
    p.stock_quantity,
    c.category_name
FROM tbl_product p
INNER JOIN mst_category c
ON p.category_id = c.category_id;

-- order by query
SELECT *
FROM tbl_product
ORDER BY price DESC;

-- group by
SELECT c.category_name, COUNT(p.product_id) AS TotalProducts
FROM mst_category c
INNER JOIN tbl_product p
ON c.category_id = p.category_id
GROUP BY c.category_name;


------------------------------------------------------
-- TASK 2
------------------------------------------------------

CREATE TABLE mst_supplier(
    supplier_id INT IDENTITY(1,1) NOT NULL,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone_number VARCHAR(15) UNIQUE,
    city VARCHAR(100),

    created_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active INT DEFAULT 1,

    PRIMARY KEY (supplier_id)
);

CREATE TABLE mst_customer (
    customer_id INT IDENTITY(1,1) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    city VARCHAR(100),

    created_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active INT DEFAULT 1,

    PRIMARY KEY (customer_id)
);

CREATE TABLE tbl_orders (
    order_id INT IDENTITY(1,1) NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,

    quantity INT NOT NULL,
    total_amount DECIMAL(10,2),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (order_id),

    FOREIGN KEY (customer_id)
    REFERENCES mst_customer(customer_id),

    FOREIGN KEY (product_id)
    REFERENCES tbl_product(product_id),

    FOREIGN KEY (supplier_id)
    REFERENCES mst_supplier(supplier_id)
);

INSERT INTO mst_supplier
(supplier_name, contact_person, phone_number, city)
VALUES
('Fresh Farm Suppliers', 'Ramesh', '9876543210', 'Bangalore'),
('Daily Needs Pvt Ltd', 'Suresh', '9876543211', 'Mysore'),
('Food Hub Distributors', 'Mahesh', '9876543212', 'Hubli');

INSERT INTO mst_customer
(customer_name, email, phone_number, city)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9000000001', 'Bangalore'),
('Sneha Patil', 'sneha@gmail.com', '9000000002', 'Belgaum'),
('Amit Verma', 'amit@gmail.com', '9000000003', 'Mysore');

INSERT INTO tbl_orders
(customer_id, product_id, supplier_id, quantity, total_amount)
VALUES
(1, 1, 1, 2, 80.00),
(2, 2, 2, 3, 90.00),
(3, 4, 3, 1, 35.00),
(1, 6, 1, 2, 180.00);

-- display tables
SELECT * FROM mst_supplier;

SELECT * FROM mst_customer;

SELECT * FROM tbl_orders;

-- join qery all tables
select o.order_id, c.customer_name, p.product_name, s.supplier_name, o.quantity, o.total_amount, o.order_date
from tbl_orders o
inner join mst_customer c
on o.order_id = c.customer_id
inner join tbl_product p
on o.product_id = p.product_id
inner join mst_supplier s
on o.supplier_id = s.supplier_id;

-- customer purchase details
select c.customer_name, p.product_name, o.quantity, o.total_amount
from mst_customer c
Inner join tbl_orders o
on c.customer_id = o.customer_id
inner join tbl_product p
on o.product_id = p.product_id

-- supplier product details
select s.supplier_name, p.product_name, p.price, p.stock_quantity
from mst_supplier s
inner join tbl_orders o
on s.supplier_id = o.supplier_id
inner join tbl_product p 
on o.product_id = p.product_id

-- total sales by customer
select c.customer_name, Sum(o.total_amount) as TotalSpent
from mst_customer c
inner join tbl_orders o
on c.customer_id = o.customer_id
group by c.customer_name;

--total orders by supplier
select s.supplier_name, count(o.order_id) as total_orders
from mst_supplier AS s
inner join tbl_orders AS o
on o.supplier_id = s.supplier_id
group by s.supplier_name

