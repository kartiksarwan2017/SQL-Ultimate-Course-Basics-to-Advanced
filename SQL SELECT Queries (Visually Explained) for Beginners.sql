USE mydatabase;

-- This is a comment.

/* This 
   is a comment
*/

/* SQL TASK
   Retrieve All Customer Data
*/
SELECT * 
FROM customers;

/*
SQL TASK
Retrieve All Order Data
*/
SELECT *
FROM orders;


/*
SQL TASK
Retrieve each customer's name, country and score
*/
SELECT 
	firstname, 
	lastname,
	country,
	score
FROM customers;

/*
SQL TASK
Retrieve customers with a score not equal to 0.
*/
SELECT *
FROM customers
WHERE score != 0;

SELECT *
FROM customers
WHERE score <> 0;

/*
SQL TASK
Retrieve customers from Germany
*/
SELECT *
FROM customers
WHERE country = 'Germany';

SELECT firstname, country
FROM customers
WHERE country = 'Germany';


/*
SQL TASK
Retrieve all customers and sort the results by the highest score first
*/
SELECT *
FROM customers
ORDER BY score DESC;

/* SQL TASK
Retrieve all customers and sort the results by the lowest score first
*/
SELECT * 
FROM customers
ORDER BY score ASC;

/*
SQL TASK
Retrieve all customers and sort the results by the country and then by the highest score.
*/
SELECT *
FROM customers
ORDER BY country ASC, score DESC;

/*
SQL TASK
Find the total score for each country
*/
SELECT country,
       SUM(score) AS total_score
FROM customers
GROUP BY country;

SELECT firstname,
	   country,
       SUM(score) AS total_score
FROM customers
GROUP BY country, firstname;


/*
SQL TASK
Find the total score and total number of customers for each country.
*/
SELECT country,
       SUM(score) AS total_score,
       COUNT(customerid) AS num_customers
FROM customers
GROUP BY country;

/*
SQL TASK
Find the average score for each country considering only customers with a score not equal to 0 and return only those countries with an average score greater than 430.
*/
SELECT country,
       AVG(score) AS avg_score
FROM customers 
WHERE score != 0 
GROUP BY country
HAVING AVG(score) > 430;


/* 
SQL TASK 
Return a unique list of all countries. 
*/
SELECT DISTINCT country
FROM  customers;

/*
SQL TASK
Retrieve only 3 customers
*/
SELECT *
FROM customers 
LIMIT 3;


/*
SQL TASK
Retrieve the top 3 customers with the highest scores
*/
SELECT *
FROM customers
ORDER BY score DESC
LIMIT 3;

/*
SQL TASK
Retrieve the lowest 2 customers based on the score
*/
SELECT *
FROM customers
ORDER BY score ASC
LIMIT 2;

/*
SQL TASK
Get the two most recent orders
*/
SELECT *
FROM orders 
ORDER BY orderdate DESC
LIMIT 2;

























































