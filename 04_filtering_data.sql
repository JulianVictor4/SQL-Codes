				--Filtering Data
--Comparison Operator 

--Retrieve all customers from Germany.

SELECT *
FROM customers
WHERE country = 'Germany';

--Retrieve all customers who are not from Germany.

SELECT *
FROM customers
WHERE country != 'Germany';

--Retrieve all customers with a score greater than 500.

SELECT *
FROM customers
WHERE score > 500;

--Retrieve all customers with a score of 500 or more.

SELECT *
FROM customers
WHERE score >= 500;

--Retrieve all customers with a score less than 500.

SELECT *
FROM customers
WHERE score < 500;

--Retrieve all customers with a score of 500 and less.

SELECT *
FROM customers
WHERE score <= 500;


--Logical Operators

--AND
/* Retrieve all customers who are from the USA and have a score 
greater than 500 */

SELECT *
FROM customers
WHERE country = 'USA' AND score > 500;

--OR
/* Retrieve all customers who are from the USA or have a score 
greater than 500 */

SELECT *
FROM customers
WHERE country = 'USA' OR score > 500;

--NOT
/* Retrieve all customers with a score not less than 500 */

SELECT *
FROM customers
WHERE NOT score < 500;

--Range Operator 

--BETWEEN
/* Retrieve all customers whose score falls in the range 
between 100 and 500 */

SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;

--Using Comparison Operator
SELECT *
FROM customers
WHERE score >= 100 AND score <= 500;


--Membership Operator 

--IN
--Retrieve all customers from either Germany or USA.

SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');

--NOT IN
--Retrieve all customers not from either Germany or USA.

SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'USA');

--Search Operator

--LIKE
--Find all customers whose first name starts with 'M'.

SELECT *
FROM customers
WHERE first_name LIKE 'M%';

--Find all customers whose first name ends with 'n'.

SELECT *
FROM customers
WHERE first_name LIKE '%n';

--Find all customers whose first name contains 'r'.

SELECT *
FROM customers
WHERE first_name LIKE '%r%';

--Find all the customers whose first name has 'r' in third position.

SELECT *
FROM customers
WHERE first_name LIKE '__r%'