				--CTAS and TEMP TABLES

--Creating the Table.

SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME (month, OrderDate);

--DROP THE TABLE 
DROP TABLE Sales.MonthlyOrders

--HOW TO REFRESH THE CTAS 

IF OBJECT_ID ('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO
SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME (month, OrderDate);


--TEMPORARY TABLE

SELECT *
INTO #Orders
FROM Sales.Orders

--DELETE DATA INSIDE TEMP. TABLE 

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

--Save temp. table into permanent table 

SELECT *
INTO Sales.OrdersTest
FROM #Orders