				--EXECUTION PLAN
				
--SOURCE: AdventureWorkDW2022
--BASICS

--EXECUTION PLAN 

--(HEAP AND CLUSTERED INDEX)

--HEAP 
SELECT *
FROM FactResellerSales_HP
ORDER BY SalesOrderNumber

--CLUSTERED INDEX
SELECT *
FROM FactResellerSales
ORDER BY SalesOrderNumber

--NON CLUSTERED INDEX AND HEAP 
--HEAP

SELECT *
FROM FactResellerSales_HP
WHERE CarrierTrackingNumber = '4911-403C-98'

--NON CLUSTERED INDEX
SELECT *
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98'

CREATE NONCLUSTERED INDEX idx_FactReseller_CTA
ON FactResellerSales (CarrierTrackingNumber)

(--this operation is called NESTED LOOP)

--ROW STORE AND COLUMN STORE EXECUTION PLAN 

--COLUMN STORE 

SELECT 
	p.EnglishProductName AS ProductName
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey 
GROUP BY p.EnglishProductName

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSales
ON  FactResellerSales_HP 

--ROW STORE

SELECT 
	p.EnglishProductName AS ProductName
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey 
GROUP BY p.EnglishProductName;

--SQL HINTS

SELECT
     o.Sales,
	 c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (INDEX ([PK_Customer_A4AE64B87FC20A48]))
ON o.CustomerID = c.CustomerID
