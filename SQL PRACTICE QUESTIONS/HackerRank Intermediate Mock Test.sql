/******************* HackerRank Intermediate Mock Test *******************/
USE SalesDB;

/*
Q1 — Customer Aggregation

Display customers who have placed more than 2 orders.

Return:

CustomerID
NumberOfOrders
TotalSales
*/
SELECT CustomerID,
       COUNT(OrderID) AS NumberOfOrders,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 2;



/*
Q2 — Window Function

Display every order along with:

OrderID
CustomerID
Sales
CustomerTotalSales

Do not reduce the number of rows.
*/
SELECT OrderID,
       CustomerID,
       Sales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
FROM Sales.Orders;



/*
Q3 — Ranking

Display the top 2 highest-paid employees from every department.

If two employees have the same salary at the relevant rank, return both.

Return:

Department
EmployeeID
FirstName
LastName
Salary
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary
FROM (
    SELECT EmployeeID,
           FirstName,
           LastName,
           Department,
           Salary,
           RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank <= 2;

/*
Q4 — Correlated Subquery

Display employees whose salary is greater than the average salary of their own department.

Return:

EmployeeID
FirstName
LastName
Department
Salary
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary
FROM Sales.Employees AS e1
WHERE Salary > (
      SELECT AVG(Salary)
      FROM Sales.Employees AS e2
      WHERE e1.Department = e2.Department
);



/*
Q5 — Previous Row

Display every order with:

OrderID
OrderDate
Sales
PreviousSales
SalesDifference

PreviousSales should represent the previous order chronologically.
*/
SELECT *,
       Sales - PreviousSales AS SalesDifference
FROM (
    SELECT OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSales
    FROM Sales.Orders
) t;




/*
⏱️ Medium
Q6 — Grouped Result + Comparison

Display product categories whose total sales are greater than the average total sales of all categories.

Return:

Category
TotalSales

Important: the average should be calculated from category totals, not individual orders.
*/
WITH CTE_ProductCategory_TotalSales AS (
    SELECT p.Category,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category
)
SELECT Category,
       TotalSales
FROM CTE_ProductCategory_TotalSales
WHERE TotalSales > (
      SELECT AVG(TotalSales)
      FROM CTE_ProductCategory_TotalSales
);



/*
Q7 — Latest Record

Display the latest order for every customer.

If a customer has multiple orders on the same latest date, return all of them.

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


/*
Q8 — ANY

Display products whose price is greater than ANY product in the Clothing category.

Return:

ProductID
Product
Category
Price
*/
SELECT ProductID,
       Product,
       Category,
       Price
FROM Sales.Products
WHERE Price > ANY (
      SELECT Price
      FROM Sales.Products
      WHERE Category = 'Clothing'
);


/*
Q9 — NOT EXISTS

Display products that have never been ordered.

Return:

ProductID
Product
Category
Price

Try to solve this using NOT EXISTS.
*/
SELECT ProductID,
       Product,
       Category,
       Price
FROM Sales.Products AS p
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE o.ProductID = p.ProductID
);


/*
Q10 — Customer Ranking

Calculate total sales for every customer and rank them from highest to lowest.

Return:

CustomerID
TotalSales
CustomerRank

Customers with the same total sales should receive the same rank.
*/
SELECT *,
       RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    SELECT CustomerID,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t;


/*
🔥 Medium-Advanced
Q11 — Customer Order Analysis

For every customer order, display:

CustomerID
OrderID
OrderDate
Sales
PreviousOrderSales
CustomerTotalSales
CustomerOrderNumber

Requirements:

PreviousOrderSales → previous order of that customer
CustomerTotalSales → total sales of that customer
CustomerOrderNumber → 1, 2, 3... according to order date
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales,
       LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales,
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS CustomerOrderNumber
FROM Sales.Orders;

/*
You used:

COUNT(OrderID) OVER(
    PARTITION BY CustomerID 
    ORDER BY OrderDate
) AS CustomerOrderNumber

This can work in simple cases, but the intended interview pattern is:

ROW_NUMBER() OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate
) AS CustomerOrderNumber

Because the requirement explicitly says:

1, 2, 3... according to order date

So:

WITH CTE_CustomerOrders AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(
               PARTITION BY CustomerID
               ORDER BY OrderDate
           ) AS PreviousOrderSales,


           SUM(Sales) OVER(
               PARTITION BY CustomerID
           ) AS CustomerTotalSales,


           ROW_NUMBER() OVER(
               PARTITION BY CustomerID
               ORDER BY OrderDate
           ) AS CustomerOrderNumber
    FROM Sales.Orders
)
SELECT *
FROM CTE_CustomerOrders;
*/



/*
Q12 — Second Highest

Display employees earning the second-highest salary in each department.

If multiple employees share the second-highest salary, return all of them.

Return:

Department
EmployeeID
FirstName
LastName
Salary
*/
SELECT  Department,
        EmployeeID,
        FirstName,
        LastName,
        Salary
FROM (
    SELECT Department,
           EmployeeID,
           FirstName,
           LastName,
           Salary,
           RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank = 2;



/*
Q13 — CTE Challenge

First calculate total sales for every salesperson.

Then classify them:

TotalSales > 200 → Top Performer
TotalSales > 100 → Average Performer
Otherwise → Needs Improvement

Return:

SalesPersonID
TotalSales
Performance

Use a CTE.
*/
WITH CTE_Orders AS (
    SELECT SalesPersonID,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY SalesPersonID
)
SELECT SalesPersonID,
       TotalSales,
       CASE WHEN TotalSales > 200 THEN 'Top Performer'
            WHEN TotalSales > 100 THEN 'Average Performer'
            ELSE 'Needs Improvement'
       END AS Performance
FROM CTE_Orders;


/*
Q14 — Advanced Ranking

Display the top-selling product from every category.

Total sales must be calculated from Sales.Orders.

If two products have the same total sales, return both.

Return:

Category
ProductID
Product
TotalSales
*/
WITH CTE_Products AS (
    SELECT p.Category,
           p.ProductID,
           p.Product,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Orders AS o
    INNER JOIN Sales.Products AS p
    ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.ProductID, p.Product
),
CTE_RankedProducts AS (
   SELECT *,
          RANK() OVER(PARTITION BY Category ORDER BY TotalSales DESC) AS SalesRank
   FROM CTE_Products

)
SELECT Category,
       ProductID,
       Product,
       TotalSales
FROM CTE_RankedProducts
WHERE SalesRank = 1;


/*
🏆 Q15 — Final Interview Challenge

For every customer who has placed at least one order, display:

CustomerID
FirstName
LastName
FirstOrderDate
LatestOrderDate
NumberOfOrders
TotalSales
AverageOrderValue
HighestOrderValue
PreviousOrderSales
CustomerSalesRank

Requirements:

FirstOrderDate → customer's first order
LatestOrderDate → customer's latest order
NumberOfOrders → number of orders
TotalSales → customer's total sales
AverageOrderValue → average order value
HighestOrderValue → highest individual order
PreviousOrderSales → previous order's sales
CustomerSalesRank → rank customers by TotalSales, highest first

Important: Keep one row per order while calculating the window values, but the customer ranking should be based on the customer's total sales, not individual order sales.
*/
WITH CTE_CustomerOrders AS ( 
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           o.OrderID,
           o.OrderDate,
           o.Sales,
           SUM(o.Sales) OVER(PARTITION BY c.CustomerID) AS TotalSales,
           FIRST_VALUE(o.OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS FirstOrderDate,
           LAST_VALUE(o.OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           COUNT(*) OVER(PARTITION BY c.CustomerID) AS NumberOfOrders,
           AVG(o.Sales) OVER(PARTITION BY c.CustomerID) AS AverageOrderValue,
           MAX(o.Sales) OVER(PARTITION BY c.CustomerID) AS HighestOrderValue,
           LAG(o.Sales) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrderSales
    FROM Sales.Orders AS o
    INNER JOIN Sales.Customers AS c
    ON c.CustomerID = o.CustomerID
),
CTE_RankedCustomers AS (
   SELECT *,
          RANK() OVER(ORDER BY TotalSales) AS CustomerSalesRank
   FROM CTE_CustomerOrders
    
)
SELECT CustomerID,
       FirstName,
       LastName,
       FirstOrderDate,
       LatestOrderDate,
       NumberOfOrders,
       TotalSales,
       AverageOrderValue,
       HighestOrderValue,
       PreviousOrderSales,
       CustomerSalesRank
FROM CTE_RankedCustomers;


/*
There are three separate concepts here:

Customer-level window calculations
Order-level LAG
Customer-level ranking

Your current query mixes aggregation and window functions incorrectly.

Also:

LAST_VALUE(...)

needs an appropriate frame:

ROWS BETWEEN UNBOUNDED PRECEDING
         AND UNBOUNDED FOLLOWING

And this:

RANK() OVER(PARTITION BY CustomerID ORDER BY TotalSales)

is not customer ranking. It ranks orders within each customer.

The requirement is:

rank customers based on total sales

So you need to calculate customer totals first, then rank those totals, while preserving the order-level rows.

A clean solution is:

           o.OrderID,
           o.OrderDate,
           o.Sales,


           FIRST_VALUE(o.OrderDate) OVER(
               PARTITION BY c.CustomerID
               ORDER BY o.OrderDate
           ) AS FirstOrderDate,


           LAST_VALUE(o.OrderDate) OVER(
               PARTITION BY c.CustomerID
               ORDER BY o.OrderDate
               ROWS BETWEEN UNBOUNDED PRECEDING
                    AND UNBOUNDED FOLLOWING
           ) AS LatestOrderDate,


           COUNT(*) OVER(
               PARTITION BY c.CustomerID
           ) AS NumberOfOrders,


           SUM(o.Sales) OVER(
               PARTITION BY c.CustomerID
           ) AS TotalSales,


           AVG(o.Sales) OVER(
               PARTITION BY c.CustomerID
           ) AS AverageOrderValue,


           MAX(o.Sales) OVER(
               PARTITION BY c.CustomerID
           ) AS HighestOrderValue,


           LAG(o.Sales) OVER(
               PARTITION BY c.CustomerID
               ORDER BY o.OrderDate
           ) AS PreviousOrderSales


    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
        ON c.CustomerID = o.CustomerID
),
CTE_RankedCustomers AS (
    SELECT *,
           RANK() OVER(
               ORDER BY TotalSales DESC
           ) AS CustomerSalesRank
    FROM CTE_CustomerOrders
)
SELECT CustomerID,
       FirstName,
       LastName,
       FirstOrderDate,
       LatestOrderDate,
       NumberOfOrders,
       TotalSales,
       AverageOrderValue,
       HighestOrderValue,
       PreviousOrderSales,
       CustomerSalesRank
FROM CTE_RankedCustomers;

Notice the critical distinction:

-- Customer-level calculations
SUM(Sales) OVER(PARTITION BY CustomerID)


-- Ranking customers
RANK() OVER(ORDER BY TotalSales DESC)

No PARTITION BY CustomerID in the final ranking.



Your biggest remaining weakness

It's no longer really "I don't know GROUP BY vs Window Function."

You're now making a more advanced mistake:

"I know the correct tools, but sometimes I don't identify what level the calculation belongs to."

For example:

Customer-level
SUM(Sales) OVER(PARTITION BY CustomerID)
Department-level
AVG(Salary) OVER(PARTITION BY Department)
Category-level
RANK() OVER(PARTITION BY Category ORDER BY TotalSales DESC)
Company-level
RANK() OVER(ORDER BY TotalSales DESC)
Previous row within customer
LAG(Sales) OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate
)

This granularity identification is the next thing you should practice
*/