					--Set Operators
/* Rules
1.) ORDER BY can be used only once
2.)Same Number of Columns
3.)Matching Data Types
4.)Same Order of Columns
5.)First Query Control Aliases
6.)Mapping Correct Columns */


--Union

 --Combine the data from employees and customers into one table.

SELECT 
	FirstName,
	LastName
FROM sales.customers
UNION
SELECT 
	FirstName,
	LastName
FROM sales.employees;


--Union All

/* Combine the data from employees and customers into one table,
including duplicates. */

SELECT 
	FirstName,
	LastName
FROM sales.customers
UNION ALL
SELECT 
	FirstName,
	LastName
FROM sales.employees;


--Except (Minus)

/* Find customers who are not employees at the same time  */

SELECT 
	FirstName,
	LastName
FROM sales.customers
EXCEPT
SELECT 
	FirstName,
	LastName
FROM sales.employees;


/* Find employees who are not customers at the same time  */

SELECT 
	FirstName,
	LastName
FROM sales.employees
EXCEPT
SELECT 
	FirstName,
	LastName
FROM sales.customers;


--Intersect

--Find the employees who are also customers

SELECT 
	FirstName,
	LastName
FROM sales.employees
INTERSECT
SELECT 
	FirstName,
	LastName
FROM sales.customers;


--Set Use Case (Combine Information) UNION and UNION ALL.
--Orders data are stored in seperate tables (Orders and OrdersArchive).
--Combine all orders data into one report without duplicates.

SELECT *
FROM Sales.Orders
UNION
SELECT *
FROM Sales.OrdersArchive
ORDER BY OrderID;

/* Clear Query (to avoide inaccurate data) and 
adding source table to show the sources of result */

SELECT 
       'Orders' AS SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
	  ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
       'OrdersArchive' AS SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
	  ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID;


--Set Use Case (Delta Detection)

/* using Except (Minus) to filter the data from sources to avoid
repeated data before loading to data warehouse */


--Set Use Case (Data Completeness Check)

/* using this to check data completeness and
data migrations using Except */