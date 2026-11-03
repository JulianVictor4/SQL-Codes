					--SQL Joins (Basics)

--No Join
/* Retrieve all data from customers and orders in two different results */

SELECT *
FROM customers;

SELECT *
FROM orders;

--Inner Join

/* Get all customers along with their orders,but only for 
customers who have placed an order */

SELECT *
FROM customers
INNER JOIN orders
ON id = customer_id;

--To show clear results (best practice)

SELECT 
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
FROM customers 
INNER JOIN orders
ON customers.id = orders.customer_id;

--Simplified Version
 
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;


--Left Join

/* Get all customers along with their orders, including those 
without orders */

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id;


--Right Join

/* Get all customers along with their orders, including
orders without matching customers */

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id;

--Same using left join

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id;


--Full Join

/* Get all customers and all orders, even if there is no match */

SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id