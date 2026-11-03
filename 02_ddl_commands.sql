				--Data Defintion Language
--CREATE

/* Create a new table called peoples with columns: id,person_name,
birth_date, and phone */

CREATE TABLE peoples ( 
id INT NOT NULL,
person_name VARCHAR (50) NOT NULL,
birth_date DATE,
phone VARCHAR (15) NOT NULL,
CONSTRAINT pk_peoples PRIMARY KEY (id)
);

--ALTER

--Add a new column called email to the peoples table

ALTER TABLE peoples
ADD email VARCHAR (50) NOT NULL;

--Remove the column phone from the peoples table 

ALTER TABLE peoples
DROP COLUMN phone;

--DROP

--Delete the table the peoples from the database

DROP TABLE peoples