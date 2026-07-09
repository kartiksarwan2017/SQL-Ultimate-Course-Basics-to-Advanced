/***************** Pattern 1 – Simple Filtering (WHERE) ***********************/
/*
Clue words
who
where
greater than
less than
before
after
starts with
ends with
contains

Use: WHERE

*/

/*
1. Display employees earning more than 70,000.
*/
SELECT *
FROM employees
WHERE salary > 70000;

/*
2. Find customers from Germany.
*/
SELECT *
FROM customers
WHERE country = 'Germany';

/*
3. Display products costing between 20 and 50.
*/
SELECT *
FROM products
WHERE price >= 20 AND price <= 50;

SELECT * 
FROM products
WHERE price BETWEEN 20 AND 50;

/*
4. Show orders placed after '2025-01-15'.
*/
SELECT *
FROM orders
WHERE orderdate > '2025-01-15';

/*
5. Find employees whose first name starts with 'M'.
*/
SELECT *
FROM employees
WHERE firstname LIKE 'M%';

/*
6.  Display customers whose last name ends with 'son'.
*/
SELECT *
FROM customers
WHERE lastname LIKE '%son';


/*
7. Find orders with quantity equal to 0.
*/
SELECT *
FROM orders
WHERE quantity = 0;


/*
8. Show products whose category is Clothing.
*/
SELECT *
FROM products
WHERE category = 'Clothing';

/*
9.  Display employees born before 1990.
*/
SELECT *
FROM employees
WHERE birthdate < '1990-01-01';

/*
10. Find customers with score greater than 700.
*/
SELECT *
FROM customers 
WHERE score > 700;

/*********************** Pattern 2 – Sorting ***************************/
/*
Clue words
highest
lowest
latest
earliest
top
alphabetical

Use: ORDER BY
*/

/* Display products from highest to lowest price. */
SELECT *
FROM products
ORDER BY price DESC;

/* Show customers alphabetically. */
SELECT *
FROM customers
ORDER BY firstname ASC, lastname ASC;


/* Find the latest orders. */
SELECT *
FROM orders
ORDER BY orderdate DESC;


/* Display employees by salary descending. */
SELECT *
FROM employees
ORDER BY salary DESC;


/* Show products sorted by category then price. */
SELECT *
FROM products
ORDER BY category ASC, price ASC;


/* Display customers by score descending. */
SELECT *
FROM customers
ORDER BY score DESC;


/* Find top 5 expensive products. */
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;


/* Display earliest orders first. */
SELECT *
FROM orders
ORDER BY orderdate ASC;


/* Sort employees by birthdate. */
SELECT *
FROM employees
ORDER BY birthdate ASC;


/* Display orders by sales descending. */
SELECT *
FROM orders
ORDER BY sales DESC;


/*************** Pattern 3 – Aggregate Functions ********************/
/*
Clue words
total
average
maximum
minimum
count

Use: COUNT, SUM, AVG, MAX, MIN

*/

/*
Find total sales.
*/
SELECT SUM(sales) AS total_sales
FROM orders;

/*
Count customers.
*/
SELECT COUNT(*) AS num_customers
FROM customers;

/*
Find average salary.
*/
SELECT AVG(salary) AS avg_salary
FROM employees;


/*
Find highest product price.
*/
SELECT MAX(price) AS max_price
FROM products;

/*
Find minimum customer score.
*/
SELECT MIN(score) AS min_score
FROM customers;


/*
Count delivered orders.
*/
SELECT COUNT(*) AS num_orders
FROM orders
WHERE orderstatus = 'Delivered';

/*
Find total quantity sold.
*/
SELECT SUM(quantity) AS total_quantity
FROM orders;

/*
Find average sales.
*/
SELECT AVG(sales) AS avg_sales
FROM orders;


/*
Find maximum order quantity.
*/
SELECT MAX(quantity) AS max_order_quantity
FROM orders;

/*
Count products
*/
SELECT COUNT(*) AS num_products
FROM products;


/******************** Pattern 4 – GROUP BY *********************/
/*

Clue words
each
per
every
for each

Use: GROUP BY
*/
/*
Find total sales for each customer.
*/
SELECT c.firstname,
       c.lastname,
	   SUM(o.sales)
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;



/*
Count employees in each department.
*/
SELECT department,
       COUNT(*) AS num_employees
FROM employees
GROUP BY department;


/*
Find average salary per department.
*/
SELECT AVG(salary) AS avg_salary, department
FROM employees
GROUP BY department;


/*
Count products in each category.
*/
SELECT category,
	   COUNT(*) AS num_products
FROM products
GROUP BY category;


/*
Find total quantity per product.
*/
SELECT p.product,
       SUM(o.quantity) AS total_quantity
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product;



/*
Count customers per country.
*/
SELECT country,
       COUNT(*) AS num_customers
FROM customers
GROUP BY country;


/*
Find highest sale for each employee.
*/
SELECT e.firstname,
       e.lastname,
       MAX(o.sales) AS highest_sales
FROM employees e 
INNER JOIN orders o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;


/*
Find minimum sale per customer.
*/
SELECT c.firstname,
       c.lastname,
       MIN(o.sales) AS min_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;


/*
Find total revenue for each category.
*/
SELECT p.category,
       SUM(o.sales) AS total_revenue
FROM products AS p
INNER JOIN orders AS o
ON p.productid = o.productid
GROUP BY p.category;



/*
Count orders handled by each salesperson.
*/
SELECT e.firstname,
       e.lastname,
       COUNT(*) AS num_orders
FROM employees AS e
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;

/*****************************  Pattern 5 – HAVING  **************************************/
/*
Clue words
more than
less than
average greater than
total greater than

(after grouping)

Use: HAVING
*/

/*
1. Customers with more than 3 orders.
*/
SELECT c.firstname,
	   c.lastname,
	   COUNT(o.orderid) AS num_orders
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(o.orderid) > 3;

/*
2. Departments with average salary above 60,000.
*/
SELECT department,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

/*
3. Products whose total sales exceed 200.
*/
SELECT p.product,
       SUM(o.sales) AS total_sales
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING SUM(o.sales) > 200;


/*
4. Countries with more than 5 customers.
*/
SELECT country,
       COUNT(*) AS num_customers
FROM customers
GROUP BY country
HAVING COUNT(*) > 5;


/*
5. Categories with average price above 30.
*/
SELECT category,
       AVG(price) AS avg_price
FROM products 
GROUP BY category
HAVING AVG(price) > 30;

/*
6. Employees handling more than 10 orders.
*/
SELECT e.firstname, 
       e.lastname,
	   COUNT(o.orderid) AS num_orders
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(o.orderid) > 10;

/*
7. Customers with total quantity above 20.
*/
SELECT c.firstname,
       c.lastname,
       SUM(o.quantity) AS total_quantity
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING SUM(o.quantity) > 20;

/*
8. Products sold more than five times.

This depends on the wording.
If the interviewer says
sold more than five times

Then
COUNT(orderid)
is correct.

If they say
sold more than five units
Then

SUM(quantity)
is correct.
This distinction is asked surprisingly often.
*/
SELECT p.product,
       COUNT(o.orderid) AS num_orders
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product
HAVING COUNT(o.orderid) > 5;

/*
9. Departments whose total salary exceeds 200000.
*/
SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 200000;

/*
10. Customers whose average sale exceeds 40.
*/
SELECT c.firstname,
       c.lastname,
       AVG(o.sales) AS avg_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING AVG(o.sales) > 40;


/********************** Pattern 6 – INNER JOIN  ***************************/
/*
Clue words
who placed
who purchased
handled
ordered
sold

Use: INNER JOIN

*/
/* 1.  Display customers who placed orders.  */
SELECT c.firstname,
       c.lastname,
       o.orderid
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid;



/* 2.  Display employees who handled orders. */
SELECT e.firstname,
       e.lastname,
       o.orderid
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid;


/* 3. Show products that were ordered.  */
SELECT p.product,
       o.orderid
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid;


/* 4. Display customer names and product names. */
SELECT c.firstname,
       c.lastname,
       p.product
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid;


/* 5.  Show orders with salesperson names.  */
SELECT o.orderid, 
       e.firstname,
	   e.lastname
FROM orders AS o 
INNER JOIN employees AS e 
ON o.salespersonid = e.employeeid;


/* 6.  Display customer and order date. */
SELECT c.firstname,
       c.lastname,
       o.orderdate
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid;


/* 7.  Display product and quantity ordered.  */
SELECT p.product,
       o.quantity
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid;


/* 8.  Display customer and sales amount.  */
SELECT c.firstname,
       c.lastname,
       o.sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid;


/* 9. Show employee and department with orders. */
SELECT e.firstname,
       e.lastname,
       e.department,
       o.orderid
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid;


/* 10. Display product with customer name.  */
SELECT p.product,
       c.firstname,
       c.lastname
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
INNER JOIN customers AS c 
ON c.customerid = o.customerid;


/**************************  Pattern 7 – LEFT JOIN  ***********************************/
/*
Clue words
all
including
even if
whether or not

Use: LEFT JOIN
*/
/*
1. Display all customers including those without orders.
*/
SELECT c.firstname,
       c.lastname,
       o.orderid
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid;



/*
2. Display all employees including those without orders.
*/
SELECT e.firstname,
       e.lastname,
       o.orderid
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;

/*
3. Show all products including unsold products.
*/
SELECT p.product,
       o.orderid
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid;

/*
4. Display all departments including empty ones.
*/
SELECT e.department,
       o.orderid
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;

/*
You wrote
FROM employees
LEFT JOIN orders

The problem is that departments are values, not a separate table.
Since there is no departments table, you cannot display an "empty department."
With your current schema, the best possible answer is
*/
-- CORRECT ANSWER
SELECT e.department,
       COUNT(o.orderid) AS num_orders
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY department;

/*
5. Display all customers with their latest order if any.
*/
SELECT c.firstname,
       c.lastname,
       o.orderid,
       o.orderdate
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
ORDER BY o.orderdate DESC;

/*
FEEDBACK
Your query
ORDER BY orderdate DESC
does not return the latest order for each customer.
It returns all orders sorted.

This question actually requires concepts like:

Window Functions (ROW_NUMBER)
Correlated Subquery
MAX(orderdate)

which you haven't learned yet.
*/

/*
6. Show all products with total sales if available.
*/
SELECT p.product,
       SUM(o.sales) AS total_sales
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.productid, p.product;


/*
7. Display all salespersons and handled orders.
*/
SELECT e.firstname,
       e.lastname,
       o.orderid
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;


/*
8. Show all customers with total revenue if any.
*/
SELECT c.firstname,
       c.lastname,
       SUM(o.sales) AS total_revenue
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;

/*
9. Display all employees with sales handled.
*/
SELECT e.firstname,
       e.lastname,
       o.sales
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid;

/*
10. Show all products and order quantities.
*/
SELECT p.product,
       o.quantity
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid;

/*************************  Pattern 8 – Anti Join   *****************************/
/*
Clue words
never
without
no
did not
haven't

Use: LEFT JOIN ... IS NULL (or NOT EXISTS later)
*/
/* 1. Customers who never ordered.  */
SELECT c.firstname,
	   c.lastname
FROM customers AS c 
LEFT JOIN orders AS o
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;


/* 2. Products never sold. */
SELECT p.product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
WHERE o.productid IS NULL;


/* 3. Employees who never handled orders. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid 
WHERE o.salespersonid IS NULL;



/* 4. Customers without delivered orders. */
SELECT c.firstname,
	   c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;

/*
You wrote

WHERE o.customerid IS NULL;
That only finds customers with no orders at all.

The question is
without delivered orders
*/

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid 
AND o.orderstatus = 'Delivered'
WHERE o.orderid IS NULL;

/* Notice something important.
The filter
orderstatus='Delivered'
belongs in the JOIN, not in the WHERE.
This is a classic interview question. */

/* 5. Products never purchased. */
SELECT p.product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
WHERE o.productid IS NULL;



/* 6. Employees without customers. */
SELECT e.firstname,
	   e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.customerid
LEFT JOIN customers AS c 
ON o.customerid = c.customerid
WHERE c.customerid IS NULL;

/* You wrote

ON e.employeeid = o.customerid

Employee ID and Customer ID are unrelated. */

-- CORRECT QUERY
SELECT e.firstname,
       e.lastname
FROM employees e
LEFT JOIN orders o
ON e.employeeid = o.salespersonid
WHERE o.orderid IS NULL;


/* 7. Customers without shipped orders. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
WHERE o.orderstatus <> 'Shipped';

/*
You wrote

WHERE orderstatus <> 'Shipped'
That returns customers who have any non-shipped order.
It does not mean they never had a shipped order.

*/
-- CORRECT QUERY
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
AND o.orderstatus = 'Shipped'
WHERE o.orderid IS NULL;



/* 8. Products never ordered in 2025. */
SELECT p.product
FROM products AS p 
LEFT JOIN orders AS o 
ON p.productid = o.productid
WHERE o.productid IS NULL AND o.orderdate BETWEEN '2025/01/01' AND '2025/12/31' ;

/*
FEEDBACK
You wrote

WHERE o.productid IS NULL
AND orderdate BETWEEN...

If o.productid IS NULL, then orderdate is also NULL, so this condition can never be true.
*/

-- CORRECT QUERY
SELECT p.product
FROM products p
LEFT JOIN orders o
ON p.productid = o.productid
AND YEAR(o.orderdate)=2025
WHERE o.orderid IS NULL;


/* 9. Salespersons without orders. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
LEFT JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.salespersonid IS NULL;


/* 10. Customers who never bought Clothing. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
LEFT JOIN products AS p 
ON p.productid = o.productid
WHERE o.productid IS NULL AND p.category != 'Clothing';

-- CORRECT QUERY
SELECT c.firstname,
       c.lastname
FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
LEFT JOIN products p
ON o.productid = p.productid
AND p.category = 'Clothing'
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(p.productid) = 0;


/****************************** Pattern 9 – DISTINCT ****************************** 
Clue words
unique
different

Use: DISTINCT */
/* 1. Display unique countries.*/
SELECT DISTINCT country
FROM customers;

/* 2. Find unique departments.*/
SELECT DISTINCT department
FROM employees;

/* 3. Show unique order statuses. */
SELECT DISTINCT orderstatus
FROM orders;

/* 4. Display different categories. */
SELECT DISTINCT category
FROM products;

/* 5. Show unique customer countries. */
SELECT DISTINCT country
FROM customers;

/* 6. Find unique shipping addresses. */
SELECT DISTINCT shipaddress
FROM orders;

/* 7. Show distinct product categories. */
SELECT DISTINCT category
FROM products;

/* 8.  Display unique salespersons. */
SELECT DISTINCT firstname, lastname
FROM employees;

/* 9. Show unique customers who ordered. */
SELECT DISTINCT c.firstname, c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;

/* 10. Find distinct order dates. */
SELECT DISTINCT orderdate
FROM orders;

/********************************** Pattern 10 – COUNT(DISTINCT)  **********************************

Clue words
unique customers
unique products
different customers
*/
/* 1. Count unique customers served by each salesperson. */
SELECT e.firstname,
       e.lastname,
	   COUNT(DISTINCT c.customerid) AS num_unique_customers
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;


/* 2 Count unique products ordered by each customer. */
SELECT c.firstname,
       c.lastname,
       COUNT(DISTINCT p.product) AS num_unique_products
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
INNER JOIN customers AS c 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;

/* A slightly better interview practice is to use the primary key.

COUNT(DISTINCT p.productid)

because IDs are guaranteed to be unique whereas product names may not be. */
-- CORRECT QUERY
SELECT c.firstname,
       c.lastname,
       COUNT(DISTINCT p.productid) AS num_unique_products
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
INNER JOIN customers AS c 
ON c.customerid = o.customerid
GROUP BY c.customerid, c.firstname, c.lastname;




/* 3 Count unique countries. */
SELECT COUNT(DISTINCT country) AS unique_countries
FROM customers;


/* 4 Count different categories sold. */
SELECT COUNT(DISTINCT category) AS unique_category
FROM products;

/* You wrote

SELECT COUNT(DISTINCT category)
FROM products;
Technically correct for your SalesDB.

However, think about the wording.

different categories sold

Since only ordered products are considered "sold", the better query is

SELECT COUNT(DISTINCT p.category) AS unique_categories
FROM products p
INNER JOIN orders o
ON p.productid = o.productid;

In your current dataset both queries may return the same result, but in a real interview the JOIN version matches the wording better.  */

-- CORRECT QUERY
SELECT COUNT(DISTINCT p.category) AS unique_cateogy 
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid;


/* 5 Count unique departments. */
SELECT COUNT(DISTINCT department) AS unqiue_departments
FROM employees;


/* 6 Count different customers per product.  */
SELECT o.productid,
       COUNT(DISTINCT c.customerid) AS unique_customers
FROM customers AS c
INNER JOIN orders AS o
ON c.customerid = o.customerid
GROUP BY o.productid;

/* Even better:

SELECT p.product,
       COUNT(DISTINCT c.customerid)

by joining products so the output is easier to read. */

-- BETTER QUERY
SELECT COUNT(DISTINCT c.customerid) AS num_customers,
       p.product
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
GROUP BY p.productid, p.product;

       
/* 7 Count unique shipping cities. */
SELECT COUNT(DISTINCT shipaddress) AS unique_cities
FROM orders;

/*
FEEDBACK
The question says

shipping cities

You counted

COUNT(DISTINCT shipaddress)

Correct query

SELECT COUNT(DISTINCT shipaddress) -- ❌

should be

SELECT COUNT(DISTINCT shipaddress)

Actually, looking at your SalesDB schema:

shipaddress

exists, but there is no shipcity column.

So for your SalesDB, the question itself is inconsistent. In databases like Northwind, you'd use ship_city. With your current schema, you can either:

Count distinct shipping addresses, or
Skip this question because the schema doesn't contain a city column.

So this isn't your mistake—it comes from the dataset.
*/


/* 8 Count different products sold by each employee. */
SELECT e.firstname,
       e.lastname,
       COUNT(DISTINCT p.productid) AS num_products
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid 
INNER JOIN employees AS e 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname;

/*
COUNT(DISTINCT p.product)
✅ Correct.

Again, interview style:

COUNT(DISTINCT p.productid)
is slightly better.
*/


/* 9 Count unique customers in each country. */
SELECT country,
	   COUNT(DISTINCT customerid) AS num_customers
FROM customers 
GROUP BY country;


/* 10 Count distinct order dates. */
SELECT COUNT(DISTINCT orderdate) AS unique_order_count
FROM orders;




/****************************** Pattern 11 – Subquery  **************************************

Clue words
above average
below average
greater than average
maximum
minimum

*/
/* 1. Employees earning above average salary.  */
SELECT * 
FROM employees 
WHERE salary > (
      SELECT AVG(salary)
      FROM employees
);



/* 2. Customers scoring above average.  */
SELECT *
FROM customers 
WHERE score > (
      SELECT AVG(score)
      FROM customers
);


/* 3. Products priced above average.  */
SELECT *
FROM products 
WHERE price > (
      SELECT AVG(price)
      FROM products
); 


/* 4. Orders above average sales.  */
SELECT *
FROM orders 
WHERE sales > (
      SELECT AVG(sales)
      FROM orders
);



/* 5. Departments whose average salary exceeds company average.  */
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (
       SELECT AVG(salary)
       FROM employees
);

/* 6. Products above category average. (later, correlated subquery) */



/* 7. Customers spending above average.  */
SELECT c.firstname, 
       c.lastname,
       AVG(p.price) AS avg_spending
FROM customers AS c 
INNER JOIN orders AS o 
ON o.customerid = c.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING AVG(p.price) > (
       SELECT AVG(price)
       FROM products
); 

/*
You wrote

AVG(price)

Question says

Customers spending

Customers spend sales, not product price.
*/
SELECT
c.firstname,
c.lastname,
SUM(o.sales) AS total_spending
FROM customers c
JOIN orders o
ON c.customerid=o.customerid
GROUP BY c.customerid,c.firstname,c.lastname
HAVING SUM(o.sales)>
(
SELECT AVG(customer_sales)
FROM
(
SELECT SUM(sales) customer_sales
FROM orders
GROUP BY customerid
)t
);



/* 8. Employees with salary below average.  */
SELECT firstname,
       lastname,
       salary
FROM employees 
WHERE salary < (
      SELECT AVG(salary)
      FROM employees
);


/* 9. Products cheaper than average.  */
SELECT product,
       price
FROM products
WHERE price < (
      SELECT AVG(price)
      FROM products
);


/* 10. Orders larger than average quantity.  */
SELECT *
FROM orders
WHERE quantity > (
      SELECT AVG(quantity)
      FROM orders
);



/*****************************  Pattern 12 – Business Reports  **************************************

Clue words
report
dashboard
summary
KPI


*/

/* 1. Customer sales report. */



/* 2. Employee performance report. */


/* 3. Product revenue report. */


/* 4. Country summary report. */


/* 5. Department salary report. */


/* 6. Category revenue report. */


/* 7. Sales dashboard. */


/* 8. Customer dashboard. */


/* 9. Inventory report. */


/* 10. Company KPI dashboard. */


/************** Pattern 13 – "Both" Conditions (Very Common) ******************
Clue words
both
all
every

Usually: GROUP BY + HAVING COUNT(DISTINCT ...)

*/
/* 1. Customers who bought both Clothing and Accessories.  */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) = 2;



/* 2. Employees who handled both Delivered and Shipped orders. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(DISTINCT o.orderstatus) = 2;

/*
HAVING COUNT(DISTINCT o.orderstatus)=2;

✅ Correct.

Even better would be

WHERE o.orderstatus IN ('Delivered','Shipped')

before grouping.

Why?

Imagine later someone adds

Cancelled
Pending
Returned

Then

COUNT(DISTINCT)=2

may not represent Delivered + Shipped.
*/
-- CORRECT QUERY
SELECT e.firstname,
       e.lastname
FROM employees e
JOIN orders o
ON e.employeeid=o.salespersonid
WHERE o.orderstatus IN ('Delivered','Shipped')
GROUP BY e.employeeid,e.firstname,e.lastname
HAVING COUNT(DISTINCT o.orderstatus) = 2;




/* 3. Customers ordering from all categories. */
SELECT c.firstname,
	   c.lastname,
       COUNT(DISTINCT p.category) AS num_unique_category
FROM customers AS c
INNER JOIN orders AS o
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON o.productid = p.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) = (
	   SELECT COUNT(DISTINCT category)
       FROM products
);


/* 4. Products sold in both January and February. */
SELECT p.product,
	   COUNT(DISTINCT MONTH(o.orderdate))
FROM products AS p
INNER JOIN orders AS o 
ON p.productid = o.productid
AND MONTH(o.orderdate) IN ('01', '02')
GROUP BY p.productid, p.product
HAVING COUNT(DISTINCT MONTH(o.orderdate)) = 2;

/*
I'd simply move the month filter into WHERE.

WHERE MONTH(o.orderdate) IN (1,2)

instead of

ON ...
AND MONTH(...)

Reason

JOIN connects tables.

WHERE filters rows.
*/
SELECT p.product
FROM products AS p
INNER JOIN orders AS o 
ON p.productid = o.productid
WHERE MONTH(o.orderdate) IN ('01', '02')
GROUP BY p.productid, p.product
HAVING COUNT(DISTINCT MONTH(o.orderdate)) = 2;


/* 5. Customers who bought both Bottle and Caps.  */
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



/* 6. Employees who sold both Clothing and Accessories. */
SELECT e.firstname,
       e.lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
INNER JOIN products AS p 
ON p.productid = o.productid
WHERE p.category IN ('Clothing', 'Accessories')
GROUP BY e.employeeid, e.firstname, e.lastname
HAVING COUNT(DISTINCT p.category) = 2;



/* 7. Customers who placed both Delivered and Pending orders. */
SELECT c.firstname,
       c.lastname
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
WHERE o.orderstatus IN ('Pending', 'Delivered')
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(o.orderstatus) = 2;


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
ON c.customerid = o.customerid
WHERE c.country IN ('USA', 'Germany')
GROUP BY e.employeeid, e.firstname, e.lastname;



/* 10. Customers ordering from more than one category. */
SELECT c.firstname,
       c.lastname
FROM customers AS c
INNER JOIN orders AS o 
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT p.category) > 1;








































