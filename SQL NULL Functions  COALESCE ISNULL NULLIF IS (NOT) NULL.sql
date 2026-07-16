/***************** SQL NULL FUNCTIONS *****************/
USE SalesDB;


/*
SQL TASK
Find the average scores of the customer.
*/
SELECT customerid,
       score,
       COALESCE(score, 0) AS Score2,
       AVG(score) OVER() AvgScores,
       AVG(COALESCE(score, 0)) OVER() AS AvgScore
FROM Sales.Customers;

/*
SQL TASK
Display the full name of customers in a single field, 
by merging their first and last names,
and add 10 bonus points to each customer's score.
*/
SELECT customerid,
       firstname,
       lastname,
       score,
       firstname + ' ' + lastname AS fullname,
       COALESCE(lastname, '') AS lastname,
       CONCAT(firstname, ' ', COALESCE(lastname, '')) AS fullname,
       (COALESCE(score, 0) + 10) AS customer_score 
FROM Sales.Customers;


/*
SQL TASK
Sort the customers from lowest to highest scores, with nulls appearing
*/
-- METHOD 1 
SELECT customerid, 
       score,
       COALESCE(score, 9999999)
FROM Sales.Customers
ORDER BY COALESCE(score, 9999999) ASC;


-- METHOD 2
SELECT customerid, 
       score
FROM Sales.Customers
ORDER BY CASE WHEN score IS NULL THEN 1 ELSE 0 END, Score;


/*
SQL TASK
Find the sales price for each order by dividing the sales by the quantity
*/
SELECT orderid,
       sales,
       quantity,
       sales / NULLIF(quantity, 0) AS price
FROM Sales.Orders;


/*
SQL TASK
Identify the customers who have no scores
*/
SELECT *
FROM Sales.Customers
WHERE score IS NULL;


/*
SQL TASK
List all customers who have scores
*/
SELECT *
FROM Sales.Customers
WHERE score IS NOT NULL;

/*
SQL TASK
List all details of the customers who have not placed any orders
*/
SELECT c.customerid,
       c.firstname,
       c.lastname, 
       c.score
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.customerid = o.customerid
WHERE o.orderid IS NULL;

-- BETTER WAY
SELECT c.*,
       o.orderid
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;







