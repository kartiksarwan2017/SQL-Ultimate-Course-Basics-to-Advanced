/*********************************  Round 1 (Interview Level)  ***************************************/
/* 

Q1
Display all German customers who have placed at least one Delivered order.
Output
Customer Full Name
Order ID
Product Name
Sales

Order by Sales descending.
*/
SELECT CONCAT(c.firstname, " ", c.lastname) AS customer_fullname,
       o.orderid,
       p.product AS product_name,
       o.sales 
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customerid = o.customerid
LEFT JOIN products p 
ON p.productid = o.productid
WHERE c.country = 'Germany' AND o.orderstatus = 'Delivered'
ORDER BY o.sales;

/*
FEEDBACK
Since you're filtering on orders in the WHERE clause, the LEFT JOIN behaves exactly like an INNER JOIN.
Also, the question said:
Order by Sales descending.

You wrote
ORDER BY o.sales;
which is ascending.
*/


-- CORRECT QUERY
SELECT CONCAT(c.firstname,' ',c.lastname) AS customer_name,
       o.orderid,
       p.product,
       o.sales
FROM customers c
JOIN orders o
ON c.customerid=o.customerid
JOIN products p
ON p.productid=o.productid
WHERE c.country='Germany'
AND o.orderstatus='Delivered'
ORDER BY o.sales DESC;


/* 
Q2
Display each salesperson and the number of customers they have served.

Output
Salesperson Name
Unique Customers
Order by customer count descending.

(Hint: don't count duplicate customers.)
*/
SELECT e.firstname,
	   e.lastname,
	   COUNT(c.customerid) AS num_customers
FROM orders AS o 
INNER JOIN employees AS e
ON o.salespersonid = e.employeeid
INNER JOIN customers AS c 
ON o.customerid = c.customerid
GROUP BY e.firstname, e.lastname
ORDER BY COUNT(c.customerid) DESC;


/*

Question

Number of UNIQUE customers
You wrote
COUNT(c.customerid)

Suppose customer 1 placed five orders with Mary.
Your query counts 5
Expected
1

Use
COUNT(DISTINCT c.customerid)
*/

-- CORRECT QUERY
SELECT 
    e.firstname,
    e.lastname,
    COUNT(DISTINCT o.customerid) AS unique_customers
FROM employees e
JOIN orders o ON e.employeeid = o.salespersonid
GROUP BY e.employeeid , e.firstname , e.lastname
ORDER BY unique_customers DESC;



/* 
Q3

Display products that have never been delivered.
Output
Product Name
Category
*/
SELECT p.product AS productname,
       p.category
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
WHERE o.orderstatus <> 'Delivered';

/*
FEEDBACK 
Question

Products that have NEVER been delivered.
Your query
WHERE orderstatus<>'Delivered'

This returns products that have at least one non-delivered order.
Imagine
Bottle
Delivered
Shipped

Your query still returns Bottle.
But Bottle HAS been delivered.
Need anti-join logic.
Correct
*/

SELECT p.product,
       p.category
FROM products p
LEFT JOIN orders o
ON p.productid=o.productid
AND o.orderstatus='Delivered'
WHERE o.orderid IS NULL;

/* 
Q4

Display customers whose total sales are greater than the average sales of all orders.
Output
Customer Name
Total Sales
*/
SELECT c.firstname,
       c.lastname,
       SUM(o.sales) AS total_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.firstname, c.lastname
HAVING SUM(o.sales) > AVG(o.sales);

/*
Question

Total customer sales > average sales of ALL orders

You wrote

HAVING SUM(o.sales) > AVG(o.sales)

You're comparing

customer total

vs

customer average
Instead compare against
overall average
*/


-- CORRECT QUERY
SELECT c.firstname,
       c.lastname,
       SUM(o.sales) AS total_sales
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid
GROUP BY c.firstname, c.lastname
HAVING SUM(o.sales) > (
	   SELECT AVG(sales)
	   FROM orders
);

/* 
Q5

Display departments where employees handled more than two orders in total.
Output
Department
Total Orders
*/
SELECT e.department,
       COUNT(o.orderid) AS total_orders
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
GROUP BY e.department
HAVING COUNT(o.orderid) > 2;


/* 
Q6

Display each product with
Product
Category
Total Quantity Sold
Revenue
Sort by Revenue descending.
*/
SELECT p.product AS product_name,
       p.category,
       SUM(o.quantity) AS total_quantity,
       SUM(o.sales) AS revenue
FROM products AS p 
INNER JOIN orders AS o 
ON p.productid = o.productid
GROUP BY p.product, p.category
ORDER BY SUM(o.sales) DESC;


/* 
Q7
Display customers who ordered both Clothing and Accessories products.
Output
Customer Name
(No duplicates.)
*/
SELECT c.firstname,
	   c.lastname, 
	   p.category
FROM customers AS c 
INNER JOIN orders AS o
ON c.customerid = o.customerid
INNER JOIN products AS p 
ON p.productid = o.productid
WHERE p.category = 'Accessories' OR p.category = 'Clothing';

/*
Question

Customers who ordered

Accessories

AND

Clothing

Your query

WHERE category='Accessories'
OR category='Clothing'

This returns anyone who ordered either category.

Need customers who ordered BOTH.

Correct



*/


-- CORRECT QUERY
SELECT
c.firstname,
c.lastname
FROM customers c
INNER JOIN orders o
ON c.customerid = o.customerid
INNER JOIN products p
ON p.productid = o.productid
GROUP BY c.customerid,c.firstname,c.lastname
HAVING COUNT(DISTINCT p.category) = 2;

/* 
Q8
Display every order with
Customer Name
Salesperson Name
Product
Order Status
Show only orders whose salesperson belongs to the Sales department.
*/
SELECT o.orderid,
       c.firstname AS customer_firstname,
       c.lastname AS customer_lastname,
       e.firstname AS salesperson_firstname,
       e.lastname AS salesperson_lastname,
       p.product,
       o.orderstatus
FROM orders AS o 
LEFT JOIN customers AS c 
ON c.customerid = o.customerid
LEFT JOIN employees AS e
ON e.employeeid = o.salespersonid
LEFT JOIN products AS p
ON p.productid = o.productid
WHERE e.department = 'Sales';

/* 
Q9
Display products whose average sale is greater than the average sale of all orders.
Output
Product
Average Sale
*/
SELECT p.product, 
       AVG(o.sales) AS avg_sales
FROM products AS p 
INNER JOIN orders AS o 
ON o.productid = p.productid
GROUP BY p.product
HAVING AVG(o.sales) > (
       SELECT AVG(sales)
       FROM orders
);


/* 
Q10
Display employees who never handled a Delivered order.
*/
SELECT e.firstname,
       e.lastname
FROM employees AS e 
INNER JOIN orders AS o 
ON e.employeeid = o.salespersonid
WHERE o.orderstatus <> 'Delivered';

/*
FEEDBACK
Employees who NEVER handled Delivered orders.

Your query
WHERE orderstatus <> 'Delivered'

Suppose Mary handled
Delivered
Shipped

Your query still returns Mary.
Need anti join.

*/
SELECT
e.firstname,
e.lastname
FROM employees e
LEFT JOIN orders o
ON e.employeeid=o.salespersonid
AND o.orderstatus='Delivered'
WHERE o.orderid IS NULL;



