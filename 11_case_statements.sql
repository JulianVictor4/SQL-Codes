					--CASE STATEMENTS

/* Generate a report showing the total sales for each category :
-High: If the sales higher than 50
-Medium: If the sales between 20 and 50
-Low: If the sales equal or lower than 20
Sort the results from lowest to highest */

SELECT
OrderID,
Sales,
CASE 
	WHEN Sales > 50 THEN 'High'
	WHEN Sales > 20  THEN 'Medium'
	ELSE  'Low'
END Category
FROM Sales.Orders;


SELECT 
Category,
SUM(Sales) AS TotalSales
FROM(
SELECT
OrderID,
Sales,
CASE 
	WHEN Sales > 50 THEN 'High'
	WHEN Sales > 20  THEN 'Medium'
	ELSE  'Low'
END Category
FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC;


--Retrieve employee details with gender displayed aas full text

SELECT
	EmployeeID,
	FirstName,
	LastName,
	Gender,
CASE
WHEN Gender =  'M' THEN 'Male'
WHEN Gender =  'F' THEN 'Female'
ELSE 'Not Available'
END GenderFullText
FROM Sales.Employees;

--Retrieve customer details with abbreviated country code 

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
CASE 
    WHEN Country = 'Germany' THEN 'DE'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'Not Available'
END CountryAbb
FROM Sales.Customers;

--query 2 (quick format)

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
CASE Country
    WHEN 'Germany' THEN 'DE'
	WHEN 'USA' THEN 'US'
	ELSE 'Not Available'
END CountryAbb
FROM Sales.Customers;


/* Find the average scores of customers and treat Nulls as 0 and additional 
provide details such CustomerID & LastName */ 

SELECT
CustomerID,
LastName,
Score,
CASE 
    WHEN Score IS NULL THEN 0
	ELSE Score
	END CleanScore,

AVG(CASE 
    WHEN Score IS NULL THEN 0
	ELSE Score
	END) OVER() AvgCleanCustomer,

AVG(Score) OVER() AvgCustomer
FROM Sales.Customers;


--Count how many times each customer has made an order with sales greater than 30

SELECT
OrderID,
CustomerID,
Sales,
CASE 
    WHEN Sales > 30 THEN 1
	ELSE 0
END SalesFlag
FROM Sales.Orders
ORDER BY CustomerID;

--2ND Query
SELECT
	CustomerID,
	SUM(CASE 
    WHEN Sales > 30 THEN 1
	ELSE 0
END) TotalOrderHighSale,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID;