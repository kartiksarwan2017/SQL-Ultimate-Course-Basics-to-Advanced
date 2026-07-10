/********************************** Pattern 1 — INNER JOIN *************************
Clue Words
who placed
who ordered
who purchased
who handled
sold
bought
belongs to

Use: INNER JOIN
*/
/* 1. Display customers who placed at least one order.  */
SELECT c.firstname,
       c.lastname,
	   o.orderid
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid;


/* 2. Display employees who handled delivered orders.  */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.orderstatus = 'Delivered'
GROUP BY e.employeeid, e.firstname, e.lastname;

/*
Since you only want employee names, DISTINCT is simpler than GROUP BY.
*/
SELECT DISTINCT
       e.firstname,
       e.lastname
FROM employees e
JOIN orders o
ON e.employeeid = o.salespersonid
WHERE o.orderstatus='Delivered';

/* 3. Display products that were sold.  */
SELECT p.product
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product;

/* But a simpler interview solution is 
Reason

The question asks:
Products that were sold.

Not
Total sales.

You only need unique products.
Whenever you see
Display unique...
Show products that...
think DISTINCT before GROUP BY.


*/
SELECT DISTINCT p.product
FROM products p
INNER JOIN orders o
ON p.productid = o.productid;


/* 4. Show every order with customer name. */
SELECT c.firstname,
       c.lastname,
       o.orderid
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid;


/* 5. Show every order with salesperson name. */
SELECT e.firstname,
       e.lastname,
       o.orderid
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid;

/* 6. Display customers and products they purchased. */
SELECT c.firstname,
       c.lastname,
       p.product
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;



/* 7. Display orders with product category. */
SELECT o.orderid,
       p.category
FROM orders AS o 
INNER JOIN products AS p
ON o.productid = p.productid;


/* 8. Display employees with customers they served. */
SELECT e.firstname AS employee_firstname,
       e.lastname AS employee_lastname,
       c.firstname AS customer_firstname,
	   c.lastname AS customer_lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
INNER JOIN customers AS c 
ON c.customerid = o.customerid;


/* 9. Display products ordered by USA customers. */
SELECT p.product,
       c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
WHERE c.country = 'USA';


/* 10. Display customer, product and sales amount. */
SELECT c.firstname,
       c.lastname,
       p.product,
       o.sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;


/***************************** Pattern 2 — LEFT JOIN  ***********************************
Clue Words
all
including
even if
whether or not
if available

Use: LEFT JOIN

*/
/* 1. Display all customers including those without orders.  */
SELECT c.firstname,
       c.lastname,
       o.orderid
FROM customers AS c
LEFT JOIN orders AS o 
ON c.customerid = o.customerid;


/* 2. Display all employees including those without handled orders. */
SELECT e.firstname,
       e.lastname,
       o.orderid
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;


/* 3. Display all products including unsold products. */
SELECT p.product,
       o.orderid
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid;


/* 4. Show all customers with their orders if available. */
SELECT c.firstname,
       c.lastname,
       o.orderid
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid;


/* 5. Display all employees with sales if available. */
SELECT e.firstname,
       e.lastname,
       o.sales
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;


/* 6. Show all products with quantity sold if any. */
SELECT p.product,
       o.quantity
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid;

/*
It works.

But suppose Bottle was ordered five times.

You'll get

Bottle 1

Bottle 2

Bottle 3

Bottle 2

Bottle 5

Usually interviewers mean

Total quantity sold

*/
SELECT p.product,
       SUM(o.quantity) AS total_quantity
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product;

/* 7. Display all customers with latest order if available. */
SELECT c.firstname,
       c.lastname,
	   o.orderdate
FROM customers AS c
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
ORDER BY o.orderdate DESC;

/*
Question
latest order

Your query
ORDER BY o.orderdate DESC;

doesn't find the latest order for each customer.

It sorts the whole result.
*/
SELECT c.firstname,
	   c.lastname,
       MAX(o.orderdate) AS latest_order
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;




/* 8. Show all departments with employee orders if available. */
SELECT e.department,
       o.orderid
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;

/* 9. Display all products with revenue if sold. */
SELECT p.product,
       o.sales
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid;

/*
Question

revenue if sold

Your query

o.sales

shows one row per order.

Usually revenue means
SUM(sales)
*/

SELECT p.product,
	   SUM(o.sales) AS revenue
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product;



/* 10. Show all customers with salesperson if they have ordered.  */
SELECT c.firstname AS customer_first_name,
       c.lastname AS customer_lastname,
       e.firstname AS salesperson_firstname,
       e.lastname AS salesperson_lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
LEFT JOIN employees AS e 
ON e.employeeid = o.salespersonid;

/******************** Pattern 3 — LEFT ANTI JOIN **********************
Clue Words
never
no
without
haven't
did not

Use
LEFT JOIN ...
WHERE right_table.id IS NULL
*/
/* 1. Customers who never ordered.  */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;


/* 2. Employees who never handled any order. */
SELECT DISTINCT e.firstname, e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.salespersonid = NULL;

/*
Your query

WHERE o.salespersonid = NULL;
Mistake

Never compare with NULL using =.

Use
IS NULL
*/
SELECT DISTINCT e.firstname, e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.salespersonid IS NULL;


/* 3. Products never sold. */
SELECT DISTINCT p.product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
WHERE o.productid IS NULL;

/* 4. Customers without delivered orders. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
AND o.orderstatus = 'Delivered'
WHERE o.customerid IS NULL;


/* 5. Products never purchased by USA customers. */
SELECT product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
LEFT JOIN customers AS c 
ON o.customerid = c.customerid
AND c.country <> 'USA'
WHERE c.customerid IS NULL AND o.productid IS NULL;


/*
Question

Products never purchased by USA customers

Your query

LEFT JOIN customers
ON ...
AND c.country <> 'USA'

This reverses the logic.
Instead filter USA inside the JOIN, not non-USA.
*/
SELECT p.product
FROM products p
LEFT JOIN orders o
ON p.productid=o.productid
LEFT JOIN customers c
ON o.customerid=c.customerid
AND c.country='USA'
WHERE c.customerid IS NULL;



/* 6. Employees without German customers. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
LEFT JOIN customers AS c 
ON c.customerid = o.customerid
AND c.country <> 'Germany'
WHERE o.salespersonid IS NULL AND o.customerid IS NULL;

/* You used

country <> Germany
which changes the meaning completely. */

-- CORRECT QUERY
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
LEFT JOIN customers AS c 
ON c.customerid = o.customerid
AND c.country = 'Germany'
WHERE o.salespersonid IS NULL AND o.customerid IS NULL;


/* 7. Customers who never bought Clothing. */
SELECT c.firstname,
	   c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
LEFT JOIN products AS p 
ON p.productid = o.productid
AND p.category = 'Clothing'
WHERE o.customerid IS NULL AND o.productid IS NULL;

/*
LEFT JOIN products
AND p.category='Clothing'

WHERE o.customerid IS NULL

The problem is you're checking whether no order exists, instead of no Clothing purchase exists.

Notice

We check
p.productid IS NULL

not
o.customerid IS NULL
*/
SELECT c.firstname,
       c.lastname
FROM customers c
LEFT JOIN orders o
ON c.customerid=o.customerid
LEFT JOIN products p
ON o.productid=p.productid
AND p.category='Clothing'
WHERE p.productid IS NULL;



/* 8. Products never ordered in January. */
SELECT p.product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
AND MONTH(o.orderdate) != '01'
WHERE o.productid IS NULL;

/*
Think carefully.

That means

Join every order except January.
Exactly opposite.

Notice

We JOIN January.
Then ask
Where January doesn't exist.
*/
SELECT p.product
FROM products p
LEFT JOIN orders o
ON p.productid=o.productid
AND MONTH(o.orderdate)=1
WHERE o.productid IS NULL;



/* 9. Employees without shipped orders. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
AND o.orderstatus <> 'Shipped'
WHERE o.salespersonid IS NULL;


-- CORRECT QUERY
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
AND o.orderstatus = 'Shipped'
WHERE o.salespersonid IS NULL;


/* 10. Customers who never purchased Accessories. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
LEFT JOIN products AS p 
ON p.productid = o.productid
AND p.category <> 'Accessories'
WHERE o.customerid IS NULL AND o.productid IS NULL;

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname
FROM customers c
LEFT JOIN orders o
ON c.customerid=o.customerid
LEFT JOIN products p
ON o.productid=p.productid
AND p.category='Accessories'
WHERE p.productid IS NULL;





























