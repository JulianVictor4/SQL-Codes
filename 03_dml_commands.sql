				--Data Manupulation Language
--INSERT

INSERT INTO customers (id, first_name, country, score)
VALUES
	(6, 'Sam', 'USA', NULL),
	(7, 'Anna', NULL, 100);

--Insert data from 'customers' table into 'persons'

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
id,
first_name,
NULL,
'unknown'
FROM customers;

--Update

--Change the score of customer with id 6 to 0

UPDATE customers 
SET score = 0
WHERE id = 6;

-- Change the score of customer 7 to 0 and update the country to UK

UPDATE customers
SET score = 0,
country = 'UK'
WHERE id = 7;

--Update all customers with a NULL score by settig their score to 0

UPDATE customers
SET score = 0
WHERE score IS NULL;


--Delete 

--Delete all customers with an Id greater than 5

DELETE FROM customers
WHERE id > 5;

-- Delete all data from the persons table 

TRUNCATE TABLE persons
