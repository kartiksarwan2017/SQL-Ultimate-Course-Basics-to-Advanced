/***************** SUBQUERY PATTERNS WISE PRACTICE ******************/

USE SalesDB;

/******** Pattern 1 — Scalar Subquery (Single Value) ********

Clue Words

average
highest
lowest
maximum
minimum
compare with overall value

Think

(SELECT AVG(...))
(SELECT MAX(...))
(SELECT MIN(...)) 

*/
/*
  Q1 Display employees whose salary is greater than the average salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM Sales.Employees
WHERE Salary > (
      SELECT AVG(Salary)
      FROM Sales.Employees
);


/*
  Q2 Display products whose price is greater than the average product price.
*/
SELECT ProductID,
       Product,
       Price
FROM Sales.Products
WHERE Price > (
      SELECT AVG(Price)
      FROM Sales.Products
);

/*
  Q3 Display customers whose score is less than the average customer score.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Score
FROM Sales.Customers
WHERE Score < (
      SELECT AVG(Score)
      FROM Sales.Customers
);

/*
  Q4 Display orders whose sales are greater than the maximum sales value.
*/
SELECT *
FROM Sales.Orders
WHERE Sales > (
      SELECT MAX(Sales)
      FROM Sales.Orders
);

/*
Think about the logic.

Suppose the maximum sale is 100.

Can any sale be greater than 100?

No.

So this query will always return 0 rows.

If the question literally says:

Display orders whose sales are greater than the maximum sales value.

then the correct SQL is actually what you wrote—but the question itself is logically impossible.

Usually interviewers ask one of these instead:

WHERE Sales =
(
    SELECT MAX(Sales)
    FROM Sales.Orders
)

or

greater than the average sales
*/
SELECT *
FROM Sales.Orders
WHERE Sales = (
      SELECT MAX(Sales)
      FROM Sales.Orders
);


/*
  Q5 Display employees whose salary is equal to the highest salary.
*/
SELECT *
FROM Sales.Employees
WHERE Salary = (
      SELECT MAX(Salary)
      FROM Sales.Employees
);

/*
  Q6 Display products whose price is equal to the minimum product price.
*/
SELECT *
FROM Sales.Products
WHERE Price = (
      SELECT MIN(Price)
      FROM Sales.Products
);

/*
  Q7 Display customers whose score is equal to the highest customer score.
*/
SELECT *
FROM Sales.Customers
WHERE Score = (
      SELECT MAX(Score)
      FROM Sales.Customers
);

/*
  Q8 Display orders whose sales are less than the average sales.
*/
SELECT *
FROM Sales.Orders
WHERE Sales < (
      SELECT AVG(Sales)
      FROM Sales.Orders
);

/*
  Q9 Display employees earning less than the company average salary.
*/
SELECT *
FROM Sales.Employees
WHERE Salary < (
      SELECT AVG(Salary)
      FROM Sales.Employees
);

/*
  Q10 Display products priced above the overall average product price.
*/
SELECT *
FROM Sales.Products
WHERE Price > (
      SELECT AVG(Price)
      FROM Sales.Products
);


/********* Pattern 3 — Table Subquery with IN *********
Clue Words

belongs to

one of

any of the list

matching values from another query

Think

IN (SELECT ...)

*/

/* Q16 Display orders placed by customers from USA. */
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
      SELECT CustomerID
      FROM Sales.Customers
      WHERE Country = 'USA'
);



/* Q17 Display orders handled by employees in the Sales department. */
SELECT *
FROM Sales.Orders
WHERE SalesPersonID IN (
      SELECT EmployeeID
      FROM Sales.Employees
      WHERE Department = 'Sales'
);


/* Q18 Display products ordered by customers from Germany. */
SELECT *
FROM Sales.Products
WHERE ProductID IN (
      SELECT ProductID
      FROM Sales.Orders
      WHERE CustomerID IN (
            SELECT CustomerID
            FROM Sales.Customers
            WHERE Country = 'Germany'
      )
);


/* Q19 Display employees who handled orders containing Clothing products. */
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


/* Q20 Display customers who have placed at least one order. */
SELECT *
FROM Sales.Customers
WHERE CustomerID IN (
      SELECT CustomerID
      FROM Sales.Orders
      GROUP BY CustomerID
      HAVING COUNT(*) >= 1
);

/*
This works.

But the GROUP BY and HAVING are unnecessary.

Much simpler:

SELECT *
FROM Sales.Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Sales.Orders
);

Whenever you see:

"has at least one"

and you're using IN, the existence of a row is enough.
*/
SELECT *
FROM Sales.Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Sales.Orders
);


/* Q21 Display products that have been ordered. */
SELECT *
FROM Sales.Products
WHERE ProductID IN (
      SELECT ProductID
      FROM Sales.Orders
);



/* Q22 Display countries having customers with score greater than 700. */
SELECT Country
FROM Sales.Customers
WHERE Score > 700;


/*
Question:

Display countries having customers with score greater than 700.

You wrote:

SELECT Country
FROM Sales.Customers
WHERE Score > 700;

This returns the correct data.

However, the exercise was in the IN Subquery pattern.

A subquery-based version could be:

SELECT DISTINCT Country
FROM Sales.Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Sales.Customers
    WHERE Score > 700
);

Or even more realistically:

SELECT DISTINCT Country
FROM Sales.Customers
WHERE Country IN
(
    SELECT Country
    FROM Sales.Customers
    WHERE Score > 700
);

Would I write this in production? No. Your version is actually better.
*/
SELECT DISTINCT Country
FROM Sales.Customers
WHERE CustomerID IN (
      SELECT CustomerID 
      FROM Sales.Customers
      WHERE Score > 700
);


/* Q23 Display employees who sold products priced above 25. */
SELECT *
FROM Sales.Employees
WHERE EmployeeID IN (
      SELECT SalesPersonID
      FROM Sales.Orders
      WHERE ProductID IN (
            SELECT ProductID
            FROM Sales.Products
            WHERE Price > 25
      )
);



/* Q24 Display customers who purchased Accessories products. */
SELECT *
FROM Sales.Customers
WHERE CustomerID IN (
      SELECT CustomerID
      FROM Sales.Orders
      WHERE ProductID IN (
            SELECT ProductID 
            FROM Sales.Products
            WHERE Category = 'Accessories'
      )
);


/* Q25 Display products purchased by USA customers. */
SELECT *
FROM Sales.Products
WHERE ProductID IN (
      SELECT ProductID
      FROM Sales.Orders
      WHERE CustomerID IN (
            SELECT CustomerID
            FROM Sales.Customers
            WHERE Country = 'USA'
      )
);

/********** Pattern 5 — EXISTS / NOT EXISTS (Interview Favorite) **********
Clue Words

has
has not
never
without
at least one
no matching rows

Think

EXISTS (SELECT 1 ...)
NOT EXISTS (SELECT 1 ...)
*/

/*
Q36 Display customers who have placed at least one order.
*/
SELECT *
FROM Sales.Customers
WHERE CustomerID IN (
      SELECT CustomerID
      FROM Sales.Orders
);

SELECT *
FROM Sales.Customers AS c
WHERE EXISTS (
      SELECT 1 
      FROM Sales.Orders AS o
      WHERE c.CustomerID = o.CustomerID
);

/*
Q37 Display customers who have never placed an order.
*/
SELECT *
FROM Sales.Customers AS c
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE c.CustomerID = o.CustomerID
);


/*
Q38 Display products that have been sold.
*/
SELECT *
FROM Sales.Products AS p
WHERE EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE p.ProductID = o.ProductID
);


/*
Q39 Display products never ordered.
*/
SELECT *
FROM Sales.Products AS p
WHERE NOT EXISTS (
      SELECT 1 
      FROM Sales.Orders AS o
      WHERE p.ProductID = o.ProductID
);


/*
Q40 Display employees who handled at least one order.
*/
SELECT *
FROM Sales.Employees AS e
WHERE EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE e.EmployeeID = o.SalesPersonID
);


/*
Q41 Display employees who never handled any order.
*/
SELECT *
FROM Sales.Employees AS e
WHERE NOT EXISTS (
      SELECT 1 
      FROM Sales.Orders AS o
      WHERE e.EmployeeID = o.SalesPersonID
);


/*
Q42 Display countries having at least one customer with score above 700.
*/
SELECT DISTINCT Country
FROM Sales.Customers
WHERE Score > 700;

SELECT DISTINCT Country
FROM Sales.Customers AS c1
WHERE EXISTS (
      SELECT 1
      FROM Sales.Customers AS c2
      WHERE c2.Score > 700 AND c1.CustomerID = c2.CustomerID
);
/*
This works.

But notice what you're checking.

You're checking the same customer.

The EXISTS doesn't add any value.

It's equivalent to

WHERE Score>700
*/

SELECT DISTINCT Country
FROM Sales.Customers
WHERE CustomerID IN (
      SELECT CustomerID
      FROM Sales.Customers
      WHERE Score > 700
);

/*
Same issue.
Again you're comparing the table to itself.
*/


/*
Q43 Display product categories having at least one order.
*/
SELECT DISTINCT Category
FROM Sales.Products AS p
WHERE EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE p.ProductID = o.ProductID
);


/*
Q44 Display customers who purchased Clothing products.
*/
SELECT *
FROM Sales.Customers AS c
WHERE EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE c.CustomerID = o.CustomerID 
      AND o.ProductID IN (
            SELECT ProductID
            FROM Sales.Products
            WHERE Category = 'Clothing'
      )
);


/*
Q45 Display employees who sold products priced above 25.
*/
SELECT *
FROM Sales.Employees AS e
WHERE EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE e.EmployeeID = o.SalesPersonID
      AND o.ProductID IN (
          SELECT ProductID
          FROM Sales.Products 
          WHERE Price > 25
      )
);


/******************  Pattern 6 — Correlated Subquery (Most Important) ******************
Clue Words

within department
within category
for each
same department
same category
same customer
own country
Think

WHERE value > (
    SELECT AVG(...)
    WHERE inner.col = outer.col
)
*/

/*
Q46 Display employees earning above the average salary of their department.
*/
SELECT *
FROM Sales.Employees AS e1
WHERE Salary > (
      SELECT AVG(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);


/*
Q47 Display products priced above the average price of their category.
*/
SELECT *
FROM Sales.Products AS p1
WHERE Price > (
      SELECT AVG(Price)
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);



/*
Q48 Display customers whose score is above the average score of their country.
*/
SELECT *
FROM Sales.Customers AS c1
WHERE Score > (
      SELECT AVG(Score)
      FROM Sales.Customers AS c2
      WHERE c1.Country = c2.Country
);



/*
Q49 Display orders whose sales are above the average sales of the same customer.
*/
SELECT *
FROM Sales.Orders AS o1 
WHERE Sales > (
      SELECT AVG(Sales) 
      FROM Sales.Orders AS o2
      WHERE o1.CustomerID = o2.CustomerID
);

/*
Q50 Display employees having the highest salary in their department.
*/
SELECT *
FROM Sales.Employees AS e1
WHERE Salary = (
      SELECT MAX(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);



/*
Q51 Display products with the highest price in their category.
*/
SELECT *
FROM Sales.Products AS p1
WHERE Price = (
      SELECT MAX(Price)
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);


/*
Q52 Display customers with the highest score in each country.
*/
SELECT *
FROM Sales.Customers AS c1
WHERE Score = (
      SELECT MAX(Score)
      FROM Sales.Customers AS c2
      WHERE c1.Country = c2.Country
);


/*
Q53 Display employees earning below the department average.
*/
SELECT *
FROM Sales.Employees AS e1
WHERE Salary < (
      SELECT AVG(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);


/*
Q54 Display products cheaper than the average price of their category.
*/
SELECT *
FROM Sales.Products AS p1
WHERE Price < (
      SELECT AVG(Price) 
      FROM Sales.Products AS p2
      WHERE p1.Category = p2.Category
);


/*
Q55 Display orders having the maximum sales for each customer.
*/
SELECT *
FROM Sales.Orders AS o1
WHERE Sales = (
      SELECT MAX(Sales)
      FROM Sales.Orders AS o2
      WHERE o1.CustomerID = o2.CustomerID
);


/*
Pattern 7 — Subquery in SELECT
Clue Words

display along with
include average
include total
show overall value in every row

Think

SELECT col,
       (SELECT AVG(...)) AS AvgValue
FROM table;
*/

/*
Q56 Display every employee along with the average company salary.
*/
SELECT *,
       (SELECT AVG(Salary) FROM Sales.Employees) AS AverageSalary
FROM Sales.Employees;

SELECT *,
       AVG(Salary) OVER() AS AverageSalary
FROM Sales.Employees;

/*
Q57 Display every product along with the average product price.
*/
SELECT *,
       (SELECT AVG(Price) FROM Sales.Products) AS AveragePrice
FROM Sales.Products;

SELECT *,
       AVG(Price) OVER() AS AveragePrice
FROM Sales.Products;

/*
Q58 Display every customer along with the total number of customers.
*/
SELECT *,
       (SELECT COUNT(*) FROM Sales.Customers) AS TotalCustomers
FROM Sales.Customers;

SELECT *,
       COUNT(CustomerID) OVER() AS TotalCustomer
FROM Sales.Customers;

/*
Q59 Display every order along with the maximum sales amount.
*/
SELECT *,
       (SELECT MAX(Sales) FROM Sales.Orders) AS MaxSales
FROM Sales.Orders;

SELECT *,
       MAX(Sales) OVER() AS MaximumSales
FROM Sales.Orders;

/*
Q60 Display every employee along with the highest salary.
*/
SELECT *,
       (SELECT MAX(Salary) FROM Sales.Employees) AS HighestSalary
FROM Sales.Employees;

SELECT *,
       MAX(Salary) OVER() AS HighestSalary
FROM Sales.Employees;



/********************** Pattern 8 — Subquery in FROM (Derived Table) ****************************
Clue Words

after calculating
based on total
aggregated result
summary report
classify aggregated data

Think

FROM (
    SELECT ...
    GROUP BY ...
) AS T

*/
/*
Q61 Display customer total sales and classify them as Premium/Regular.
*/
SELECT CustomerID,
       TotalSales,
       CASE WHEN TotalSales > 100 THEN 'Premium'
            ELSE 'Regular'
       END AS SalesClassification
FROM (
    SELECT CustomerID,
           SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS t;



/*
Q62 Display department total salary and classify High/Low.
*/
SELECT Department,
       TotalSalary,
       CASE WHEN TotalSalary > 100000 THEN 'High'
       ELSE 'Low'
       END AS SalaryStatus
FROM (
SELECT Department,
       SUM(Salary) AS TotalSalary
FROM Sales.Employees
GROUP BY Department
) AS t;


/*
Q63 Display category revenue and classify High/Medium/Low.
*/
SELECT ProductCategory,
       TotalRevenue,
       CASE WHEN TotalRevenue > 200 THEN 'High'
            WHEN TotalRevenue <= 200 AND TotalRevenue > 100 THEN 'Medium'
            ELSE 'Low'
       END AS TotalRevenueCategory
FROM (
SELECT p.Category AS ProductCategory,
       SUM(o.Sales) AS TotalRevenue
FROM Sales.Products AS p
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.Category
) AS t;




/*
Q64 Display monthly revenue and classify Best/Average.
*/
SELECT MonthName,
       TotalSales,
       CASE WHEN TotalSales > 100 THEN 'Best'
            ELSE 'Average'
       END AS SalesClassification
FROM (
    SELECT DATENAME(month, OrderDate) AS MonthName,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY DATENAME(month, OrderDate)
) AS t;



/*
Q65 Display salesperson revenue and classify Top Performer/Needs Improvement.
*/
SELECT SalesPersonID,
       TotalRevenue,
       CASE WHEN TotalRevenue > 100 THEN 'Top Performer'
            ELSE 'Needs Improvement'
       END AS RevenuePerformance
FROM (
    SELECT SalesPersonID,
           SUM(Sales) AS TotalRevenue
    FROM Sales.Orders
    GROUP BY SalesPersonID
) AS t;



/************** Pattern 2 — Row Subquery (Multiple Columns) **************

Clue Words
same as
matching pair
compare multiple columns
same customer and product

Think
WHERE (col1, col2) = (SELECT col1, col2 ...)

*/
/*
Q11 Display orders having the same (CustomerID, ProductID) as OrderID = 1.
*/
SELECT *
FROM Sales.Orders
WHERE CustomerID = (SELECT CustomerID
                    FROM Sales.Orders
                    WHERE OrderID = 1
      )

AND ProductID = (SELECT ProductID 
                 FROM Sales.Orders
                 WHERE OrderID = 1
    );



/*
Q12 Display employees having the same (Department, Salary) as EmployeeID = 3.
*/
SELECT *
FROM Sales.Employees
WHERE Department = (SELECT Department FROM Sales.Employees WHERE EmployeeID = 3)
AND Salary = (SELECT Salary FROM Sales.Employees WHERE EmployeeID = 3);


/*
Q13 Display products having the same (Category, Price) as ProductID = 104.
*/
SELECT *
FROM Sales.Products
WHERE Category = (SELECT Category FROM Sales.Products WHERE ProductID = 104)
AND Price = (SELECT Price FROM Sales.Products WHERE ProductID = 104);


/*
Q14 Display customers having the same (Country, Score) as CustomerID = 2.
*/
SELECT *
FROM Sales.Customers
WHERE Country = (SELECT Country FROM Sales.Customers WHERE CustomerID = 2)
AND Score = (SELECT Score FROM Sales.Customers WHERE CustomerID = 2);


/*
Q15 Display orders having the same (SalesPersonID, Quantity) as OrderID = 5.
*/
SELECT *
FROM Sales.Orders
WHERE SalesPersonID = (SELECT SalesPersonID FROM Sales.Orders WHERE OrderID = 5)
AND Quantity = (SELECT Quantity FROM Sales.Orders WHERE OrderID = 5);



/*************** Pattern 4 — ANY / ALL *****************
Clue Words

greater than ANY
greater than ALL
smaller than every
compare against every value

Think
> ANY (SELECT ...)
> ALL (SELECT ...)
< ANY (SELECT ...)
< ALL (SELECT ...)
*/
/*
Q26 Display products priced higher than ANY Clothing product.
*/
SELECT *
FROM Sales.Products
WHERE Price > ANY (SELECT Price
                  FROM Sales.Products
                  WHERE Category = 'Clothing'
);

/*
Q27 Display employees earning more than ALL Marketing employees.
*/
SELECT *
FROM Sales.Employees
WHERE Salary > ALL (
      SELECT Salary
      FROM Sales.Employees
      WHERE Department = 'Marketing'
);


/*
Q28 Display customers whose score is greater than ALL customers from Germany.
*/
SELECT *
FROM Sales.Customers
WHERE Score > ALL (
      SELECT Score
      FROM Sales.Customers
      WHERE Country = 'Germany'
);


/*
Q29 Display orders whose sales exceed ANY order made in February.
*/
SELECT *
FROM Sales.Orders
WHERE Sales > ANY (
      SELECT Sales
      FROM Sales.Orders
      WHERE DATENAME(month, OrderDate) = 'February'
);


/*
Q30 Display products cheaper than ALL Clothing products.
*/
SELECT *
FROM Sales.Products
WHERE Price < ALL (
      SELECT Price
      FROM Sales.Products
      WHERE Category = 'Clothing'
);


/*
Q31 Display employees earning less than ANY Sales employee.
*/
SELECT *
FROM Sales.Employees
WHERE Salary < ANY (
      SELECT Salary
      FROM Sales.Employees
      WHERE Department = 'Sales'
);


/*
Q32 Display customers whose score is lower than ALL USA customers.
*/
SELECT *
FROM Sales.Customers
WHERE Score < ALL (
      SELECT Score
      FROM Sales.Customers
      WHERE Country = 'USA'
);


/*
Q33 Display products costing more than ALL Accessories products.
*/
SELECT *
FROM Sales.Products
WHERE Price > ALL (
      SELECT Price
      FROM Sales.Products
      WHERE Category = 'Accessories'
);


/*
Q34 Display employees earning more than ANY employee in Marketing.
*/
SELECT *
FROM Sales.Employees
WHERE Salary > ANY (
      SELECT Salary
      FROM Sales.Employees
      WHERE Department = 'Marketing'
);

/*
Q35 Display orders with sales greater than ALL orders of CustomerID = 3.
*/
SELECT *
FROM Sales.Orders
WHERE Sales > ALL (
      SELECT Sales 
      FROM Sales.Orders
      WHERE CustomerID = 3
);