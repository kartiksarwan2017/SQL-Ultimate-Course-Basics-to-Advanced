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


/********************** Multiple Table JOIN (3+ Tables) *******************

Clue Words
Need information from multiple entities.
*/
/* 1. Show customer name, product name and salesperson. */
SELECT c.firstname AS cust_firstname,
       c.lastname AS cust_lastname,
       p.product AS product_name,
       e.firstname AS salesperson_firstname,
       e.lastname AS salesperson_lastname
FROM orders AS o
INNER JOIN customers AS c 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid;


/* 2. Display customer, department and product. */
SELECT c.firstname,
       c.lastname,
       e.department,
       p.product
FROM orders AS o 
INNER JOIN customers AS c 
ON c.customerid = o.customerid
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
INNER JOIN products AS p 
ON p.productid = o.productid;


/* 3. Show order, customer, employee and product. */
SELECT o.orderid,
       c.firstname AS customer_firstname,
       c.lastname AS customer_lastname,
       e.firstname AS employee_firstname,
       e.lastname AS employee_lastname,
       p.product AS product_name
FROM orders AS o 
INNER JOIN customers AS c 
ON o.customerid = c.customerid
INNER JOIN employees AS e 
ON o.salespersonid = e.employeeid
INNER JOIN products AS p 
ON o.productid = p.productid;


/* 4. Display customer country, product category and sales. */
SELECT c.firstname,
       c.lastname,
       c.country,
       p.category,
       o.sales
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;


/* 5. Show employee, customer, product and quantity. */
SELECT e.firstname AS employee_firstname,
       e.lastname AS employee_lastname,
       c.firstname AS customer_firstname,
       c.lastname AS customer_lastname,
       p.product AS product_name,
       o.quantity AS quantity
FROM orders AS o 
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
INNER JOIN customers AS c
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;


/* 6. Display customer score, product price and sales. */
SELECT c.score,
       p.price,
       o.sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;



/* 7. Show department, product category and revenue. */
SELECT e.department,
       p.category,
       SUM(o.sales) AS revenue
FROM orders AS o 
INNER JOIN employees AS e
ON o.salespersonid = e.employeeid
INNER JOIN products AS p 
ON p.productid = o.productid
GROUP BY e.department, p.category;



/* 8. Display customer, product and order status. */
SELECT c.firstname,
       c.lastname,
	   p.product,
       o.orderstatus
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid 
INNER JOIN products AS p 
ON p.productid = o.productid;



/* 9. Show customer, employee and ship date. */
SELECT c.firstname AS customer_firstname,
       c.lastname AS customer_lastname,
       e.firstname AS employee_firstname,
       e.lastname AS employee_lastname,
       o.shipdate
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN employees AS e
ON e.employeeid = o.salespersonid;
	   


/* 10. Display complete sales report with customer, employee, product and sales */
SELECT c.firstname,
       c.lastname,
       e.firstname,
       e.lastname,
       p.product,
       o.sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
INNER JOIN products AS p 
ON p.productid = o.productid;


/*
Small Suggestions

Instead of

SELECT c.firstname,
       c.lastname,
       e.firstname,
       e.lastname

prefer

SELECT
c.firstname AS customer_firstname,
c.lastname AS customer_lastname,
e.firstname AS employee_firstname,
e.lastname AS employee_lastname

because duplicate column names become confusing.

*/
SELECT  c.firstname AS customer_firstname,
		c.lastname AS customer_lastname,
		e.firstname AS employee_firstname,
		e.lastname AS employee_lastname,
        p.product,
        o.sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
INNER JOIN products AS p 
ON p.productid = o.productid;

/**************************** Pattern 10 — JOIN + GROUP BY ****************************
Clue Words
each
per
every
total
*/
/* 1. Total sales per customer.  */
SELECT c.firstname,
       c.lastname,
       SUM(o.sales) AS total_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;


/* 2. Total revenue per employee. */
SELECT e.firstname,
       e.lastname,
       SUM(o.sales) AS total_revenue
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;


/* 3. Orders handled by each salesperson. */
SELECT e.firstname,
       e.lastname,
	   COUNT(o.orderid) AS num_orders
FROM employees AS e
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;



/* 4. Quantity sold per product. */
SELECT p.product,
       SUM(o.quantity) AS total_quantity
FROM products AS p 
INNER JOIN orders AS o
ON p.productid = o.productid
GROUP BY p.productid, p.product;



/* 5. Revenue per category. */
SELECT p.category,
       SUM(o.sales) AS revenue
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.category;


/* 6. Customers served per employee. */
SELECT e.firstname,
       e.lastname,
       COUNT(c.customerid) AS num_customers
FROM orders AS o
INNER JOIN employees AS e
ON e.employeeid = o.salespersonid
INNER JOIN customers AS c 
ON c.customerid = o.customerid
GROUP BY e.employeeid, e.firstname, e.lastname;

/*
Your query
COUNT(c.customerid)

This works if the requirement means:
Number of customer-orders handled.
However, if the interviewer asks:
Customers served per employee
they usually mean unique customers.

Example:
Employee A serves
Customer 1
Customer 1
Customer 1
Customer 2

Your answer returns
4

The interviewer probably expects
2
*/

-- CORRECT QUERY 
SELECT e.firstname,
       e.lastname,
       COUNT(DISTINCT c.customerid) AS unique_customers
FROM orders o
JOIN employees e
ON e.employeeid = o.salespersonid
JOIN customers c
ON c.customerid = o.customerid
GROUP BY e.employeeid, e.firstname, e.lastname;


/* 7. Products sold per customer. */
SELECT c.firstname, 
       c.lastname,
	   COUNT(p.productid) AS num_products
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
INNER JOIN customers AS c
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;

/*
Your query

COUNT(p.productid)
Again,
depends on wording.

If question means
total products ordered
it's okay.

If interviewer means
different products purchased

then use
COUNT(DISTINCT p.productid)

Always ask yourself:
Do they mean total or unique?
*/



/* 8. Total sales per country. */
SELECT c.country,
       SUM(o.sales) AS total_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.country;



/* 9. Revenue per department. */
SELECT e.department,
       SUM(o.sales) AS revenue
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.department;



/* 10. Total quantity per category. */
SELECT p.category,
       SUM(o.quantity) AS total_quantity
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.category;


/***************** Pattern — JOIN + HAVING *****************
Clue Words
more than
greater than
average greater than
total greater than
*/
/* 1. Customers with more than five orders. */
SELECT c.firstname,
	   c.lastname,
       COUNT(o.orderid) AS num_orders
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(o.orderid) > 5;



/* 2. Employees handling more than ten orders. */
SELECT e.firstname,
       e.lastname,
       COUNT(o.orderid) AS num_orders
FROM employees AS e
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(o.orderid) > 10;


/* 3. Products with revenue above 1000. */
SELECT p.product,
       SUM(o.sales) AS revenue
FROM products AS p
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING SUM(o.sales) > 1000;

/*
otice how your thinking has improved:

Revenue

↓

Sales comes from orders

↓

Need products

↓

JOIN

↓

SUM

↓

HAVING

This is exactly the reasoning interviewers expect.
*/


/* 4. Categories with average price above 20. */
SELECT category,
       AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 20;



/* 5. Countries with more than three customers. */
SELECT country,
       COUNT(*) AS num_customers
FROM customers
GROUP BY country
HAVING COUNT(*) > 3;

/* No JOIN required because all information comes from one table. */


/* 6. Employees with average sales above 50. */
SELECT e.firstname,
       e.lastname,
       AVG(o.sales) AS avg_sales
FROM employees AS e
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING AVG(o.sales) > 50;



/* 7. Products sold more than ten times. */
SELECT p.product,
       COUNT(o.orderid) AS num_orders
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING COUNT(o.orderid) > 10;

/*
Your query:

COUNT(o.orderid)

This is correct if the interviewer means:

Product appeared in more than 10 orders.

Sometimes interviewers mean:

Total quantity sold.

Then it becomes

HAVING SUM(o.quantity) > 10;

Always ask yourself:

"Sold" means number of orders or quantity?
*/
-- CORRECT QUERY
SELECT p.product,
       SUM(o.quantity) AS num_orders
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING SUM(o.quantity) > 10;


/* 8. Customers spending above 200. */
SELECT e.firstname,
       e.lastname,
       SUM(o.sales) AS total_sales
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING SUM(o.sales) > 200;

/*
This one is incorrect.

The question says:
Customers spending above 200

But your query starts from


employees
You grouped by employees instead of customers.

Why this happened

This isn't a SQL mistake.

It is a requirement interpretation mistake.

Read the first noun carefully.

Customers spending

↓

customers table

↓

orders table

↓

SUM

↓

GROUP BY customer

*/

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname,
       SUM(o.sales) AS total_sales
FROM customers AS c
INNER JOIN orders AS o
ON c.customerid = o.customerid
GROUP BY c.customerid,
         c.firstname,
         c.lastname
HAVING SUM(o.sales) > 200;


/* 9. Departments with total salary above 200000. */
SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 200000;



/* 10. Products with average sales above company average. */
SELECT p.product,
       AVG(o.sales) AS avg_sales
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING AVG(o.sales) > (
	   SELECT AVG(sales)
       FROM orders
);


/************************   JOIN + "Both" Conditions   ******************************

Clue Words
both
all
every

Usually solved using:

GROUP BY
HAVING COUNT(DISTINCT ...)

*/

/* 1. Customers who bought both Clothing and Accessories. */
SELECT c.firstname,
       c.lastname
FROM orders  AS o 
INNER JOIN customers AS c 
ON o.customerid = c.customerid
INNER JOIN products AS p 
ON o.productid = p.productid
WHERE p.category IN ('Clothing', 'Accessories') 
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) = 2;


/* 2. Employees who handled both Delivered and Shipped orders. */
SELECT e.firstname,
	   e.lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.orderstatus IN ('Delivered', 'Shipped')
GROUP BY e.firstname, e.lastname
HAVING COUNT(DISTINCT o.orderstatus) = 2;


/* 3. Customers ordering from all categories. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p
ON p.productid = o.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) = (
       SELECT COUNT(category)
       FROM products
);


/*
Your subquery

SELECT COUNT(category)
FROM products

Problem:

If products table contains

Accessories
Accessories
Accessories
Clothing
Clothing

COUNT(category)

returns
5

But there are only
2 categories

Correct

HAVING COUNT(DISTINCT p.category)=
(
SELECT COUNT(DISTINCT category)
FROM products
);

Notice the second DISTINCT.

*/
-- CORRECT QUERY
SELECT c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p
ON p.productid = o.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) = (
       SELECT COUNT(DISTINCT category)
       FROM products
);


/* 4. Products sold in both January and February. */
SELECT p.product
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
WHERE MONTH(o.orderdate) IN ('01', '02')
GROUP BY p.productid, p.product
HAVING COUNT(DISTINCT o.orderdate) = 2;


/*
You wrote

HAVING COUNT(DISTINCT o.orderdate)=2

Question asks

January and February

Not

Two different dates.

Imagine

Jan 1
Jan 15

Two dates

But

No February.

Your query would incorrectly return that product.

Correct

WHERE MONTH(o.orderdate) IN (1,2)

GROUP BY p.productid,p.product

HAVING COUNT(DISTINCT MONTH(o.orderdate))=2;

This is a classic interview trick.
*/
SELECT p.product
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
WHERE MONTH(o.orderdate) IN ('01', '02')
GROUP BY p.productid, p.product
HAVING COUNT(DISTINCT MONTH(o.orderdate)) = 2;



/* 5. Customers who bought both Bottle and Caps. */
SELECT c.firstname,
       c.lastname
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
WHERE p.product IN ('Bottle', 'Caps')
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.product) = 2;


/* 6. Employees who sold both Accessories and Clothing. */
SELECT e.firstname,
       e.lastname
FROM employees AS e
INNER JOIN orders AS o 
ON o.salespersonid = e.employeeid
INNER JOIN products AS p 
ON p.productid = o.productid
WHERE p.category IN ('Accessories', 'Clothing')
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(DISTINCT p.category) = 2;


/* 7. Customers who placed both Delivered and Pending orders. */
SELECT c.firstname,
       c.lastname
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
WHERE o.orderstatus IN ('Delivered', 'Pending')
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT o.orderstatus) = 2;


/* 8. Products purchased by both USA and Germany customers. */
SELECT p.product
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
INNER JOIN customers AS c 
ON c.customerid = o.customerid
WHERE c.country IN ('USA', 'Germany')
GROUP BY p.productid, p.product
HAVING COUNT(DISTINCT c.country) = 2;


/* 9. Employees serving both USA and Germany customers. */
SELECT e.firstname,
       e.lastname
FROM employees AS e
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
INNER JOIN customers AS c 
ON c.customerid  = o.customerid
WHERE c.country IN ('USA', 'Germany')
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(DISTINCT c.country) = 2;


/* 10. Customers ordering from more than one category. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products p
ON p.productid = o.productid
GROUP BY c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) > 1;


/***************** PATTERN - CROSS JOIN  *****************

Clue Words
every combination
all combinations
each with every
possible combinations

Use
CROSS JOIN

*/
/* 1. Show every customer with every product. */
SELECT c.firstname,
       c.lastname,
       p.product
FROM customers AS c 
CROSS JOIN orders AS o
CROSS JOIN products AS p;


/*
The Main Mistake

Almost every query looks like this:

FROM customers c
CROSS JOIN orders o
CROSS JOIN products p

Ask yourself:

Does the question ask anything about orders?

For Q1:

Show every customer with every product.

We only need

customers
products

There is no need for orders.

Adding orders creates duplicate rows because every customer-product pair is repeated once for every order.

*/

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname,
       p.product
FROM customers c
CROSS JOIN products p;

/* 2. Show every employee with every customer. */
SELECT e.firstname AS emp_firstname,
       e.lastname AS emp_lastname,
       c.firstname AS cust_firstname,
       c.lastname AS cust_lastname
FROM employees AS e 
CROSS JOIN customers AS c;



/* 3. Show every department with every category. */
SELECT e.department,
       p.category
FROM employees AS e 
CROSS JOIN orders AS o
CROSS JOIN products AS p;

/*
You wrote

employees
CROSS JOIN orders
CROSS JOIN products

Correct

SELECT DISTINCT
       e.department,
       p.category
FROM employees e
CROSS JOIN products p;

Notice another improvement.

Departments repeat.

Marketing
Marketing
Sales
Sales

Categories repeat.

Accessories
Accessories
Clothing

Use

DISTINCT
*/
-- CORRECT QUERY
SELECT DISTINCT
       e.department,
       p.category
FROM employees e
CROSS JOIN products p;



/* 4. Display every employee with every product. */
SELECT e.firstname,
       e.lastname,
       p.product
FROM employees AS e
CROSS JOIN products AS p;



/* 5. Show every customer with every salesperson. */
SELECT c.firstname AS customer_firstname,
	   c.lastname AS customer_lastname,
       e.firstname AS salesperson_firstname,
       e.lastname AS salesperson_lastname
FROM customers AS c
CROSS JOIN employees AS e;


/* 6. Show every country with every category. */
SELECT c.country,
	   p.category
FROM customers AS c
CROSS JOIN products AS p;


/*
Again,
DISTINCT
because countries repeat.
*/


-- CORRECT QUERY
SELECT DISTINCT
       c.country,
       p.category
FROM customers c
CROSS JOIN products p;


/* 7. Display every employee-product pair. */
SELECT e.firstname,
       e.lastname,
       p.product
FROM employees AS e
CROSS JOIN products AS p;



/* 8. Generate all customer-product combinations. */
SELECT c.firstname,
       c.lastname,
       p.product
FROM customers AS c
CROSS JOIN products p;


/* 9. Show every product with every department. */
SELECT p.product,
       e.department
FROM products AS p 
CROSS JOIN employees AS e;

-- CORRECT QUERY
SELECT DISTINCT
       p.product,
       e.department
FROM products p
CROSS JOIN employees e;


/* 10. Display every customer with every order status. */
SELECT c.firstname,
	   c.lastname,
       o.orderstatus
FROM customers AS c
CROSS JOIN orders AS o;


/*
This one is actually good.

Why?

Because

Order status comes from

orders

There is no separate status table.

So

customers
CROSS JOIN orders

works.

If you wanted unique statuses, then:

SELECT c.firstname,
       c.lastname,
       s.orderstatus
FROM customers c
CROSS JOIN
(
    SELECT DISTINCT orderstatus
    FROM orders
) s;

This avoids repeating "Delivered" multiple times.
*/

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname,
       s.orderstatus
FROM customers c
CROSS JOIN
(
    SELECT DISTINCT orderstatus
    FROM orders
) s;

































































