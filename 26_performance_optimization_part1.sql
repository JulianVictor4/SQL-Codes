							--SQL PERFORMANCE OPTIMISATION 

--Fetching Data

--TIP 1: Select only what you need

--BAD PRACTICE 

SELECT *
FROM Sales.Customers;

--GOOD PRACTICE 

SELECT 
	CustomerID,
	FirstName, 
	LastName
FROM Sales.Customers;

--=======================================
--Tip 2: Avaoid unnecessary DISTINCT & ORDER BY

--BAD PRACTICE 
SELECT DISTINCT
	FirstName,
FROM Sales.Customers
ORDER BY FirstName;

--GOOD PRACTICE
SELECT
	FirstName,
FROM Sales.Customers;

--============================================
--Tip 3: For exploration purpose, Limit rows.

--BAD PRACTICE 
SELECT DISTINCT
	OrderID,
	Sales
FROM Sales.Orders;

--GOOD PRACTICE
SELECT TOP 10
	OrderID,
	Sales
FROM Sales.Orders;

--================================================

--Filtering Data

--Tip 4: Create nonclustered index on frequently used columns in WHERE clause

SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX Idx_OrderStatus ON Sales.Orders (OrderStatus)

--Tip 5: Avoid applying functions to columns in WHERE clauses

--BAD PRACTICE

SELECT * FROM Sales.Orders 
WHERE LOWER(OrderStatus) = 'delivered'

--GOOD PRACTICE

SELECT * FROM Sales.Orders 
WHERE OrderStatus = 'delivered'


--BAD PRACTICE

SELECT * FROM Sales.Customers 
WHERE SUBSTRING(FirstName,1,1) = 'A'

--GOOD PRACTICE

SELECT * FROM Sales.Customers 
WHERE FirstName LIKE 'A'

--BAD PRACTICE

SELECT * FROM Sales.Orders 
WHERE YEAR(OrderDate) = 2025

--GOOD PRACTICE

SELECT * FROM Sales.Orders 
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

--===========================================================
--Tip 6: Avoid leading wildcards as they prevent index usage 

--BAD PRACTICE

SELECT * FROM Sales.Customers 
WHERE LastName LIKE '%Gold%'


--GOOD PRACTICE

SELECT * FROM Sales.Customers 
WHERE LastName LIKE 'Gold%'

--===========================================================
--Tip 7: Use IN instead of multiple OR


--BAD PRACTICE

SELECT * FROM Sales.Orders 
WHERE CustomerID = 1 OR CustomerID = 2 OR  CustomerID = 3


--GOOD PRACTICE

SELECT * FROM Sales.Orders 
WHERE CustomerID IN (1,2,3)

--=================================================================
--JOINING data

--Tip 8: Understand the speed of Joins and Use INNER JOIN when possible.

--Best Performance
SELECT c.FirstName, o.OrderID FROM Sales.Customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

--SLIGHTLY SLOWER PERFORMANCE 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
SELECT c.FirstName, o.OrderID FROM Sales.Customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

--WORDT PERFORMANCE
SELECT c.FirstName, o.OrderID FROM Sales.Customers c OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

--======================================================================
--Tip 9: Use explicit join (ANSI Join) instead of Implict Join (non-ANSI Join)

--bad practice (non-ANSI Join)

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

--GOOD PRACTICE (ANSI JOIN)

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c, Sales.Orders o
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

--============================================================================

--Tip 10: Make sure to INDEX the columns used in the ON clause 

SELECT c.FirstName, o.OrderID
FROM Sales.Orders o
INNER JOIN Sales.Customers c 
ON c.CustomerID = o.CustomerID

--here o.CustomerID lacks index so creating the index 

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON Sales.Orders (CustomerID)

--=============================================================================

--Tip 11: Filter Before Joining (Big Tables)

--Filter After Join (WHERE)

SELECT c.FirstName< o.orderID 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID 
WHERE o.OrderStatus = 'Delivered'

--Filter During Join (ON)

SELECT c.FirstName< o.orderID 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered'

--Filter Before Join (SUBQUERY)

SELECT c.FirstName< o.orderID 
FROM Sales.Customers c
INNER JOIN (SELECT OrderID, CustomerID FROM Sales.Orders WHERE OrderStatus = 'Delivered') --sub query
ON c.CustomerID = o.CustomerID

--====================================================================================
--Tip 12: Aggregate before joining (Big Tables)

--Best practice for small-medium tables
--Grouping and Joining 

SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) AS OrderCount
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName

--Best practice for big tables
--Pre-aggregated subquery
SELECT c.CustomerID, c.FirstName, o.OrderCount
FROM Sales.Customers c
INNER JOIN(
	SELECT CustomerID, COUNT(OrderID) AS OrderCount
	FROM Sales.Orders
	GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID


--Bad practice
--Correlated subquery
SELECT 
c.CustomerID,
c.FirstName,
	(SELECT COUNT(o.OrderID)
	FROM Sales.Orders o
	WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c

--=================================================================

--Tip 13: Use Union instead of OR in joins

--Bad practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OR c.CustomerID = o.SalesPersonID

--Best practice

SELECT o.OrderID, c.FirstName 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.SalesPersonID

--=====================================================================

--Tip 14: Check for nested loops and use SQL hints 

SELECT o.OrderId, cFirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

--Good Practice for having big table and small table

SELECT o.OrderId, cFirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN)

--=============================================================

--Tip 15: Use UNION ALL instead of UNION if duplicates are available.

--Bad practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchieve

--Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchieve

--===============================================================

--Tip 16: Use UNION ALL + Distinct instead of using UNION if duplicates are not acceptable

--Bad practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchieve

--Good practice 
SELECT DISTINCT  CustomerID 
FROM (
	SELECT CustomerID FROM Sales.Orders
	UNION ALL
	SELECT CustomerID FROM Sales.OrdersArchieve
) AS CombinedData