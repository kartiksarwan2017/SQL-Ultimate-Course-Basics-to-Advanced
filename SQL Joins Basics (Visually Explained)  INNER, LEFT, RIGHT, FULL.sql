/*
SQL TASK
Retrieve all data from customers and orders as seperate results.
*/
SELECT *
FROM customers;

SELECT *
FROM orders;

/*
SQL TASK
Get all customers along with their orders, but only for customers who have placed an order
*/
SELECT c.customerid, 
       c.firstname, 
       c.lastname,
       o.orderid, 
       o.sales
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid;

/*
SQL TASK
Get all customers along with their orders, including those without orders.
*/
SELECT c.customerid,
       c.firstname,
       c.lastname,
       o.orderid,
       o.sales
FROM customers AS c
LEFT JOIN orders AS o 
ON c.customerid = o.customerid;

/*
SQL TASK
Get all customers along with their orders, including orders without matching customers.
*/
SELECT c.customerid,
       c.firstname,
       c.lastname,
       o.orderid,
       o.sales
FROM customers AS c 
RIGHT JOIN orders AS o 
ON c.customerid = o.customerid;

/* Solve the same task using LEFT JOIN */
/* Get all customers along with their orders, including orders without matching customers (USING LEFT JOIN) */
SELECT c.customerid,
       c.firstname,
	   c.lastname,
       o.orderid,
       o.sales
FROM orders AS o 
LEFT JOIN customers c 
ON o.customerid = c.customerid;


/*
SQL TASK
Get all customers and all orders, even if there's no match
*/
SELECT c.customerid,
       c.firstname,
       c.lastname,
       o.orderid,
       o.sales
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
UNION
SELECT c.customerid,
       c.firstname,
       c.lastname,
       o.orderid,
       o.sales
FROM customers AS c 
RIGHT JOIN orders AS o 
ON c.customerid = o.customerid;





















