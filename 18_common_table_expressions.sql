					--COMMON TABLE EXPRESSION
--NON RECURSIVE CTE

--Standalone CTE

--Step 1: Find the total sales per customer.

WITH CTE_Total_Sales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)

--Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID;


--Multiple Standalone CTEs

--Step 1: Find the total sales per customer.
--Step 2 : Find the last order date per customer.

--Step 1: Find the total sales per customer(--Standalone CTE).

WITH CTE_Total_Sales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Step 2 : Find the last order date per customer (--Standalone CTE).

, CTE_Last_Order AS 
(SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID;


--NESTED CTE

--Step 1 : Find the total sales per customer.
--Step 2 : Find the last order date per customer.
--Step 3 : Rank Customers based on Total Sales Per Customers

--Step 1: Find the total sales per customer(--Standalone CTE).

WITH CTE_Total_Sales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Step 2 : Find the last order date per customer (--Standalone CTE).

, CTE_Last_Order AS 
(SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
--Step 3 : Rank Customers based on Total Sales Per Customers (Nested CTE)
, CTE_Customer_Rank AS 
(
SELECT 
CustomerID,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC ) AS Customer_Rank
FROM CTE_Total_Sales
)
--Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.Customer_Rank
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID;



--Step 1 : Find the total sales per customer.
--Step 2 : Find the last order date per customer.
--Step 3 : Rank Customers based on Total Sales Per Customers.
--Step 4 : Segment customers based on their total sales.

--Step 1: Find the total sales per customer(--Standalone CTE).

WITH CTE_Total_Sales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Step 2 : Find the last order date per customer (--Standalone CTE).

, CTE_Last_Order AS 
(SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
--Step 3 : Rank Customers based on Total Sales Per Customers (Nested CTE)
, CTE_Customer_Rank AS 
(
SELECT 
CustomerID,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC ) AS Customer_Rank
FROM CTE_Total_Sales
)
--Step 4 : Segment customers based on their total sales.
, CTE_Customer_Segment AS 
(
SELECT
CustomerID,
TotalSales,
CASE WHEN TotalSales > 100 THEN 'High'
     WHEN TotalSales > 60 THEN 'Medium'
	 ELSE 'Low'
END Customer_Segment
FROM CTE_Total_Sales
)

--Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.Customer_Rank,
ccs.Customer_Segment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segment ccs
ON ccs.CustomerID = c.CustomerID;


--RECURSIVE CTE

--Generate a sequence of numbers from 1 to 20.

WITH Series AS (
    --Anchor Query
	SELECT
	1 AS MyNumber 
	UNION ALL
	--Recursive Query
	SELECT
	MyNumber  + 1
	FROM Series
	WHERE MyNumber < 20
)
--Main Query
SELECT *
FROM Series

--OPTION (MAXRECURSION ) can be used for how many times of recurson need to be done.


--Task: Show the employee hierarchy by displaying each employee's level within the organization.

WITH CTE_Emp_Hierarchy AS 
(
--Anchor Query
SELECT
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL

UNION ALL

--Recursive Query
SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Level +1
FROM Sales.Employees AS e
INNER JOIN CTE_Emp_Hierarchy ceh
ON e.ManagerID = ceh.EmployeeID
)
--Main Query
SELECT 
*
FROM CTE_Emp_Hierarchy;

