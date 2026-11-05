					--SQL Functions
--Single-Row Function 

--String Functions 

--Manipualtion
--CONCAT

--Concatenate first name and country into one column

SELECT 
first_name,
country,
CONCAT (first_name, '_', country) AS name_country
FROM customers;


--UPPER and LOWER 

--Convert the first name to lowercase.

SELECT 
first_name,
LOWER (first_name) AS lowercase_firstname
FROM customers;

--Convert the first name to uppercase.


SELECT 
first_name,
UPPER (first_name) AS uppercase_firstname
FROM customers;


--TRIM

/* Find the customers whose first name contains leading
or trailing spaces */

SELECT 
first_name
FROM customers
WHERE first_name != TRIM (first_name);

--Complex Query

SELECT 
first_name,
LEN(first_name) AS len_name,
LEN(TRIM(first_name)) AS len_trim_name,
LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM (first_name));


--REPLACE

--Remove dashes (-) from a phone number 

SELECT
'123_456_7890' AS phone_number,
REPLACE('123_456_7890', '_', '') AS formated_phonenumber;

--Replace file extence from txt to csv

SELECT
'file.txt' AS old_file,
REPLACE('file.txt', '.txt', '.csv') AS new_file;


--Calculation

--LEN 

--Calculate the length of each customer's first name 

SELECT 
first_name,
LEN(first_name) AS len_first_name
FROM customers;


--String Extraction

--LEFT AND RIGHT

--Retrieve the first two characters of each first name.

SELECT
first_name,
LEFT(first_name,2) AS  first_2_char
FROM customers;

--incase of space before name then,

SELECT
first_name,
LEFT(TRIM(first_name),2) AS  first_2_char
FROM customers;

--Retrieve the last two characters of each first name.

SELECT
first_name,
RIGHT(first_name,2) AS last_2_char
FROM customers;


--SUBSTRING

/* Retrieve a list of customers first names
removing the first character */

SELECT
first_name,
SUBSTRING(first_name,2) AS sub_name
FROM customers;

--method 2 

SELECT
first_name,
SUBSTRING(first_name,2, LEN(first_name)) AS sub_name
FROM customers;

--Incase of space before name 

SELECT
first_name,
SUBSTRING(TRIM(first_name),2, LEN(first_name)) AS sub_name
FROM customers;


--NUMBER FUNCTIONS

--Round Function

SELECT 3.516
ROUND(3.516,2) AS round_2,
ROUND(3.516,1) AS round_1,
ROUND(3.516,0) AS round_0

--ABS 

SELECT -10,
ABS (-10) AS abs_value
