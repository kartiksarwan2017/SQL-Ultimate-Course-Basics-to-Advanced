USE SalesDB;

/******************** Pattern 1 — String Functions   ****************************
Clue Words
format
extract
initials
uppercase
lowercase
length
first name
last name
concatenate
replace
*/

/*
Q1
Display customer full name.
(Hint: CONCAT)
*/
SELECT CONCAT(firstname, ' ', lastname) AS fullname
FROM Sales.Customers;

-- BETTER
SELECT CONCAT(firstname, ' ', ISNULL(lastname, '')) AS fullname
FROM Sales.Customers;

/*
Q2
Display employee names in UPPERCASE.
*/
SELECT UPPER(firstname) AS firstname,
       UPPER(lastname) AS lastname
FROM Sales.Employees;

/*
Q3
Display product names in lowercase.
*/
SELECT LOWER(product) AS product_name
FROM Sales.Products;

/*
Q4
Show customer first name along with number of characters.
(Hint: LENGTH)
*/
SELECT firstname,
       LEN(firstname) AS firstname_length
FROM Sales.Customers;

/*
Q5
Display first 3 letters of every product.
(Hint: LEFT)
*/
SELECT LEFT(product, 3) AS firstThreeCharsProduct
FROM Sales.Products;

/*
Q6
Display last 2 letters of each employee's last name.
(Hint: RIGHT)
*/
SELECT RIGHT(lastname, 2) AS emp_last2letters
FROM Sales.Employees;

-- BETTER
SELECT RIGHT(ISNULL(lastname, ''), 2) AS emp_last2chars
FROM Sales.Employees;

/*
Q7
Replace "USA" with "United States".
(Hint: REPLACE)
*/
SELECT REPLACE(country, 'USA', 'United States') AS customer_country
FROM Sales.Customers;

/*
Q8
Display initials of every employee.
Example
Frank Lee
↓
F.L
(Hint: LEFT + CONCAT)
*/
SELECT CONCAT(LEFT(firstname, 1), '.', LEFT(lastname, 1)) AS employee_initials
FROM Sales.Employees;

-- BETTER QUERY
SELECT CONCAT(LEFT(firstname, 1), '.', COALESCE(LEFT(lastname, 1), '')) AS employee_initials
FROM Sales.Employees;

/*
Q9
Display customers whose first name starts with 'M'.
(Hint: LEFT or LIKE)
*/
SELECT firstname,
       lastname
FROM Sales.Customers
WHERE LEFT(firstname, 1) = 'M';

SELECT firstname,
       lastname
FROM Sales.Customers
WHERE firstname LIKE 'M%';

/*
Q10
Display products containing the letter 'o'.
(Hint: LIKE)
*/
SELECT product
FROM Sales.Products
WHERE product LIKE '%o%';



/******************** Pattern 2 — Number Functions  ***********************
Clue Words
round
nearest
absolute
ceiling
floor
random
square root
power
*/

/* 
Q1
Round every product price to nearest 10.
*/
SELECT ROUND(price, 0) AS roundoff
FROM Sales.Products;

/*
Requirement:

Round to nearest 10

Your query:

SELECT ROUND(price, 0)
FROM Products;

❌ This rounds to the nearest integer, not the nearest 10.
*/
-- CORRECT QUERY
SELECT ROUND(price, -1) AS rounded_price
FROM Sales.Products;


/* 
Q2
Display square root of each product price.
*/
SELECT SQRT(price) AS sqrt_product_price
FROM Sales.Products;

/* 
Q3
Display employee salary divided by 1000 rounded to 2 decimals.
*/
SELECT ROUND(salary/1000.0, 2) AS emp_salary
FROM Sales.Employees;

/*
One improvement for SQL Server:

ROUND(salary/1000.0,2)

Using 1000.0 avoids integer division in some scenarios.
*/



/* 
Q4
Display absolute difference between salary and 60000.
*/
SELECT ABS(salary - 60000) AS abs_salary
FROM Sales.Employees;

/* 
Q5
Display ceiling value of
Price / 3
*/
SELECT CEILING(price/3) AS ceiled_price
FROM Sales.Products;

/* 
Q6
Display floor value of
Price / 3
*/
SELECT FLOOR(price/3) AS floor_price
FROM Sales.Products;


/* 
Q7
Display product price squared.
*/
SELECT SQUARE(price) AS squared_price
FROM Sales.Products;

/* 
Q8
Display product price raised to power 3.
*/
SELECT POWER(price, 3) AS price
FROM Sales.Products;

/* 
Q9
Display random number for every customer.
*/
SELECT RAND() AS random_number
FROM Sales.Customers;

/*
Technically correct, but there's an important difference between SQL Server and MySQL.

MySQL
RAND()

generates a new random value for each row.

SQL Server
RAND()
returns the same value for every row in a query.

To get different random values per row in SQL Server, people often use:

SELECT NEWID();
or
SELECT RAND(CHECKSUM(NEWID()));
This is a nice interview discussion point.
*/


/* 
Q10
Round customer score to nearest hundred.
*/
SELECT FLOOR(score) AS nearest_score
FROM Sales.Customers;

/*
Requirement:

Round to nearest hundred

Your query:

FLOOR(score)

❌ FLOOR() only removes decimals.

It does not round to the nearest hundred.

Correct:

ROUND(score,-2)
*/

SELECT ROUND(score, -2) 
FROM Sales.Customers;



/*****************  Pattern 3 — Date Functions  ************************

Clue Words
year
month
day
weekday
current date
age
difference
last month
current year

*/

/*
Q1
Display year of every order.
*/
SELECT YEAR(orderdate) AS orderyear
FROM Sales.Orders;

/*
Q2
Display month name of every order.
*/
SELECT DATENAME(month, orderdate) AS ordermonth
FROM Sales.Orders;

/*
Q3
Display day of month.
*/
SELECT DAY(orderdate) AS day
FROM Sales.Orders;

/*
Q4
Display weekday name of every order.
*/
SELECT DATENAME(weekday, orderdate) AS weekday
FROM Sales.Orders;

/*
Q5
Display number of days between order date and ship date.
*/
SELECT DATEDIFF(day, orderdate, shipdate) AS numofdays
FROM Sales.Orders;

/*
Q6

Display employees born after 1985.
*/
SELECT firstname,
       lastname
FROM Sales.Employees
WHERE YEAR(birthdate) > 1985;

/*
Born after 1985

You wrote

YEAR(birthdate)=1985

❌

Need

YEAR(birthdate)>1985

or

birthdate>'1985-12-31'
*/




/*
Q7

Display all orders placed in February.
*/
SELECT *
FROM Sales.Orders
WHERE DATENAME(month, orderdate) = 'February';

SELECT *
FROM Sales.Orders
WHERE MONTH(orderdate) = 2;

/*
Q8

Display orders shipped within 5 days.
*/
SELECT *
FROM Sales.Orders
WHERE DATEDIFF(day, orderdate, shipdate) <= 5;


/*
Q9
Display current date and current timestamp.
*/
SELECT GETDATE() AS currentdate, 
       CURRENT_TIMESTAMP AS currenttimestamp;


/*
Q10
Display order year and month together.
Example
2025-02
*/
SELECT CONCAT(DATEPART(year, orderdate), '-0', DATEPART(month, orderdate)) AS year_month
FROM Sales.Orders;

SELECT FORMAT(orderdate, 'yyyy-MM') AS year_month
FROM Sales.Orders;

SELECT CONCAT(YEAR(orderdate), '-', RIGHT('0' + CAST(MONTH(orderdate) AS VARCHAR), 2)) AS year_month
FROM Sales.Orders;


/* Pattern 4 — Combined String + Date + Number (Interview Favorite) */
/*
Q1

Display
Full Name
Order Year
Sales

using one query.
*/
SELECT CONCAT(c.firstname, ' ', c.lastname) AS fullname,
       YEAR(o.orderdate) AS orderyear,
       o.sales
FROM Sales.Customers AS c 
INNER JOIN Sales.Orders AS o
ON c.customerid = o.customerid;




/*
Q2

Display

Employee Initials
Department
Salary in Lakhs

*/
SELECT CONCAT(LEFT(firstname, 1), RIGHT(lastname, 1)) AS employeeinitials,
       department,
       salary
FROM Sales.Employees;

/*
Question:

Salary in Lakhs

You returned:

salary

Need:

salary / 100000.0

Example:

65000 → 0.65
*/
SELECT CONCAT(LEFT(firstname, 1), RIGHT(lastname, 1)) AS employeeinitials,
       department,
       (salary/100000.0) AS salaryinlakhs
FROM Sales.Employees;


-- BETTER SOLUTION
SELECT CONCAT(LEFT(firstname, 1), RIGHT(lastname, 1)) AS employeeinitials,
       department,
       ROUND((salary/100000.0), 2) AS salaryinlakhs
FROM Sales.Employees;



/*
Q3

Display

Customer Name
Country in Uppercase

*/
SELECT CONCAT(firstname, ' ', lastname) AS customer_name,
       UPPER(country) AS country
FROM Sales.Customers;

/*
Q4

Display

Product
Rounded Price

*/
SELECT product,
       ROUND(price, 0) AS price
FROM Sales.Products;


/*
Q5

Display

Order Month Name
Sales
*/
SELECT MONTH(orderdate) AS ordermonth,
       sales
FROM Sales.Orders;

/*
Question:

Order Month Name

You wrote:

MONTH(orderdate)

Returns:

1
2
3

Should be:

DATENAME(month,orderdate)

or

MONTHNAME(orderdate)
*/
-- CORRECT QUERY
SELECT DATENAME(month, orderdate) AS ordermonth,
       sales
FROM Sales.Orders;


/*
Q6

Display

Customer Name
Order Date (DD-MM-YYYY)
*/
SELECT CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
       FORMAT(o.orderdate, 'dd-MM-yyyy') AS orderdate
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
ON c.customerid = o.customerid;


/*
Q7

Display

Product Name
Length of Product Name
*/
SELECT product,
       LEN(product) AS productlength
FROM Sales.Products;

/*
Q8

Display

Employee Name
Age in Years
*/
SELECT CONCAT(firstname, ' ', lastname) AS employee_name,
       DATEDIFF(year, FORMAT(birthdate, 'yyyy'), FORMAT(GETDATE(), 'yyyy')) AS Age 
FROM Sales.Employees;

/*
Age calculation not correct.

Better:

SQL Server:

DATEDIFF(year,birthdate,GETDATE())
*/

-- CORRECT QUERY
SELECT CONCAT(firstname, ' ', lastname) AS employee_name,
       DATEDIFF(year, birthdate, GETDATE()) AS Age 
FROM Sales.Employees;


/*
Q9

Display

Customer Name
Days Taken to Ship
*/
SELECT CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
       DATEDIFF(day, o.orderdate, o.shipdate) AS ship_days_taken
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.customerid = o.customerid;

/*
Q10

Display

Product
Price
Price after 18% GST
*/
SELECT product,
       price,
       '$ ' + CAST((price - price * 18 / 100) AS VARCHAR) AS priceaftergst
FROM Sales.Products;

/*
GST added means:

price + (price * 18/100.0)

You subtracted GST.
*/
SELECT product,
       price,
       (price + price * 18 / 100) AS priceaftergst
FROM Sales.Products;