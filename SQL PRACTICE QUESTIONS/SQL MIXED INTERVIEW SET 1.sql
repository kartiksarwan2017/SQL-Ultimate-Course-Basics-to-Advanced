/**************** Mixed Interview Set 1 (20 Questions) ******************/
USE SalesDB;


/*
Q1 Display employees whose salary is greater than the company average salary.

Here we require subquery to find the company average and compare with salary of each employee
*/
SELECT *
FROM Sales.Employees
WHERE Salary > (
      SELECT AVG(Salary)
      FROM Sales.Employees
);

/*
Q2 Display the highest-priced product in each category.

Here we will use window function since we have to find category wise highest price product
*/
SELECT *
FROM (
    SELECT ProductID,
           Product,
           Category, 
           Price,
           MAX(Price) OVER(PARTITION BY Category) AS HighestPrice
    FROM Sales.Products
) AS t
WHERE Price = HighestPrice;

SELECT *
FROM (
    SELECT *, 
           RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
    FROM Sales.Products
) AS t
WHERE PriceRank = 1;

SELECT *
FROM Sales.Products AS p1
WHERE Price = (
      SELECT MAX(Price)
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);

SELECT Category,
       MAX(Price) AS highestPrice
FROM Sales.Products
GROUP BY Category;

/*
You wrote

MAX() OVER(PARTITION BY Category)

instead of

RANK()

That is perfectly valid.

Interviewers love seeing multiple solutions.

Possible solutions:

✔ Window MAX

✔ RANK()

✔ Correlated Subquery

You immediately chose Window Function.

That shows maturity.
*/


/*
Q3 Display customers who have never placed an order.
*/
SELECT *
FROM Sales.Customers
WHERE CustomerID NOT IN (
      SELECT CustomerID
      FROM Sales.Orders
);

SELECT *
FROM Sales.Customers AS c
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE c.CustomerID = o.CustomerID
);


/*
Q4 Display every order along with the total sales made by that customer.

Output

OrderID
CustomerID
Sales
CustomerTotalSales
*/
SELECT OrderID,
       CustomerID,
       Sales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
FROM Sales.Orders;


/*
Q5 Display every employee and classify them as:

High Salary
Medium Salary
Low Salary
*/
SELECT *,
       CASE WHEN Salary > 70000 THEN 'High Salary'
            WHEN Salary > 50000 THEN 'Medium Salary'
            ELSE 'Low Salary'
       END AS SalaryStatus
FROM Sales.Employees;


/************* Medium (Q6–Q10) ***********/
/*
Q6 Display the latest order of every customer.
*/
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
) AS t
WHERE OrderDateRank = 1;

/*
Although I'd probably use

ROW_NUMBER()

Why?

Suppose customer has

Jan 5

Jan 5

Latest order?

If only one row should be returned

ROW_NUMBER()

If all tied latest orders should be returned

RANK()

Your solution is still correct.
*/


/*
Q7 Display products priced above the average price of their category.
*/
SELECT *
FROM Sales.Products AS p1
WHERE Price > (
      SELECT AVG(Price)
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);

SELECT *
FROM (
    SELECT *,
           AVG(Price) OVER(PARTITION BY Category) AS AveragePrice
    FROM Sales.Products
) AS t
WHERE Price > AveragePrice;


/*
Q8 Display employees who handled orders for Clothing products.
*/
SELECT *
FROM Sales.Employees
WHERE EmployeeID IN (
      SELECT SalesPersonID
      FROM Sales.Orders
      WHERE ProductID IN (
            SELECT ProductID
            FROM Sales.Products
            WHERE Category = 'Clothing'
      )
);



/*
Q9 Display each customer with:

Total Sales
Customer Category

Categories
Premium (>150)
Regular (>80)
New Customer
*/

/*
Option 1 (Recommended) — ROW_NUMBER() + Window Function

This is the approach I would use in an interview because it clearly says:

Calculate total sales using a window function.
Keep only one row per customer.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       TotalSales,
       CASE
           WHEN TotalSales > 150 THEN 'Premium'
           WHEN TotalSales > 80 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) OVER(PARTITION BY c.CustomerID) AS TotalSales,
           ROW_NUMBER() OVER(PARTITION BY c.CustomerID ORDER BY o.OrderID) AS rn
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
        ON c.CustomerID = o.CustomerID
) AS t
WHERE rn = 1;

/*
Option 2 — DISTINCT

Since the total sales are the same for every row of a customer, you can remove duplicates.
*/
SELECT DISTINCT
       CustomerID,
       FirstName,
       LastName,
       TotalSales,
       CASE
           WHEN TotalSales > 150 THEN 'Premium'
           WHEN TotalSales > 80 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) OVER(PARTITION BY c.CustomerID) AS TotalSales
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
        ON c.CustomerID = o.CustomerID
) AS t;


-- APPROACH 2
SELECT *,
       CASE
           WHEN TotalSales > 150 THEN 'Premium'
           WHEN TotalSales > 80 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        SUM(o.Sales) AS TotalSales
    FROM Sales.Customers c
    JOIN Sales.Orders o
    ON c.CustomerID=o.CustomerID
    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName
) AS t;


-- APPROACH 3 
SELECT *,
       CASE
           WHEN TotalSales > 150 THEN 'Premium'
           WHEN TotalSales > 80 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM (
SELECT DISTINCT CustomerID,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSales
FROM Sales.Orders
) AS t;

/*
This impressed me.

Most learners immediately write

GROUP BY

You instead wrote

SUM() OVER()

Let's see.

You wrote

SUM(Sales)
OVER(PARTITION BY CustomerID)

That calculates total sales.

Then

CASE

Very good.

The only issue is the output.

The question says

Display each customer

Your query returns one row per order, because you kept

o.Sales

in the result.

Example

Customer A

3 orders

Output

A 20
A 40
A 60

instead of

A 120

Two possible solutions

Option 1

GROUP BY

(one row/customer)

Option 2

Window Function + DISTINCT

For example

SELECT DISTINCT
CustomerID,
TotalSales

Everything else is correct.
*/



/*
Q10 Display every employee with:

Department Average Salary
Difference from Department Average
*/
SELECT *,
       AVG(Salary) OVER(PARTITION BY Department) AS DeptAverageSalary,
       Salary - AVG(Salary) OVER(PARTITION BY Department) AS SalaryDiffFromDeptAvg
FROM Sales.Employees;


/********** Medium-Advanced (Q11–Q15) **********/
/*
Q11 Display customers whose total sales are above the average customer sales.
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > (
       SELECT AVG(Sales)
       FROM Sales.Orders AS o1
       WHERE c.CustomerID = o1.CustomerID 
);

/*
Your solution:

HAVING SUM(o.Sales) > (
       SELECT AVG(Sales)
       FROM Sales.Orders AS o1
       WHERE c.CustomerID = o1.CustomerID
);
❌ Incorrect

Let's understand why.

Your subquery calculates:

Average sales for the same customer

Example:

Customer A

Order
10
20
30

Outer query

SUM = 60

Inner query

AVG = 20

Condition

60 > 20

This will almost always be true.

But the question says

Customers whose total sales are above the average customer sales

Meaning

Step 1

Compute

Customer 1 -> 120
Customer 2 -> 250
Customer 3 -> 90
Customer 4 -> 180

Step 2

Average of those totals

(120+250+90+180)/4

Step 3

Compare each customer's total against that average.

Correct solution
*/

-- CORRECT SOLUTION
SELECT c.CustomerID,
       c.FirstName,
       c.Lastname,
       SUM(o.Sales) AS TotalSales
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > (
       SELECT AVG(CustomerTotal)
       FROM (
            SELECT SUM(Sales) AS CustomerTotal
            FROM Sales.Orders
            GROUP BY CustomerID
       ) AS t
);


/*
Q12 Display products that have never been ordered.
*/
SELECT p.ProductID,
       p.Product,
       p.Category,
       p.Price
FROM Sales.Products AS p
LEFT JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;


SELECT *
FROM Sales.Products AS p
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE p.ProductID = o.ProductID
);

/*
Which one would I use?

I prefer

NOT EXISTS

because

handles NULL safely
intention is clearer
preferred in interviews
*/


/*
Q13 Display every order with:

Previous Sale
Next Sale
Difference from Previous Sale
*/
SELECT OrderID,
       OrderDate, 
       Sales,
       LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSale,
       LEAD(Sales) OVER(ORDER BY OrderDate) AS NextSale,
       Sales - LAG(Sales) OVER(ORDER BY OrderDate) AS DiffFromPrevSales
FROM Sales.Orders;

/*
One small improvement:

Instead of

LAG(...)

twice

you could compute it once in a CTE/derived table.
*/


/*
Q14 Display the second-highest salary.
*/
SELECT Salary
FROM (
SELECT *,
       RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
FROM Sales.Employees
) AS t
WHERE SalaryRank = 2;

/*
RANK()

Excellent.

One thing to know:

Using

RANK()

returns

all employees sharing second highest salary.

Example

100000

90000

90000

Both employees are returned.

If interview asks

second highest salary

RANK is usually correct.

If they ask

second employee

then ROW_NUMBER.
*/


/*
Q15 Display employees earning more than every employee in the Marketing department.
*/
SELECT *
FROM Sales.Employees AS e1
WHERE Salary > ALL (
      SELECT Salary
      FROM Sales.Employees AS e2
      WHERE Department = 'Marketing'
      AND e1.EmployeeID = e2.EmployeeID
);

/*
This line

AND e1.EmployeeID=e2.EmployeeID

turns the subquery into a correlated one.

Suppose

EmployeeID=5

If Employee 5 is not in Marketing

Subquery returns

empty set

If Employee 5 is in Marketing

Subquery returns

only that employee's salary.

Neither is what the question asks.

The question asks

Compare against

ALL Marketing salaries

No correlation needed.

Correct

SELECT *
FROM Sales.Employees
WHERE Salary >
ALL
(
    SELECT Salary
    FROM Sales.Employees
    WHERE Department='Marketing'
);

⭐ Rating: 4/10

You understood ALL, but accidentally converted it into a correlated subquery.
*/

-- CORRECT SOLUTION 
SELECT *
FROM Sales.Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM Sales.Employees
    WHERE Department='Marketing'
);


/************* Advanced (Q16–Q20) ************/
/*
Q16 Display the highest-selling product based on total sales.
*/
SELECT *
FROM (
    SELECT p.ProductID,
           p.Product,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(ORDER BY SUM(o.Sales) DESC) AS ProductRank
    FROM Sales.Orders AS o
    INNER JOIN Sales.Products AS p
    ON o.ProductID = p.ProductID
    GROUP BY p.ProductID, p.Product
) AS t
WHERE ProductRank = 1;

/*
Q17 Display every salesperson's highest sale.
*/
SELECT DISTINCT SalesPersonID,
       MAX(Sales) OVER(PARTITION BY SalesPersonID) AS HighestSales
FROM Sales.Orders;

SELECT SalesPersonID,
       MAX(Sales) AS HighestSales
FROM Sales.Orders
GROUP BY SalesPersonID;

/*
Which is better?

For this question

every salesperson's highest sale

I would choose

GROUP BY

because we only need one row per salesperson.

The window function version works but calculates the maximum for every order before DISTINCT removes duplicates.
*/


/*
Q18 Display every customer's first order date and latest order date.
*/
SELECT CustomerID,
       MIN(OrderDate) AS FirstOrderDate,
       MAX(OrderDate) AS LatestOrderDate
FROM Sales.Orders
GROUP BY CustomerID;

SELECT DISTINCT CustomerID,
       FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
       LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate
FROM Sales.Orders;

SELECT CustomerID,
       MIN(OrderDate) OVER(PARTITION BY CustomerID) AS FirstOrderDate,
       MAX(OrderDate) OVER(PARTITION BY CustomerID) AS LatestOrderDate
FROM Sales.Orders;

/*
Q19 Display employees earning above the average salary of their own department.
*/
SELECT *
FROM Sales.Employees AS e1
WHERE Salary > ( 
      SELECT AVG(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);


/*
Q20 Display product categories whose total sales are greater than the overall average category sales.
*/
SELECT *
FROM (
    SELECT DISTINCT p.Category,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category
) AS t
WHERE TotalSales > (
      SELECT AVG(CategorySales)
      FROM (
           SELECT SUM(Sales) AS CategorySales
           FROM Sales.Products AS p
           INNER JOIN Sales.Orders AS o
           ON p.ProductID = o.ProductID
           GROUP BY Category
      ) AS x
);


/**************** Bonus Challenge (Real Interview Style) **************/
/*
Q21 Display the top 3 customers based on total sales.
*/
SELECT TOP 3 CustomerID,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
ORDER BY TotalSales DESC;

SELECT TOP 3 c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSales DESC;


/*
Q22 Display customers who purchased both Clothing and Accessories products.
*/
SELECT c.FirstName,
       c.LastName
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(DISTINCT p.Category) = 2;


/*
Small issue

Imagine a customer purchased

Clothing
Accessories
Electronics

COUNT(DISTINCT Category)=3

Your query would exclude them even though they purchased both Clothing and Accessories.

A safer interview solution is

HAVING
COUNT(DISTINCT CASE
       WHEN Category IN ('Clothing','Accessories')
       THEN Category
END)=2

This works regardless of any extra categories.
*/
SELECT c.FirstName,
       c.LastName
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(DISTINCT CASE WHEN p.Category IN ('Clothing', 'Accessories')
                           THEN p.Category
                       END) = 2;


/*
Q23 Display every department with:

Total Salary
Highest Salary
Lowest Salary
Average Salary
*/
SELECT Department,
       SUM(Salary) AS TotalSalary,
       MAX(Salary) AS highestSalary,
       MIN(Salary) AS lowestSalary,
       AVG(Salary) AS AverageSalary
FROM Sales.Employees
GROUP BY Department;



/*
Q24 Display employees whose salary is the highest in their department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM Sales.Employees AS e1
WHERE Salary = (
      SELECT MAX(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);

SELECT *
FROM (
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       MAX(Salary) OVER(PARTITION BY Department) AS highestSalary
FROM Sales.Employees
) AS t
WHERE Salary = highestSalary;


/*
Q25 Display every order and classify it as:

Increased
Decreased
Same

compared with the previous order.
*/
SELECT *,
       CASE WHEN Sales > PreviousSales THEN 'Increased'
            WHEN Sales < PreviousSales THEN 'Decreased'
            WHEN PreviousSales IS NULL THEN 'First Order'
            ELSE 'Same'
       END AS SalesClassification
FROM (
SELECT OrderID,
       OrderDate,
       Sales,
       LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSales
FROM Sales.Orders
) AS t;

/*
Exactly what interviewers expect.

Only suggestion

First row has NULL PreviousSales.

Sometimes interviewers expect

CASE
WHEN PreviousSales IS NULL THEN 'First Order'
...

instead of Same.

Minor improvement.
*/


/*
Q26 Display products whose price is greater than the average price of products in the same category.
*/
SELECT *
FROM Sales.Products AS p1
WHERE Price > (
      SELECT AVG(Price)
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);

/*
Q27 Display customers whose total sales are higher than the overall average customer sales.
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > (
       SELECT AVG(CustomerSales)
       FROM (
            SELECT SUM(o.Sales) AS CustomerSales
            FROM Sales.Orders AS o
            INNER JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
            GROUP BY c.CustomerID
       ) AS t
);


/*
Q28 Display the most expensive product from each category.
*/
SELECT *
FROM (
SELECT ProductID,
       Product,
       Category,
       Price,
       MAX(Price) OVER(PARTITION BY Category) AS HighestPrice
FROM Sales.Products
) AS t
WHERE Price = HighestPrice;


SELECT *
FROM Sales.Products AS p1
WHERE Price = (
      SELECT MAX(Price)
      FROM Sales.Products AS p2
      WHERE p2.Category = p1.Category
);


/*
Q29 Display every customer along with:

Number of Orders
Total Sales
Average Order Value
*/
SELECT CustomerID,
       COUNT(*) AS NumberOfOrder,
       SUM(Sales) AS TotalSales,
       AVG(Sales) AS AverageOrderValue
FROM Sales.Orders
GROUP BY CustomerID;


SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       COUNT(o.OrderID) AS NumberOfOrder,
       SUM(o.Sales) AS TotalSales,
       AVG(o.Sales) AS AverageOrderValue
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;


/*
Q30 Generate a complete sales report containing:

Customer Name
Employee Name
Product Name
Sales
Customer Total Sales
Salesperson Total Sales
Product Category
Sales Category (High/Medium/Low)
*/
SELECT  c.FirstName AS CustomerFirstName,
        c.LastName AS CustomerLastName,
        e.FirstName AS EmployeeFirstName,
        e.LastName AS EmployeeLastName,
        p.Product AS ProductName,
        o.Sales,
        SUM(o.Sales) OVER(PARTITION BY c.CustomerID) AS CustomerTotalSales,
        SUM(o.Sales) OVER(PARTITION BY o.SalesPersonID) AS SalespersonTotalSales,
        p.Category,
        CASE WHEN o.Sales >= 100 THEN 'High'
             WHEN o.Sales > 50 THEN 'Medium'
             ELSE 'Low'
        END AS SalesCategory
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
INNER JOIN Sales.Employees AS e
ON e.EmployeeID = o.SalesPersonID;