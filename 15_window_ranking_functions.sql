						--WINDOW RANKING FUNCTION

--ROW NUMBER FUNCTION

--Rank the orders based on their sales from highest to lowest

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) AS SalesRank_Row,
	RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;

--RANK FUNCTION

--Rank the orders based on their sales from highest to lowest

SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;


--DENSE RANK

--Rank the orders based on their sales from highest to lowest

SELECT
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER (ORDER BY Sales DESC) AS SalesRank_Dense
FROM Sales.Orders;

--USE CASES
--Top-N Analysis

--Find the top highest sales for each product

SELECT *
FROM (
	SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM Sales.Orders) T
WHERE RankByProduct = 1;

--Bottom-N Analysis

--Find the lowest 2 customers based on their total sales.

SELECT *
FROM(
SELECT
	CustomerID,
	SUM(Sales) AS Total_Sales,
	ROW_NUMBER() OVER( ORDER BY SUM(Sales)ASC) AS RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
)t
WHERE RankCustomers <=2;

--ROW NUMBER USE CASE GENERATE UNIQUE IDs 
--helps to assign unique identifier for each row to help paginating

--Assign inique IDs to the rows of the 'Order Archive' table

SELECT 
ROW_NUMBER () OVER (ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive;

--Identify Duplicates data cleansing

/* Identify duplicate rows in the table 'Orders Archive' and
return a clean result without any duplicates */

SELECT *
FROM (
SELECT 
ROW_NUMBER () OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) AS RealData,
*
FROM Sales.OrdersArchive ) T
WHERE RealData = 1;


--NTILE FUNCTION 

SELECT 
OrderID,
Sales,
NTILE(1) OVER (ORDER BY Sales DESC) OneBucket
FROM Sales.Orders;


SELECT 
	OrderID,
	Sales,
	NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
	NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
	NTILE(4) OVER (ORDER BY Sales DESC) FourBucket
FROM Sales.Orders;

--USE CASE 
--DATA SEGMENTATION

--Segment all orders into 3 categories: high, medium, and low sales

SELECT *,
CASE WHEN Buckets = 1 THEN 'High'
     WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM( 
SELECT
OrderID,
Sales,
NTILE(3) OVER ( ORDER BY Sales DESC) AS Buckets
FROM Sales.Orders) T;

--EQUALIZING LOAD 

--In order to export the data, divide the orders into 2 groups.

SELECT
NTILE(2) OVER (ORDER BY OrderID) Buckets,
*
FROM Sales.Orders;


--CUME_DIST AND PERCENT_RANK

--Find the products that fall within the highest 40% of prices

SELECT *,
CONCAT( DistRank * 100, '%')  DistRankPercentage
FROM(
	SELECT
	Product,
	ProductID,
	Price,
	CUME_DIST () OVER (ORDER BY Price DESC) DistRank
	FROM Sales.Products) t
WHERE  DistRank <=0.4;

--Use PercentRank

SELECT *,
CONCAT( DistRank * 100, '%')  DistRankPercentage
FROM(
	SELECT
	Product,
	ProductID,
	Price,
	PERCENT_RANK () OVER (ORDER BY Price DESC) DistRank
	FROM Sales.Products) t
WHERE  DistRank <=0.4;