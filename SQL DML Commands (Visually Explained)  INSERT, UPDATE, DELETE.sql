/***************** Data Manipulation Language ********************/
INSERT INTO customers (customerid, firstname, lastname, country, score)
VALUES (5, 'Anna', 'Sanusi', 'USA', NULL), 
	   (7, 'Sam', 'Alton', NULL, 100);
       
INSERT INTO customers (customerid, firstname, lastname)
VALUES (8, 'Andreas', 'Mofan');

SELECT *
FROM customers;

/* SQL TASK
   Copy data from 'customers' table into 'persons'
*/
CREATE TABLE salesdb.persons (
  id INT NOT NULL,
  person_name VARCHAR(50) NOT NULL,
  birth_date DATE,
  phone VARCHAR(15) NOT NULL,
  CONSTRAINT pk_persons PRIMARY KEY (id)
);

SELECT *
FROM persons;

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT customerid, 
       firstname,
       NULL,
       'Unknown'
FROM customers;

/* SQL TASK
   Change the score of customer with ID 5 to 0.
*/
UPDATE customers 
SET score = 0 
WHERE customerid = 5;

SELECT *
FROM customers
WHERE customerid = 5;

SELECT *
FROM customers;


/*
SQL TASK
Change the score of customer with ID 8 to 0 and update the country to 'UK'
*/
SELECT *
FROM customers 
WHERE customerid = 8;

UPDATE customers
SET score = 0,
    country = 'UK'
WHERE customerid = 8;

SELECT *
FROM customers;

/*
SQL TASK
Update all customers with a NULL score by setting their score to 0.
*/
SELECT *
FROM customers
WHERE score IS NULL;

UPDATE customers 
SET score = 0
WHERE score IS NULL;

SELECT *
FROM customers;


/*
SQL TASK
Delete all customers with an ID greater than 5
*/
SELECT *
FROM customers
WHERE customerid > 5;

DELETE FROM customers
WHERE customerid > 5;

SELECT *
FROM customers;

/*
SQL TASK
Delete all data from the persons table
*/
SELECT *
FROM persons;

DELETE 
FROM persons;

TRUNCATE TABLE persons;









