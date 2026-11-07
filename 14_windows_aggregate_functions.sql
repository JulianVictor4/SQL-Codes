					--WINDOW AGGREGATE FUNCTIONS

--COUNT FUNCTION 

--Find the total number of Orders

SELECT 
COUNT (*) TotalOrders
FROM Sales.Orders;

--Find the total number of Orders
--Find the total number of orders for each customers
--Additionally provide details such as order id and order date

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) OrderByCustomer
FROM Sales.Orders;

----Find the total number of customers
--Additionally provide all customers details

SELECT
*,
COUNT(*) OVER() TotalCustomers
FROM Sales.Customers;

--Find the total number of scores for the customers

SELECT
	CustomerID,
	Score,
	COUNT(Score) OVER() TotalScore
FROM Sales.Customers;

--Check wheather the table 'Orders' contains any duplicate rows

SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders;


SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive;

--Duplicates in Result

SELECT *
FROM
(SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive
)t 
WHERE CheckPK > 1;



--SUM FUNCTION

--Find the total sales across all orders and the total sales for each product.
--Additionally, provide details such as OrderID and Order date.

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	COUNT(Sales) OVER() TotalSales ,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProduct
FROM Sales.Orders;

--COMPARISION ANALYSIS

--Find the percentage contribution of each product's sales to the total sales

SELECT 
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER () TotalSales,
	ROUND (CAST (Sales AS Float) / SUM(Sales) OVER () * 100, 2 ) PercentageOfTotal
FROM Sales.Orders;

--casting is for changing the integer to float for calculation


--AVERAGE FUNCTIONS
--Find the average sales across all orders and find the average sales for each product
--Additionally provide details such orderid, order date.

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductId,
	AVG(Sales) OVER () AverageSales,
	AVG(Sales) OVER (PARTITION BY ProductId) AverageSalesByProduct
FROM Sales.Orders;

--Find the average scores of customers
--Additionally provide details such CustomerID and LastName

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) CustomerScore,
	AVG(COALESCE(Score,0)) OVER () AvgScore
FROM Sales.Customers;

--Find all orders where sales are higher than the average sales across all orders.

SELECT *
FROM (
	SELECT
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER () AvgSales
	FROM Sales.Orders
	) d
WHERE Sales > AvgSales;


--MIN AND MAX FUNCTIONS

--Find the lowest and highest sales of all orders
--Find the lowest and highest sales for each product
--Additionally provide details such order id, order date

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	MIN (Sales) OVER() LowestSales,
	MAX(Sales) OVER() HighestSales,
	MIN (Sales) OVER(PARTITION BY ProductID) ProductLowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) ProductHighestSales
FROM Sales.Orders;

--Show the employees who have the highest salaries

SELECT *
FROM(
SELECT
*,
MAX(Salary) OVER () HighestSalary
FROM Sales.Employees) T
WHERE Salary = HighestSalary;

--Calculate the deviation of each sale from both the minimum and maximum sales amounts.

SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
MIN(Sales) OVER () MinSales,
MAX(Sales) OVER () MaxSales,
Sales - MIN(Sales) OVER () DeviationFromMin,
MAX(Sales) OVER () - Sales DeviationFromMax
FROM Sales.Orders;


--USE CASE
--RUNNING AND ROLLING TOTAL  

--ANALYTICAL USE CASE 
--MOVING AVERAGE 

--Calculate the moving (running) average of sales for each product over time 

SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders;



/* Calculate the moving (running) average of sales for each product over time,
including only the next order. */

SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders


