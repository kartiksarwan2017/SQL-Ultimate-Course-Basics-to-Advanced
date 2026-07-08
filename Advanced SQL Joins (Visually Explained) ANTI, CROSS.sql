/*
SQL TASK
Get all customers who haven't placed any order.
*/
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;

/*
SQL TASK
Get all orders without matching customers.
*/
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE c.customerid IS NULL;

/*
SQL TASK
Get all orders without matching customers (Using LEFT JOIN)
*/
SELECT *
FROM orders AS o 
LEFT JOIN customers AS c 
ON c.customerid = o.customerid
WHERE c.customerid IS NULL;


/*
SQL TASK
Find customers without orders and orders without customers
*/
SELECT *
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE c.customerid IS NULL OR o.customerid IS NULL
UNION
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE c.customerid IS NULL OR o.customerid IS NULL;


/*
CHALLENGE
Get all customers along with their orders, but only for customers who have placed an order (Without Using INNER JOIN)
*/
SELECT *
FROM customers AS c 
LEFT JOIN orders AS o
ON c.customerid = o.customerid
WHERE o.customerid IS NOT NULL;

/*
SQL TASK
Generate al possible combinations of customers and orders
*/
SELECT *
FROM customers 
CROSS JOIN orders;
























