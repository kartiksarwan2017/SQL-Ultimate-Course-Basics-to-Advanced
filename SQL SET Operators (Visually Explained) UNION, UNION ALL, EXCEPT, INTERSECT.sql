USE salesdb;

/* RULE: NUMBER OF COLUMNS The number of columns in each query must be the same. */
SELECT firstname,
       lastname
FROM Sales.Customers
UNION
SELECT firstname,
       lastname
FROM Sales.Employees;



/* RULE: DATA TYPES: Data types of columns in each query must be compatible  */
/* Conversion failed when converting the varchar value 'Frank' to data type int. */

SELECT customerid,
       lastname
FROM Sales.Customers
UNION
SELECT firstname,
       lastname
FROM Sales.Employees;


SELECT customerid,
       lastname
FROM Sales.Customers
UNION
SELECT employeeid,
       lastname
FROM Sales.Employees;


/* RULE The order of columns in each query must be same */

/* Conversion failed when converting the varchar value 'Goldberg' to data type int. */
SELECT lastname,
       customerid
FROM Sales.Customers
UNION
SELECT employeeid,
       lastname
FROM Sales.Employees;

-- CORRECT QUERY
SELECT customerid,
       lastname
FROM Sales.Customers
UNION
SELECT employeeid,
       lastname
FROM Sales.Employees;

/* Rule COLUMN ALIASES
   The column names in the resutl set are determinded by the column names specififed in the first query
*/
SELECT customerid AS ID,
       lastname AS Last_Name
FROM Sales.Customers
UNION
SELECT employeeid,
       lastname 
FROM Sales.Employees;


/* RULE: CORRECT COLUMNS
   Even if all rules are met and SQL shows no errors, the result may be incorrect.
   Incorrect column selection leads to inaccurate results.
*/
SELECT firstname,
       lastname
FROM Sales.Customers
UNION
SELECT lastname,
       firstname
FROM Sales.Employees;

/************* SQL OPERATOR UNION **************/
/* SQL TASK
   Combine the data from employees and customers into one table.
*/
SELECT firstname,
       lastname
FROM Sales.Customers
UNION
SELECT firstname,
       lastname
FROM Sales.Employees;


/************* SQL OPERATOR - UNION ALL *****************/
/* SQL TASK
   Combine the data from employees and customers into one table, including duplicates.
*/
SELECT *
FROM Sales.Employees;

SELECT *
FROM Sales.Customers;

-- QUERY
SELECT firstname,
       lastname
FROM Sales.Employees 
UNION ALL 
SELECT firstname,
       lastname
FROM Sales.Customers;


/************** SET OPERATOR - EXCEPT ******************/
/*
SQL TASK
Find employees who are not customers at the same time.
*/
SELECT firstname,
       lastname
FROM Sales.Employees
EXCEPT
SELECT firstname,
       lastname
FROM Sales.Customers;


/*
SQL TASK
Find customers who are not employees at the same time.
*/
SELECT firstname,
       lastname
FROM Sales.Customers
EXCEPT 
SELECT firstname,
       lastname
FROM Sales.Employees;


/*************** SET OPERATOR - INTERSECT ****************/
/*
SQL TASK 
Find the employees, who are also customers.
*/
SELECT firstname,
       lastname
FROM Sales.Employees
INTERSECT
SELECT firstname,
       lastname
FROM Sales.Customers;


/*
SQL TASK
Orders are stored in seperate tables (Orders and OrdersArchive). Combine all orders into one report without duplicates.
*/
SELECT *
FROM Sales.Orders;

SELECT *
FROM Sales.OrdersArchive;


-- QUERY
SELECT * 
FROM Sales.Orders
UNION
SELECT *
FROM Sales.OrdersArchive;


/* BEST PRACTICES:
   Never use an asterisk to combine tables. List needed columns instead;
*/
SELECT 'Orders' AS SourceTable,
       OrderID,
       ProductID,
       CustomerID,
       SalesPersonID,
       OrderDate,
       ShipDate,
       OrderStatus,
       ShipAddress,
       BillAddress,
       Quantity,
       Sales,
       CreationTime
FROM Sales.Orders
UNION
SELECT 'OrdersArchive' AS SourceTable,
       OrderID,
       ProductID,
       CustomerID,
       SalesPersonID,
       OrderDate,
       ShipDate,
       OrderStatus,
       ShipAddress,
       BillAddress,
       Quantity,
       Sales,
       CreationTime
FROM Sales.OrdersArchive
ORDER BY OrderID;

























