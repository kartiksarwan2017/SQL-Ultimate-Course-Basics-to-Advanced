/*********************** SQL String Functions **********************/

USE SalesDB;

/* CONCAT */
/* SQL TASK
   Concatenate first name and country into one column
*/
SELECT CONCAT(firstname, ' ', country) AS firstname_country
FROM Sales.Customers;


/* UPPER & LOWER Functions */
/* SQL TASK
   Convert the first name to lowercase
*/
SELECT LOWER(firstname) AS low_firstname
FROM Sales.Customers;

/*
SQL TASK
Convert the first name to uppercase
*/
SELECT UPPER(firstname) AS upper_firstname
FROM Sales.Customers;


/* TRIM() */
/* SQL TASK
   Find customers whose first name contains leading or trailing spaces
*/

SELECT firstname
FROM Sales.Customers
WHERE firstname != TRIM(firstname);


SELECT firstname,
       LEN(firstname) AS len_name,
       LEN(TRIM(firstname)) AS len_trim_name,
       LEN(firstname) - LEN(TRIM(firstname)) AS flag
FROM Sales.Customers;


SELECT firstname,
       LEN(firstname) AS len_name,
       LEN(TRIM(firstname)) AS len_trim_name,
       LEN(firstname) - LEN(TRIM(firstname)) AS flag
FROM Sales.Customers
WHERE LEN(firstname) != LEN(TRIM(firstname));


/* REPLACE FUNCTION  */
/* SQL TASK
   Remove dashes (-) from a phone number.
*/
SELECT '123-456-7890' AS phone, 
       REPLACE('123-456-7890', '-', '/') AS clean_phone;


/*
Replace file Extence from txt to csv
*/
SELECT 'report.txt' AS old_filename,
       REPLACE('report.txt', '.txt', '.csv') AS new_filename;


/* LEN Function */
/* SQL TASK
   Calculate the length of each customer's first name
*/
SELECT LEN(firstname) AS len_firstname
FROM Sales.Customers;


/* LEFT & RIGHT Function */
/*
SQL TASK
Retrieve the first two characters of each first name
*/
SELECT firstname,
       LEFT(TRIM(firstname), 2) AS first_two_chars
FROM Sales.Customers;


/*  
SQL TASK
Retrieve the last two characters of each first name
*/
SELECT lastname,
       RIGHT(TRIM(lastname), 2) AS last_two_chars
FROM Sales.Customers;


/* Substring Function */
/*
SQL TASK
Retrieve a list of customers first name removing the first character.
*/
SELECT  firstname,
        SUBSTRING(TRIM(firstname), 2, LEN(firstname)) AS sub_customer_name
FROM Sales.Customers;

















