/************* Ranking Window Functions — Interview Set 1 *************/
USE SalesDB;
/*
Q1. Top 3 highest-paid employees in each department

Output

Department
EmployeeID
EmployeeName
Salary

Only display the top 3 salaries within every department.

Hint: Ranking + PARTITION BY
*/
SELECT *
FROM (
SELECT EmployeeID,
       Department,
       FirstName,
       LastName,
       Salary,
       RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Sales.Employees
) AS t
WHERE SalaryRank <= 3;


/*
Q2. Latest order placed by every customer

Output

CustomerID
OrderID
OrderDate
Sales
Return only the latest order for every customer.
*/
SELECT *
FROM (
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales,
       RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
FROM Sales.Orders
) AS t
WHERE OrderDateRank = 1;


SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales,
       MAX(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS LatestOrderDate
FROM Sales.Orders;

/*
Your second solution
MAX(OrderDate) OVER(...)

❌ This does not solve the problem.

It only adds the latest date to every row.
*/



/*
Q3. Second most expensive product in every category

Output

Category
Product
Price

If two products share the second highest price, display both.

(Think carefully which ranking function to use.)
*/
SELECT *
FROM (
    SELECT Category,
           Product,
           Price,
           RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
    FROM Sales.Products
) AS t
WHERE PriceRank = 2;


/*
Q4. Highest-selling order handled by every salesperson

Output

SalesPersonID
OrderID
Sales

If multiple orders have the same highest sales, return all of them.
*/
SELECT *
FROM (
    SELECT SalesPersonID,
           OrderID,
           Sales,
           RANK() OVER(PARTITION BY SalesPersonID ORDER BY Sales DESC) AS SalesRanking
    FROM Sales.Orders
) AS t
WHERE SalesRanking = 1;


/*
Q5. Rank customers based on their total sales

Output

CustomerID
CustomerName
TotalSales
CustomerRank

Customers with the same total sales should receive the same rank.

(Requires GROUP BY before ranking.)
*/
SELECT *,
       RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
FROM (
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS t;


/*********** Interview Set 2 (Medium) *************/
/*
Q6. Bottom 2 products in every category based on price

Output
Category
Product
Price
*/
SELECT *
FROM (
SELECT  ProductID,
        Category,
        Product,
        Price,
        RANK() OVER(PARTITION BY Category ORDER BY Price) AS PriceRank,
        COUNT(*) OVER(PARTITION BY Category) AS TotalProducts
FROM Sales.Products
) AS t
WHERE TotalProducts = PriceRank OR PriceRank = TotalProducts - 1;

/* Here we have to find the bottom 2 products so the rank will be 1 and 2 */
-- CORRECT QUERY 
SELECT *
FROM (
    SELECT *,
           RANK() OVER(
               PARTITION BY Category
               ORDER BY Price
           ) AS PriceRank
    FROM Sales.Products
) t
WHERE PriceRank <= 2;

/*
Q7. Find the employee whose salary is exactly in the middle of the company ranking.

Example:

If there are 11 employees, return Rank = 6.
*/
SELECT *
FROM (
    SELECT  EmployeeID,
            FirstName,
            LastName,
            Department,
            Salary,
            RANK() OVER(ORDER BY Salary DESC) AS SalaryRank,
            COUNT(*) OVER() AS TotalEmployees
    FROM Sales.Employees 
) AS t
WHERE SalaryRank = (1 + TotalEmployees) / 2;

/*
One issue:

You used

RANK()

Imagine salaries

100
90
90
80
70

Ranks become

1
2
2
4
5

Now the middle rank may not exist.

The better function is

ROW_NUMBER()

because it guarantees

1
2
3
4
5

Exactly one middle row.
*/
-- CORRECT QUERY
SELECT *
FROM (
    SELECT  EmployeeID,
            FirstName,
            LastName,
            Department,
            Salary,
            ROW_NUMBER() OVER(ORDER BY Salary DESC) AS SalaryRank,
            COUNT(*) OVER() AS TotalEmployees
    FROM Sales.Employees 
) AS t
WHERE SalaryRank = (1 + TotalEmployees) / 2;


/*
Q8. Top-selling product from each category

Output

Category
Product
TotalSales

(Requires JOIN + GROUP BY + Ranking.)
*/
SELECT *
FROM (
    SELECT p.Category,
           p.Product,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(PARTITION BY p.Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Product, p.Category
) AS t
WHERE SalesRank = 1;


/*
Q9. Third latest order of every customer

Output

CustomerID
OrderID
OrderDate
*/
SELECT *
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
) AS t
WHERE OrderDateRank = 3;

/*
Using

RANK()

is acceptable if ties on OrderDate should all be returned.

If the business means "exactly the third row," then ROW_NUMBER() would be more appropriate.

Since the question doesn't specify, your solution is acceptable.
*/

/*
Q10. Find employees whose salary rank improved after a salary revision.

Imagine you have:

EmployeeSalary_Old
EmployeeSalary_New

Return employees whose new salary rank is better than the old rank.

(Pure ranking logic question.)

I am using LAG to create another salary column since we dont have newsalarycolumn
*/
SELECT *
FROM ( 
    SELECT *,
           RANK() OVER(ORDER BY EmployeeSalary_Old) AS OldSalaryRank,
           RANK() OVER(ORDER BY EmployeeSalary_New) AS NewSalaryRank
    FROM (
            SELECT  EmployeeID,
                    FirstName,
                    LastName,
                    Salary AS Salary,
                    Salary AS EmployeeSalary_Old,
                    LAG(Salary) OVER(ORDER BY Salary) AS EmployeeSalary_New
            FROM Sales.Employees AS e1
    ) t
) x
WHERE NewSalaryRank < OldSalaryRank;

/*************** Interview Set 3 (Advanced) *****************/
/*
Q11. Find the top salesperson in every year.

Output
Year
SalesPerson
TotalSales
*/
SELECT OrderYear,
       SalesPersonID,
       TotalSales
FROM (
    SELECT Year(OrderDate) AS OrderYear,
           SalesPersonID,
           SUM(Sales) AS TotalSales,
           RANK() OVER(PARTITION BY YEAR(OrderDate) ORDER BY SUM(Sales) DESC) AS SalesRank 
    FROM Sales.Orders
    GROUP BY SalesPersonID, Year(OrderDate)
) AS t
WHERE SalesRank = 1;

/*
Your thinking should be:

"Every year" → PARTITION BY Year

This is an important interview pattern.
*/


/*
Q12. Find customers who are in the top 10% based on total sales.

(Think about NTILE() or PERCENT_RANK() depending on the requirement.)
*/
SELECT *
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) AS TotalSales,
           NTILE(10) OVER(ORDER BY SUM(o.Sales) DESC) AS SalesGroup
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) t
WHERE SalesGroup = 1;


/*
Q13. Find the most expensive product in every category without using MAX().
Only ranking functions are allowed.
*/

/*
The question says:

Most expensive product

You used:

SUM(o.Sales)

and ranked by sales.

That's top-selling product, not most expensive product.
*/
SELECT ProductID,
       Product,
       Category,
       TotalSales
FROM (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(PARTITION BY Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Product, p.Category
) t
WHERE SalesRank = 1;


-- CORRECT QUERY
SELECT ProductID,
       Product,
       Category,
       Price
FROM (
SELECT ProductID,
       Product,
       Category,
       Price,
       RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
FROM Sales.Products
) t 
WHERE PriceRank = 1;


/*
Q14. Display employees whose salary rank is higher than their manager's salary rank.

(Self Join + Ranking.)

Manager Salary is not mentioned in the Employees Table
*/
SELECT e1.EmployeeID, 
       e1.FirstName,
       e1.LastName,
       e1.Salary,
       RANK() OVER(ORDER BY e1.Salary DESC) AS SalaryRank
FROM Sales.Employees AS e1
INNER JOIN Sales.Employees AS e2
ON e1.ManagerID = e2.EmployeeID;


/*
Q15. Display the top-selling order for each month.

Output

Month
OrderID
Sales
*/
SELECT OrderYear, 
       OrderMonth,
       OrderID,
       OrderDate,
       Sales
FROM (
    SELECT YEAR(OrderDate) AS OrderYear, 
           MONTH(OrderDate) AS OrderMonth,
           OrderID,
           OrderDate,
           Sales,
           RANK() OVER(PARTITION BY YEAR(OrderDate), MONTH(OrderDate) ORDER BY Sales DESC) AS SalesRank
    FROM Sales.Orders
 ) AS t
 WHERE SalesRank = 1;


/******************** HackerRank Style Challenge *********************/
/*
Q16 Display the top 5 customers based on total sales.
    Return:
    CustomerID
    CustomerName
    TotalSales
    Rank
*/
SELECT *
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) t
WHERE SalesRank <= 5;

/*
One interview consideration

Because you're using RANK(), you can get more than 5 customers if there is a tie.

For example:

1
2
3
4
5
5
5

If the requirement says top 5 customers including ties, your solution is excellent.

If it says exactly 5 customers, use ROW_NUMBER().
*/


/*
Q17 Find the highest-priced product in each category, but return only categories where the highest price is greater than the overall average product price.
*/
SELECT ProductID,
       Product,
       Category,
       Price
FROM (
    SELECT ProductID,
           Product,
           Category,
           Price,
           MAX(Price) OVER(PARTITION BY Category) AS HighestPrice,
           RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
    FROM sales.Products
) t
WHERE PriceRank = 1 AND HighestPrice > (
      SELECT AVG(Price)
      FROM Sales.Products
);


/*
Q18 For each customer, display:
    Latest Order
    Previous Order
    Days Between Orders

    (Requires ROW_NUMBER() + LAG().)
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       o.OrderID,
       o.OrderDate,
       MAX(OrderDate) OVER(PARTITION BY c.CustomerID) AS LatestOrder,
       LAG(OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrder
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID;

/*
This one is partially correct.

You correctly used:

LAG(OrderDate)
OVER(PARTITION BY CustomerID ORDER BY OrderDate)

That gives the previous order date.

But you haven't calculated:

Days Between Orders

And there is another issue.

The question says:

For each customer, display Latest Order, Previous Order, Days Between Orders.

Your query returns every order, not necessarily the customer's latest order.

Better solution

You can use ROW_NUMBER() to identify the latest order:
*/
SELECT CustomerID,
       FirstName,
       LastName,
       OrderID,
       OrderDate AS LatestOrder,
       PreviousOrder,
       DATEDIFF(DAY, PreviousOrder, OrderDate) AS DaysBetweenOrders
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           o.OrderID,
           o.OrderDate,
           LAG(o.OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrder,
           ROW_NUMBER() OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate DESC) AS OrderRank
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
) t
WHERE OrderRank = 1;


/*
Q19 Display the highest-selling product in every category.
    If two products have the same sales, display both.
*/
SELECT ProductID,
       Product,
       Category,
       Sales
FROM (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           o.Sales,
           RANK() OVER(PARTITION BY p.Category ORDER BY o.Sales DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
) t
WHERE SalesRank = 1;


-- CORRECT QUERY
SELECT ProductID,
       Product,
       Category,
       TotalSales
FROM (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(PARTITION BY p.Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Product, p.Category
) t
WHERE SalesRank = 1;


/*
Q20 (Very Common) Display employees whose salary is in the top 20% of the company.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM (
    SELECT EmployeeID,
           FirstName,
           LastName,
           Salary,
           NTILE(5) OVER(ORDER BY Salary DESC) AS SalaryGroup
    FROM Sales.Employees
) t
WHERE SalaryGroup <= 2;

/*
Your solution is good:

NTILE(20) OVER(ORDER BY Salary DESC)

Then:

SalaryGroup <= 2

Conceptually:

100 employees
      ↓
NTILE(20)
      ↓
5 employees per group
      ↓
Group 1 + Group 2
      ↓
Top 10%

But there's an important mathematical point.

If you want top 20%, you would normally use:

NTILE(5)

because:

100%
÷
5 groups
=
20% per group

So:

NTILE(5)

and:

WHERE SalaryGroup = 1

is cleaner.

Your NTILE(20) + first 2 groups also gives approximately 10%, not 20%.

So your approach is logically close, but the percentage mapping is wrong.
*/

-- CORRECT QUERY
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM (
    SELECT EmployeeID,
           FirstName,
           LastName,
           Salary,
           NTILE(5) OVER(ORDER BY Salary DESC) AS SalaryGroup
    FROM Sales.Employees
) t
WHERE SalaryGroup = 1;
