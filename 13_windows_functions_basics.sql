					--WINDOWS FUNCTIONS BASICS

--Find the total sales across all orders
SELECT
SUM(Sales) TotalSales
FROM Sales.Orders;

--Find the total sales for each product

SELECT
	ProductID,
	SUM(Sales) TotalProducts
FROM Sales.Orders
GROUP BY ProductID;

/* Find the total sales for each product, additionally provide details such as 
order id and order data */

SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) TotalSaleProducts
FROM Sales.Orders
GROUP BY ProductID,OrderID,OrderDate; 


/* Find the total sales for each product, additionally provide details such as 
order id and order data */
--Using Windows Functions


SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSaleProducts
FROM Sales.Orders;


--PARTITION BY

/* Find the total sales across all orders, additionally provide details such as 
order id and order data */

SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER () TotalSales
FROM Sales.Orders;


/* Find the total sales for each product, additionally provide details such as 
order id and order data */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSaleProducts
FROM Sales.Orders;



-- Find the total sales across all orders,
--Find the total sales for each product, 
--find the total sales for each combination of product and order status,
--additionally provide details such as order id and order data 

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSalebyProducts,
	SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders;


--ORDER BY

--Rank each order based on their sales from highest to lowest
--Additionally provide details such order id, order date

SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER( ORDER BY Sales DESC) RankSales
FROM Sales.Orders;


--FRAME


SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders;

--Find the total sales for each order status, only for two products 101 and 102

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101,102);

--Rank customres based on their total sales

SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER (ORDER BY SUM(Sales) DESC) CustomerRank
FROM Sales.Orders
GROUP BY CustomerID