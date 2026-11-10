				 --STORED PROCEDURES

--Step 1: Write a query
--For USA customers find the total number of customers and the average score.

SELECT 
COUNT(*) TotalCustomers,
AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

--Step 2: Turning the query into a stored procedure 

CREATE PROCEDURE GetCustomersSummaryUSA AS 
BEGIN
SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END ;

--Step 3: Execute the stored procedure 

EXEC GetCustomersSummaryUSA ;


--For Germany customers find the total number of customers and the average score.

CREATE PROCEDURE GetCustomersSummaryGermany AS 
BEGIN
SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany'
END ;

--Execute the stored procedure 

EXEC GetCustomersSummaryGermany ;

--Define Stored Procedure 

CREATE PROCEDURE GetCustomersSummary @Country NVARCHAR (50) --FOR DEFAULTS CAN USE = 'COUNTRY'
BEGIN
SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END ;

--Execute the stored procedure 
EXEC GetCustomersSummary @Country = 'Germany'


--drop 

DROP PROCEDURE EXEC GetCustomersSummaryGermany ;

--Multiple Queries in short procedure

--Define Stored Procedure 

CREATE PROCEDURE GetCustomersSummary @Country NVARCHAR (50) AS
BEGIN
SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country;

--Find the total No. of orders and total sales.

SELECT 
	COUNT(OrderID) TotalOrders
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c 
ON c.CustomerID = o.CustomerID
WHERE c.country = @country;

END

--Execute the stored procedure 

EXEC GetCustomerSummary
EXEC GetCustomerSummary @Country = 'Germany';


--VARIABLES 

--SAME ABOVE QUERY WITH THE NEW 
--Total Customers from Germany: 2 
--Average Score from Germany: 425

CREATE PROCEDURE GetCustomersSummary @Country NVARCHAR (50) ='USA'
AS 
BEGIN 
	BEGIN TRY (--ERROR HANDLING)

	DECLARE @TotalCustomers INT, @AvgScore FLOAT; -- step 1 Declare Variables

--=================================================================================
--Prepare & Cleanup Data (NULL)
--=================================================================================

	IF EXISTS ( SELECT * FROM Sales.Customers WHERE Score IS NULL AND Country= @Country)
	BEGIN 
				 PRINT ('Updating NULL Score to 0 ')
				 UPDATE Sales.Customers
				 SET SCORE = 0
				 WHERE Score IS NULL AND Country = @Country;
		END

		ELSE 
		BEGIN
			PRINT ('No NULL Scores Found')
		END;

--===============================================================================================
		--Generating The Summary Reports
--===============================================================================================
		--Calculate Total Customers and Average Score for specific country 

		SELECT 
				@TotalCustomers = COUNT(*) ,    --step 2 assigning the variables value and remove alias
				@AvgScore = AVG(Score)
			FROM Sales.Customers
			WHERE Country = @Country;

		--print syntax for text instead table (in print only strings only can be used no other values can be used)
		--since @TotalCustomers and  @AvgScore are different value we use cast for avoiding the error

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR); 
		PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);           

		--step 3 use variables instead of static values

		--Calculate  Total Number of orders and total sales for specific country
		
		SELECT 
				COUNT(OrderID) TotalOrders
				SUM(Sales) TotalSales
			FROM Sales.Orders o
			JOIN Sales.Customers c 
			ON c.CustomerID = o.CustomerID
			WHERE c.country = @country;

		END TRY   --(ERROR HANDLING)
		BEGIN CATCH
				  PRINT('An Error Occured.');
				  PRINT('Error Message: ' + ERROR_MESSAGE ());
				  PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
				  PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
				  PRINT('Error Procedure ' + ERROR_PROCEDURE ());
	END CATCH
END;


--EXECUTING 
EXEC GetCustomerSummary
EXEC GetCustomersSummary @Country = 'Germany'
