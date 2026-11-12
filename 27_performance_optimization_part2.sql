						--SQL PERFORMANCE OPTIMIZATION PART 2 

--AGGREGATE DATA

--Tip 17: Use columnstore Index for aggregations on large table 

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Sales.Orders
GROUP BY CustomerID

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders

--===========================================================================

--Tip 18:Pre-Aggregate data and store it in new table for reporting (need to run query each time for updates)

SELECT MONTH(OrderDate) OrderYear, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

SELECT OrderYear, TotalSales FROM Sales.SalesSummary

--============================================================================

--SUBQUERIES

--Tip 19:Understand when to use JOIN,EXISTS, or IN. Avoid IN with large lists as it can be inefficient

--JOIN (Best Practice - if the performance equal to EXISTS)

SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

--EXISTS (Best practice : use it for large table )

SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
		SELECT 1
		FROM Sales.Customers c
		WHERE c.CustomerID = o.CustomerID
		AND c.Country = 'USA'
)

--IN (Bad practice)

SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE o.CustomerID IN (
		SELECT CustomerID
		FROM Sales.Customers
		WHERE Country = 'USA'
)

--==================================================================

--Tip 20: Avoid Redundant logic in your query (spot redundant queries and review then fix it)

--Bad practice 
SELECT EmployeeID, FirstName, 'Above Average' Status
FROM Sales.Employees 
WHERE Salary > (SELECT AVG(Salary) FROM Sales.Employees)
UNION ALL 
SELECT EmployeeID, FirstName, 'Below  average' Status
FROM Sales.Employees
WHERE Salary < (SELECT AVG(Salary) FROM Sales.Employees)

--Good practice

SELECT
EmployeeID,
FirstName,
	CASE 
		WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
		WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
		ELSE 'Average'
	END AS Status 
FROM Sales.Employees

--==================================================================
--Creating Tables DDL

--Tip 21:Avoid data types VARCHAR & TEXT (VARCHAR >> TEXT)
--Tip 22:Avoid MAX unnecessarily large lengths in data types
--Tip 23: Use the NOT NULL constraint where applicable
--Tip 24: Ensure all your tables have a clustered primary key
--Tip 25: Create a non clustered index for foreign keys that are used frequently
---
CREATE TABLE CustomersInfo(
	CustomerID INT,
	FirstName VARCHAR (MAX),
	LastName TEXT,
	Country VARCHAR(255),
	TotalPurchases FLOAT,
	Score VARCHAR(250),
	BirthDate VARCHAR(255),
	EmployeeID INT,
	CONSTRAINT FK_CustomerInfo_EmployeeID FOREIGN KEY (EmployeeID)
	   REFERENCES Sales.Employees(EmployeeID)
)


--after 

CREATE TABLE CustomersInfo(
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName VARCHAR (25) NOT NULL,
	LastName VARCHAR (25) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomerInfo_EmployeeID FOREIGN KEY (EmployeeID)
	   REFERENCES Sales.Employees(EmployeeID)
)

CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID
ON CustomersInfo(EmployeeID)

--================================================================
--INDEXING 
--Tip 26:Avoid over indexing
--Tip 27:Drop unused indexes
--Tip 28:Update statistics (weekly)
--Tip 29:Reorganize & Rebuild indexes (weekly)
/* Tip 30:Partition large tables (facts) to improve performance next, 
apply a columnstore index for the best results */

--Extra Tips 

--Focus on writing queries clearly
--Optimize performance only when necessary
--Always test using execution plan