					--ADVANCED SQL

--SUBQUERY

--Scalar Query
SELECT
AVG(Sales) AS AvgSales
FROM Sales.Orders;

--Row Query
SELECT
CustomerID
FROM Sales.Orders;

--Table Subquery

SELECT
CustomerID,
OrderID
FROM Sales.Orders;


/* Task : Find the product that have a price higher than the average
price of all products */

--Main Query
SELECT 
*
FROM (
--Sub Query
	SELECT
	ProductID,
	Price,
	AVG(Price) OVER() AvgPrice
	FROM Sales.Products) T
WHERE AvgPrice < Price;


--FROM CLAUSE

--Rank customers based on their total amount of sales.
--Main Query
SELECT 
*,
RANK() OVER(ORDER BY TotalSales DESC ) AS CustomerRank
FROM
--Sub Query
	(SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
	FROM Sales.Orders
    GROUP BY CustomerID )T;

	                
	--Select Clause (Scalar sub query)

--Show the product IDs, product names, prices and the total number of orders

--Main Query
SELECT 
	ProductID,
	Product,
	Price,
	--Sub Query
	(SELECT COUNT(*) FROM Sales.Orders ) AS TotalOrders
FROM Sales.Products;


--Join Clause (subquery)

--Show all the customer details and find the total orders of each customer

--Main Query
SELECT
c.*,
o.TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
SELECT
CustomerID,
COUNT(*) TotalOrders
FROM Sales.Customers
GROUP BY CustomerID ) o
ON c.CustomerID = o.CustomerID ;

	--WHERE CLAUSE (Comparison Operator)

	/* Task : Find the product that have a price higher than the average
price of all products */


--Main Query
	
SELECT
	ProductID,
	Price,
	(SELECT AVG(Price) FROM Sales.Products) AS AvgPrice --Sub Query
	FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

--(In Operator)

--Show the details of orders made by customers in Germany 

--Main Query 
SELECT 
*
FROM Sales.Orders
WHERE CustomerID IN 
		(SELECT 
		CustomerID
		FROM Sales.Customers
		WHERE Country = 'Germany'); --Sub Query

--Show the detaols of orders for customers who are not from Germany

SELECT 
*
FROM Sales.Orders
WHERE CustomerID IN 
		(SELECT 
		CustomerID
		FROM Sales.Customers
		WHERE Country != 'Germany'); --Sub Query


SELECT 
*
FROM Sales.Orders
WHERE CustomerID NOT IN 
		(SELECT 
		CustomerID
		FROM Sales.Customers
		WHERE Country = 'Germany'); --Sub Query

		
--ALL & ANY OPERATOR 

--Find female employees whose salaries are greater than the salaries of any male employees

--Main Query
SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


--Find female employees whose salaries are greater than the salaries of all male employees

--Main Query
SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


--CORRELATED SUBQUERY AND NON-CORRELATED SUBQUERY

--Show all customers details and find the total orders of each customers

--Main Query
SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders  o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c ;


--EXIST QUERY

--Show the details of orders made by customers in Germany 
--Main Query
SELECT *
FROM Sales.Orders o
WHERE EXISTS 
		(SELECT *
		FROM Sales.Customers c
		WHERE Country = 'Germany' 
		AND  c.CustomerID = o.CustomerID); --Sub Query


--Show the detaols of orders for customers who are not from Germany

--Main Query
SELECT *
FROM Sales.Orders o
WHERE EXISTS 
		(SELECT *
		FROM Sales.Customers c
		WHERE Country != 'Germany' 
		AND  c.CustomerID = o.CustomerID); --Sub Query

--OR
		--Main Query
SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS 
		(SELECT *
		FROM Sales.Customers c
		WHERE Country = 'Germany' 
		AND  c.CustomerID = o.CustomerID); --Sub Query
