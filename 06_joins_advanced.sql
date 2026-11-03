				-- SQL Joins (Advanced)

--Left Anti Join

/* Get all customers who haven't placed any order */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;


--Right Anti Join

/* Get all orders without matching customers */

SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL;


--Same using Left Join

SELECT *
FROM orders AS o 
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL;


--Full Anti Join

/* Find customers without orders and orders without customers */

SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL OR O.customer_id IS NULL;


/* Get all customers along with their orders, but only for customers
who have placed an order (without using Inner Join) */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o 
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;


--Cross Join

/* Generate all possible combinations of customers and orders */

SELECT *
FROM customers 
CROSS JOIN orders


--Multiple Tables

/* Using SalesDB, Retrieve a list of all orders, along with the related 
customer, product, and employee details. For each order, display
OrderID, Customer's name, Product name, Sales amount, Product price, 
Salesperson's name */

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName AS customerLastName,
	p.Product AS ProductName,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.customerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.productID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID
