					--SQL FUNCTION

--NULL FUNCTION
--IS NULL AND COALESCE 

--Find the average scores of the customers

SELECT
customerID,
Score,
COALESCE(Score,0) Score2,
AVG(Score) OVER () AvgScore,
AVG(COALESCE(Score,0)) OVER () AvgScore2
FROM Sales.customers;

--Display the full name of customers in a single field 
--by merging their first and last names,
--and add 20 bonus points to each customers score.

SELECT 
CustomerID,
FirstName,
LastName,
FirstName + '' + COALESCE(LastName, '') AS FullName,
Score,
COALESCE(Score,0) + 20 AS ScoreAfterBonus
FROM Sales.Customers;

--Sort the customers from lowest to highest scores, with NULLs appearing last

SELECT 
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score ;

--NULLIF USE CASE DIV. BY 0

--Find the sales price for each order by dividing sales by quantity

SELECT
OrderID,
Sales,
Quantity,
Sales/ NULLIF(Quantity,0) AS Price 
FROM Sales.Orders;


--IS NULL AND IS NOT NULL
--USE CASE 

--Identify the customers who have no scores

SELECT *
FROM Sales.Customers
WHERE Score IS NULL;

--List all customers who have scores

SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

--USE CASE 2 

--List all details for customers who have not placed any orders 

SELECT
c.*,
o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


--NULL/BLANK/EMPTY 
--Example

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '  ' UNION
SELECT 4, ''
)

--Query with Data Policies

SELECT *,
DATALENGTH (Category) AS CategoryLength,
DATALENGTH (TRIM(Category)) AS Policy1, --Trim Function
NULLIF(TRIM(Category),'') AS Policy2, --Nullif instead off other 
COALESCE(NULLIF(TRIM(Category),''), 'unknown') AS Policy3 --unknown instead other
FROM Orders

