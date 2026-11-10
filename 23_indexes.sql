					--INDEXES

--Creating the INDEX

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

--Drop the INDEX 

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

--Creating the INDEX (NON CLUSTERED)

CREATE NONCLUSTERED INDEX idx_DBCustomers_CustomerLastName 
ON Sales.DBCustomers (LastName)

CREATE NONCLUSTERED INDEX idx_DBCustomers_CustomerFirstName 
ON Sales.DBCustomers (FirstName)


--Multiple Non Clustered can be created while in clustered not possible 

--Composite Index

--Rule The columns of index order must match the order in your query
--If only one mention for example only country it executes the query if its follows the filter from first column

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);


--COLUMNSTORE INDEX

CREATE  CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);


--Unique Indexes

SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)

--duplicates can't be inserted once the unique table is created 

--FILTERED INDEX

SELECT *
FROM Country = 'Germany'

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'Germany'


--INDEX Management and Monitoring 

--List all indexes on a specific table 

sp_helpindex 'Sales.DBCustomers'


--1.) Monitor the INDEX usage (saves storage and optimizes the query writing)

SELECT 
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	idx.is_primary_key AS ISPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	s.user_seeks AS UserSeeks,
	s.user_scans AS UserScans,
	s.user_lookups AS UserLookups,
	s.user_updates AS UserUpdates,
	COALESCE(s.last_user_seek,s.last_user_scan) LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON   s.object_id = idx.object_id
AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

--2.) Monitor Missing Indexes
SELECT 
      fs.SalesOrderNumber,
	  dp.EnglishProductName,
	  dp.Color
FROM   FactInternetSales fs
INNER JOIN DimProduct dp
ON fs.ProductKey = dp.ProductKey
WHERE dp.color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;

SELECT * FROM sys.dm_db_missing_index_details 

--tip: Evaluate the recommendations before creating any index


--3.) Monitor Duplicate Indexes
SELECT
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexTyoe,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC ;


--4.) Updating the Statistics 

SELECT 
		SCHEMA_NAME(t.schema_id) AS SchemaName,
		t.name AS TableName,
		s.name AS StatisticName,
		sp.last_updated AS LastUpdate,
		DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
		sp.rows AS 'Rows',
		sp.modification_counter AS ModificationSinceLastUpdate
FROM sys.stats AS s
	JOIN sys.tables t
	ON s.object_id = t.object_id
	CROSS APPLY sys.dm_db_stats_properties(s.object_id,s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC;

--Updating the single statistics

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_6EF57B66

--Updating the whole table 

UPDATE STATISTICS Sales.DBCustomers 


--Updating the whole database

EXEC sp_updatestats

--5.) Monitoring Fragmentations

--Checking the health of the index in the database from metadata

SELECT *
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')

--Reorganise the fragments 

ALTER INDEX idx_Customers_CS_Country ON Sales.Customers REORGANIZE

--Rebuild the fragments

ALTER INDEX idx_Customers_CS_Country ON Sales.Customers REBUILD

--Joining the tables into fragments 

SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL, 'LIMITED') AS s
	INNER JOIN sys.tables tbl
	ON s.object_id = tbl.object_id
	INNER JOIN sys.indexes AS idx
	ON idx.object_id = s.object_id
	AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC