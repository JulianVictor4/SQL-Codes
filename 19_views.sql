					--VIEWS

--Find the running total of sales for each month
--CTE BASED 

WITH CTE_Monthly_Summary AS (
	SELECT 
	DATETRUNC(month, OrderDate ) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)
SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary;

--DDL Comment 

CREATE VIEW Sales.V_Monthly_Summary AS

(  
    SELECT 
	DATETRUNC(month, OrderDate ) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

--Drop the view table

DROP VIEW Sales.V_Monthly_Summary;

-- (OR)

IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL
  DROP VIEW Sales.V_Monthly_Summary;


  --Provide a view that combines details from orders,products,customers and employees.

  CREATE VIEW Sales.V_Order_Details AS (
	  SELECT
	  o.OrderID,
	  o.OrderDate,
	  p.Product,
	  p.Category,
	  COALESCE(c.FirstName,'') + '' + COALESCE(c.LastName,'') CustomerName,
	  c.Country CustomerCountry,
	  COALESCE(e.FirstName,'') + '' + COALESCE(e.LastName,'') SalesPersonName,
	  e.Department,
	  o.Sales,
	  o.Quantity
	  FROM Sales.Orders o
	  LEFT JOIN Sales.Product p
	  ON p.ProductID = o.ProductID
	  LEFT JOIN Sales.Customers c
	  ON c.CustomerID = o.CustomerID
	  LEFT JOIN Sales.Employee e 
	  ON e.EmployeeID = O.SalesPersonID
  );

  --VIEW SECURITY 

  --Provide a view for EU sales team 
  --that combines details from all tables
  --and excludes data related to the USA.


 CREATE VIEW Sales.V_Order_Details_EU AS (
	  SELECT
	  o.OrderID,
	  o.OrderDate,
	  p.Product,
	  p.Category,
	  COALESCE(c.FirstName,'') + '' + COALESCE(c.LastName,'') CustomerName,
	  c.Country CustomerCountry,
	  COALESCE(e.FirstName,'') + '' + COALESCE(e.LastName,'') SalesPersonName,
	  e.Department,
	  o.Sales,
	  o.Quantity
	  FROM Sales.Orders o
	  LEFT JOIN Sales.Product p
	  ON p.ProductID = o.ProductID
	  LEFT JOIN Sales.Customers c
	  ON c.CustomerID = o.CustomerID
	  LEFT JOIN Sales.Employee e 
	  ON e.EmployeeID = O.SalesPersonID
	  WHERE c.Country != 'USA');

