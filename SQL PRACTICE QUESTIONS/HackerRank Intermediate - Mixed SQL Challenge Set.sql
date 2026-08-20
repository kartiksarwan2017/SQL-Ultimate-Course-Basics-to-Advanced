/************** HackerRank Intermediate — Mixed SQL Challenge Set ***************/
USE SalesDB;


/*
Q1 — Customer Sales Threshold
Display customers whose total sales exceed 250.

Return:
CustomerID
TotalSales
NumberOfOrders
*/
SELECT CustomerID,
       TotalSales,
       NumberOfOrders
FROM (
    SELECT CustomerID,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS NumberOfOrders
    FROM Sales.Orders
    GROUP BY CustomerID
) t
WHERE TotalSales > 250;

/*
One small improvement to Q1
Your solution works, but you don't need the derived table:
*/

SELECT CustomerID,
       SUM(Sales) AS TotalSales,
       COUNT(OrderID) AS NumberOfOrders
FROM Sales.Orders
GROUP BY CustomerID
HAVING SUM(Sales) > 250;


/*
Q2 — Employee Department Comparison

Display every employee with:

EmployeeID
FirstName
Department
Salary
DepartmentAverageSalary
SalaryDifference

SalaryDifference should show how much the employee's salary differs from the department average.
*/
SELECT EmployeeID,
       FirstName,
       Department,
       Salary,
       DepartmentAverageSalary,
       Salary - DepartmentAverageSalary AS SalaryDifference
FROM (
    SELECT EmployeeID,
           FirstName,
           Department,
           Salary,
           AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary
    FROM Sales.Employees
) t;


/*
Q3 — Second-Largest Order

Display the second-highest order by Sales from the entire company.

If multiple orders have the same second-highest sales, return all of them.

Return:

OrderID
CustomerID
OrderDate
Sales
*/
SELECT OrderID,
       CustomerID,
       OrderDate,
       Sales
FROM (
    SELECT OrderID,
           CustomerID,
           OrderDate,
           Sales,
           RANK() OVER(ORDER BY Sales DESC) AS SalesRank
    FROM Sales.Orders
) t
WHERE SalesRank = 2;

/*
Q4 — Customers Without High-Value Orders

Display customers who have placed orders but have never placed an order greater than 500.

Return:

CustomerID
FirstName
LastName
*/
SELECT CustomerID,
       FirstName, 
       LastName
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Customers c
    INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) t
WHERE NOT TotalSales > 500;

/*
The question asks:

Customers who have placed orders but have never placed an order > 500.

You calculated TotalSales and checked whether the total is ≤ 500. Those are different conditions.

For example, a customer with orders 300 + 300 = 600 has never placed an individual order > 500, so they should be included.

A better pattern is:

GROUP BY + HAVING MAX(Sales) <= 500
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID,
         c.FirstName,
         c.LastName
HAVING MAX(o.Sales) <= 500;

/*
Or using NOT EXISTS:
*/

SELECT c.CustomerID,
       c.FirstName,
       c.LastName
FROM Sales.Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM Sales.Orders AS o
    WHERE o.CustomerID = c.CustomerID
)
AND NOT EXISTS (
    SELECT 1
    FROM Sales.Orders AS o
    WHERE o.CustomerID = c.CustomerID
    AND o.Sales > 500
);


/*
Q5 — Top 3 Products by Category

Display the top 3 products in every category based on total sales.

If products have tied sales at the relevant rank, return all tied products.

Return:

Category
ProductID
Product
TotalSales
SalesRank
*/
WITH CTE_ProductTotalSales AS (
    SELECT p.Category,
           p.ProductID,
           p.Product,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Products p
    INNER JOIN Sales.Orders o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.ProductID, p.Product
),
CTE_ProductsRanking AS (
    SELECT *,
           RANK() OVER(PARTITION BY Category ORDER BY TotalSales DESC) AS SalesRank
    FROM CTE_ProductTotalSales
)
SELECT *
FROM CTE_ProductsRanking
WHERE SalesRank <= 3;

/*
Q6 — Previous Customer Order

For every order, display:

CustomerID
OrderID
OrderDate
Sales
PreviousOrderSales
SalesDifference

The previous order must belong to the same customer.
*/
SELECT *,
       Sales - PreviousOrderSales AS SalesDifference
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales
    FROM Sales.Orders
) t;


/*
Q7 — Customers Above Average

Calculate total sales for every customer.

Then calculate the average customer total sales.

Display customers whose total sales are greater than that average.

Return:

CustomerID
TotalSales
AverageCustomerSales
*/
WITH CTE_CustomerTotalSales AS (
    SELECT CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
),
CTE_AverageCustomerSales AS (
    SELECT *, 
           AVG(TotalSales) OVER() AS AverageCustomerSales
    FROM CTE_CustomerTotalSales
)
SELECT *
FROM CTE_AverageCustomerSales
WHERE TotalSales > AverageCustomerSales;


/*
Q8 — Products Above Category Average

Display products whose price is greater than the average price of their own category.

Return:

ProductID
Product
Category
Price
CategoryAveragePrice
*/
WITH CTE_Products AS (
    SELECT ProductID,
           Product,
           Category,
           Price,
           AVG(Price) OVER(PARTITION BY Category) AS CategoryAveragePrice
    FROM Sales.Products
)
SELECT *
FROM CTE_Products
WHERE Price > CategoryAveragePrice;

/*
Q9 — Department Salary Ranking

Display every employee with:

EmployeeID
FirstName
LastName
Department
Salary
SalaryRank

Rank employees within their department from highest salary to lowest.

Ties should receive the same rank.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Sales.Employees;



/*
Q10 — Latest Customer Order

Display the latest order for every customer.

If a customer has multiple orders on the latest date, return all of them.

Return:

CustomerID
OrderID
OrderDate
Sales
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
) t
WHERE OrderDateRank = 1;