							--TRIGGERS 

--Creating the table 

CREATE TABLE Sales.EmployeeLogs(
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  EmployeeID INT,
  LogMessage VARCHAR(225),
  LogDate
)

--Create Trigger on Employees Tabel

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
	     EmployeeID,
		 'New Employee Added =' + CAST(EmployeeID AS VARCHAR) --CAST BECAUSE OF INT VALUE TO STRING
	FROM INSERTED      
END

/* INSERTED is a virtual table holds copy of rows
that are being inserted into the target table */

--Insert new data into employees 

SELECT * 
FROM Sales.EmployeeLogs
INSERT INTO Sales.Employees
VALUES 
(6, 'Martin', 'John', 'Manager', '2001-10-25', 'M', 100000, 4)