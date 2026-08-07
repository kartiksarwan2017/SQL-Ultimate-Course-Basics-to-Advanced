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



