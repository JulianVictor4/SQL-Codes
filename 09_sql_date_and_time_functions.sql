					--SQL FUNCTIONS

--Single-Row Functions

--DATE AND TIME FUNCTIONS 

--Part Extraction

--Extracting year from the creation time using year function

SELECT 
OrderID,
CreationTime,
YEAR(CreationTime) AS Year
FROM Sales.Orders;

--Extracting month from the creation time using month function

SELECT 
OrderID,
CreationTime,
MONTH(CreationTime) AS Month
FROM Sales.Orders;

--Extracting date from the creation time using date function

SELECT 
OrderID,
CreationTime,
DAY(CreationTime) AS Day
FROM Sales.Orders;


--DATEPART FUNCTION

--Extracting month from the creation time using datepart function

SELECT 
OrderID,
CreationTime,
DATEPART(month,CreationTime) AS month_datepart
FROM Sales.Orders;

--Extracting year from the creation time using datepart function

SELECT 
OrderID,
CreationTime,
DATEPART(year,CreationTime) AS year_datepart
FROM Sales.Orders;

--Extracting week from the creation time using datepart function

SELECT 
OrderID,
CreationTime,
DATEPART(week,CreationTime) AS week_datepart
FROM Sales.Orders;

--Extracting hour and quarter from the creation time using datepart function

SELECT 
OrderID,
CreationTime,
DATEPART(hour,CreationTime) AS hour_datepart,
DATEPART(quarter,CreationTime) AS quarter_datepart
FROM Sales.Orders;


--DATENAME FUNCTION

--Extracting month and day from the creation time using datename function

SELECT 
OrderID,
CreationTime,
DATENAME(month,CreationTime) AS month_datename,
DATENAME(weekday,CreationTime) AS weekday_datename
FROM Sales.Orders;


--DATETRUNC FUNCTION

--Datetrunc upto hours 

SELECT 
OrderID,
CreationTime,
DATETRUNC(HOUR,CreationTime) AS hour_datetrunc
FROM Sales.Orders;

--Datetrunc upto day

SELECT 
OrderID,
CreationTime,
DATETRUNC(day,CreationTime) AS day_datetrunc
FROM Sales.Orders;

--Datetrunc upto year 

SELECT 
OrderID,
CreationTime,
DATETRUNC(year,CreationTime) AS year_datetrunc
FROM Sales.Orders;

--Use Datetrunc and count the number of orders by month

SELECT 
DATETRUNC(month,CreationTime) AS month_orders,
COUNT (*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime);


--EOMONTH FUNCTION

SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) AS EndofMonth
FROM Sales.Orders;

--how to bring begining of month in EOMONTH function

SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) AS EndofMonth,
DATETRUNC(month,CreationTime) AS StartofMonth
FROM Sales.Orders;

--to get only date without the time 

SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) AS EndofMonth,
CAST(DATETRUNC(month,CreationTime)  AS DATE ) StartofMonth
FROM Sales.Orders;


--PART EXTARCTTION
--Aggregation

--How many orders were placed each year?

SELECT
YEAR(OrderDate),
COUNT(*) AS NumOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

--How many orders were placed each month?

SELECT
MONTH(OrderDate),
COUNT(*) AS NumOfOrders
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

SELECT
DATENAME(month,OrderDate) AS orderdatemonth,
COUNT(*) AS NumOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate);

--Data Filtering

--Show all orders that were placed during the month of february

SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2


--FORMATING AND CASTING 

SELECT
OrderID,
CreationTime,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd
FROM Sales.Orders;

--month

SELECT
OrderID,
CreationTime,
FORMAT(CreationTime, 'MM') MM,
FORMAT(CreationTime, 'MMM') MMM,
FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders;

--Europe and USA format 
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime, 'dd-MM-yyyy') AS Europe_format,
FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_format
FROM Sales.Orders;

--Show creation time using the following Day WED Jan Q1 2025 12:34:56 PM

SELECT
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime, 'ddd MMM') + 
' Q' + DATENAME(quarter, CreationTime) + ' ' +
FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;


--Sales by Month (report)
SELECT
FORMAT(OrderDate, 'MMM yy') AS OrderDate,
COUNT(*)
FROM Sales.Orders 
GROUP BY FORMAT(OrderDate, 'MMM yy') ;


--CONVERT
SELECT 
CONVERT (INT, '1234') AS [Strings to Int CONVERT],
CONVERT (DATE, '2026-11-04') AS [Strings to Date CONVERT],
CreationTime,
CONVERT (DATE, CreationTime) AS [DateTime to Date CONVERT]
FROM Sales.Orders;

-----
SELECT 
CreationTime,
CONVERT (DATE, CreationTime) AS [DateTime to Date CONVERT],
CONVERT(VARCHAR,CreationTime, 34) AS [Euro std. Style 34],
CONVERT(VARCHAR,CreationTime, 32) AS [USA std. Style 32]
FROM Sales.Orders;


--CAST

SELECT
CAST('12234' AS INT) AS [String to Int],
CAST(12234 AS VARCHAR) [INT to String],
CAST('2026-11-04' AS DATE) AS [String to Date],
CAST('2026-11-04' AS DATETIME2) AS [String to Datetime],
CreationTime,
CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders;


--DATE CALCULATIONS

--DATEADD
SELECT
OrderID,
OrderDate,
DATEADD(day, -5, OrderDate) AS fivedaybefore,
DATEADD(month, 2, OrderDate) AS twomonthafter,
DATEADD(year, 1, OrderDate) AS oneyearafter
FROM Sales.Orders;


--DATEDIFF

--Calculate the age of employees

SELECT
EmployeeID,
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) AS AgeOfEmployee
FROM Sales.Employees;

--Find the shipping duration in days for each order.

SELECT
OrderID,
OrderDate,
ShipDate,
DATEDIFF(day, OrderDate, ShipDate) AS ShippingDuration
FROM Sales.Orders;

--Find the average shipping duration in days for each month

SELECT
MONTH(OrderDate) AS OrderMonth,
AVG(DATEDIFF(day, OrderDate, ShipDate)) AS Avg_ShippingDuration
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

--Time Gap Analysis
--Find the number of days between each order and previoud order.

SELECT
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NoOfDays
FROM Sales.Orders;


--VALIDATION
--ISDATE

SELECT ISDATE('234') AS date_check1,
ISDATE('2026-11-04') AS date_check2,
ISDATE('04-11-2026') AS date_check3,
ISDATE('2026') AS date_check4;


SELECT
OrderDate,
ISDATE(OrderDate),
CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
    ELSE '9999-01-01'
	END NewOrderDate
FROM
(
SELECT '2025-08-20' AS OrderDate UNION
SELECT '2025-08-21' UNION
SELECT '2025-08-23' UNION
SELECT '2025-08'
)
WHERE ISDATE(OrderDate) = 0