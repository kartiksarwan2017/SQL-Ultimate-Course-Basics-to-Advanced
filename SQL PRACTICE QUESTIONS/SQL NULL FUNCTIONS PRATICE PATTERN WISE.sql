/******************** SQL NULL FUNCTIONS  *************************/

USE SalesDB;

/*
Pattern 1 — Replace NULL Values (ISNULL / COALESCE)
Clue Words
if null
replace null
default value
unknown
missing value

Think:

ISNULL()
COALESCE()
*/

/*
Q1
Display customer last name. If NULL, display 'Unknown'.
*/
SELECT ISNULL(lastname, 'Unknown') AS customer_lastname
FROM Sales.Customers;


/*
Q2
Display customer score. If NULL, display 0.
*/
SELECT COALESCE(score, 0) AS customer_score
FROM Sales.Customers;

SELECT ISNULL(score, 0) AS customer_score
FROM Sales.Customers;


/*
Q3
Display bill address. If NULL, display 'No Billing Address'.
*/
SELECT ISNULL(billaddress, 'No Billing Address') AS billing_address
FROM Sales.Orders;


/*
Q4
Display ship address. If NULL, display 'No Shipping Address'.
*/
SELECT ISNULL(shipaddress, 'No Shipping Address') AS ship_address
FROM Sales.Orders;



/*
Q5
Display employee manager ID. If NULL display 'No Manager'.
*/
SELECT ISNULL(CAST(managerid AS VARCHAR), 'No Manager') AS employee_manager_id
FROM Sales.Employees;



/*
Q6
Display customer full name. If last name is NULL, replace it with '-'.
*/
SELECT firstname + ' ' + ISNULL(lastname, '-') AS customer_fullname
FROM Sales.Customers;



/*
Q7
Display customer country and score. Replace NULL score with 100.
*/
SELECT country,
       COALESCE(score, 100) AS score
FROM Sales.Customers;




/*
Q8
Display orders with billing address. Replace NULL with shipping address.
(Hint: COALESCE)
*/
SELECT orderid,
       COALESCE(billaddress, shipaddress) AS billaddress
FROM Sales.Orders;



/*
Q9
Display shipping address. If both shipping and billing addresses are NULL display 'Unknown Address'.
(Hint: COALESCE)
*/
SELECT COALESCE(shipaddress, billaddress, 'Unknown Address') AS ship_address
FROM Sales.Orders;



/*
Q10
Display employee salary and manager ID. Replace NULL manager with 0.
*/
SELECT salary AS employee_salary,
       COALESCE(managerid, 0) AS manager_id
FROM Sales.Employees;


/*********** Pattern 2 — Find NULL Values  ***************

Clue Words
missing
blank
not entered
null

Think

IS NULL
*/

/*
Q11
Display customers whose score is NULL.
*/
SELECT *
FROM Sales.Customers
WHERE score IS NULL;

/*
Q12
Display customers whose last name is NULL.
*/
SELECT *
FROM Sales.Customers
WHERE lastname IS NULL;

/*
Q13
Display orders with NULL billing address.
*/
SELECT *
FROM Sales.Orders
WHERE billaddress IS NULL;

/*
Q14
Display orders with NULL shipping address.
*/
SELECT *
FROM Sales.Orders
WHERE shipaddress IS NULL;

/*
Q15
Display employees without managers.
*/
SELECT *
FROM Sales.Employees
WHERE ManagerID IS NULL;

/*
Q16
Display orders having NULL salesperson.
*/
SELECT *
FROM Sales.Orders
WHERE SalesPersonID IS NULL;

/*
Q17
Display orders having NULL customer.
*/
SELECT c.CustomerID, o.*
FROM Sales.Orders AS o 
LEFT JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

/* This works only if the CustomerID column itself is NULL. 
When would you need a JOIN?

If the requirement were:

Display orders whose customer record does not exist.

Then your LEFT JOIN approach would be appropriate:

SELECT o.*
FROM Orders o
LEFT JOIN Customers c
ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

Notice the difference:

WHERE o.CustomerID IS NULL → the foreign key value is NULL.
WHERE c.CustomerID IS NULL → the referenced customer record is missing.

That's an important distinction.


*/
-- Simpler Solution
SELECT *
FROM Sales.Orders
WHERE CustomerID IS NULL;

/*
Q18
Display orders with NULL product.
*/
SELECT p.ProductID,
       o.*
FROM Sales.Orders AS o 
LEFT JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
WHERE p.ProductID IS NULL;

/*
The requirement says:

Display orders with NULL product.

If it means the ProductID column is NULL, then simply write:

SELECT *
FROM Sales.Orders
WHERE ProductID IS NULL;

Use the JOIN version only when checking for missing parent records.
*/

-- SIMPLER SOLUTION
SELECT *
FROM Sales.Orders
WHERE ProductID IS NULL;

/*
Q19
Display products whose category is NULL.
*/
SELECT *
FROM Sales.Products
WHERE Category IS NULL;

/*
Q20
Display employees whose department is NULL.
*/
SELECT *
FROM Sales.Employees
WHERE Department IS NULL;

/*************** Pattern 3 — Find NOT NULL Values  **********************

Clue Words
available
entered
existing
provided

Think
IS NOT NULL

*/

/*
Q21
Display customers whose score is available.
*/
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

/*
Q22
Display customers with last names.
*/
SELECT FirstName,
       LastName
FROM Sales.Customers
WHERE LastName IS NOT NULL;

/*
Q23
Display orders having billing address.
*/
SELECT *
FROM Sales.Orders
WHERE BillAddress IS NOT NULL;

/*
Q24
Display orders having shipping address.
*/
SELECT *
FROM Sales.Orders
WHERE ShipAddress IS NOT NULL;

/*
Q25
Display employees having managers.
*/
SELECT *
FROM Sales.Employees
WHERE ManagerID IS NOT NULL;

/*
Q26
Display customers having both first name and last name.
*/
SELECT FirstName,
       LastName
FROM Sales.Customers
WHERE FirstName IS NOT NULL AND LastName IS NOT NULL;


/*
Q27
Display orders having quantity.
*/
SELECT *
FROM Sales.Orders
WHERE quantity IS NOT NULL;

/*
Q28
Display products with category.
*/
SELECT product,
       category
FROM Sales.Products
WHERE category IS NOT NULL;

/*
Q29
Display employees with salary.
*/
SELECT *
FROM Sales.Employees
WHERE Salary IS NOT NULL;

/*
Q30
Display customers whose country is available.
*/
SELECT *
FROM Sales.Customers
WHERE Country IS NOT NULL;



/***************
Pattern 4 — NULLIF (Interview Favorite)
Clue Words
treat as null
ignore zero
avoid divide by zero
convert value to NULL

Think

NULLIF()


***************/

/*
Q31
Display quantity and convert 0 quantity into NULL.
*/
SELECT NULLIF(Quantity, 0) AS quantity
FROM Sales.Orders;

/*
Q32
Display sales divided by quantity.
Avoid divide-by-zero.
*/
SELECT Sales/NULLIF(Quantity, 0) AS salesbyquantity
FROM Sales.Orders;

/*
This is exactly why NULLIF exists.

Without it:

Sales / Quantity

If Quantity = 0

↓

Divide by zero error

With

NULLIF(Quantity,0)

↓

0 becomes NULL

↓

Division returns NULL instead of throwing an error.

This is a very common interview question.
*/


/*
Q33
Display product price.
Treat price 0 as NULL.
*/
SELECT product,
       NULLIF(Price, 0) AS price
FROM Sales.Products;

/*
Q34
Display employee salary.
Treat salary 55000 as NULL.
*/
SELECT NULLIF(Salary, 55000) AS employee_salary
FROM Sales.Employees;

/*
Q35
Display customer score.
Treat score 0 as NULL.
*/
SELECT NULLIF(Score, 0) AS customer_score
FROM Sales.Customers;


/******************** Pattern 5 — Mixed NULL Questions (Interview Level)  ************************/


/*
Q36
Display customer full name.
If last name is NULL display Unknown.
*/
SELECT CONCAT(FirstName, ' ', ISNULL(LastName, 'Unknown')) AS CustomerFullName
FROM Sales.Customers;

/*
Q37
Display billing address.
If NULL, use shipping address.
If both NULL display Not Available.
*/
SELECT COALESCE(billAddress, shipAddress, 'Not Available') AS billing_address
FROM Sales.Orders;

/*
Q38

Display employee manager name.

If manager doesn't exist display No Manager.

(Self Join + ISNULL/COALESCE)
*/
SELECT
    e.FirstName,
    e.LastName,
    COALESCE(
        CONCAT(m.FirstName,' ',m.LastName),
        'No Manager'
    ) AS ManagerName
FROM Sales.Employees e
LEFT JOIN Sales.Employees m
ON e.ManagerID = m.EmployeeID;


/*
Q39

Display customer score category.

If score is NULL display No Score.

(You'll solve this later using CASE.)
*/
SELECT CASE WHEN Score IS NOT NULL THEN CAST(Score AS VARCHAR) ELSE 'No Score' END AS customer_score
FROM Sales.Customers;

/*
Since CASE is your next topic, this is a nice preview.

Once you learn CASE fully, you'll also write things like
CASE
WHEN Score>=800 THEN 'Excellent'
WHEN Score>=500 THEN 'Good'
ELSE 'Average'
END

*/



/*
Q40

Display sales per order.

If quantity is zero, avoid divide-by-zero using NULLIF().
*/
SELECT Sales / NULLIF(Quantity, 0)  AS sales_per_order
FROM Sales.Orders;

/*
Without NULLIF

Sales/Quantity

↓

Divide by zero

With

NULLIF(Quantity,0)

↓

Safe

Excellent.
*/
