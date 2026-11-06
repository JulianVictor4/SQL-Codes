					--AGGREGATE FUNCTION

--Find the total number of orders

SELECT 
COUNT(*) AS total_num_orders
FROM Orders;

--Find total sales of all orders

SELECT
SUM(Sales) AS total_sales
FROM Orders;

--Find the average sales of all orders

SELECT
AVG(Sales) AS Avg_sales
FROM Orders;

--Find the highest sales among customers

SELECT
MAX(Sales) AS Highest_sales
FROM Orders;


--Find the lowest sales among customers

SELECT
MIN(Sales) AS Highest_sales
FROM Orders;

--Group By can break the aggregate values