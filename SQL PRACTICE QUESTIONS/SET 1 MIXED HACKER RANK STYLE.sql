/************** Set 1 — Medium ***************/

USE SalesDB;

/*
Q1. Employees above department average

Display employees whose salary is greater than the average salary of their own department.

Output:

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
Q2. Customers with no orders

Display customers who have never placed an order.

Output:

CustomerID
FirstName
LastName
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;



/*
Q3. Top 3 employees in each department

Display the 3 highest-paid employees from every department.

If salaries are tied, return all employees sharing the relevant rank.

Output:

Department
EmployeeID
EmployeeName
Salary
*/
WITH CTE_Employees AS (
    SELECT Department,
           EmployeeID,
           Firstname,
           LastName,
           Salary,
           RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
)
SELECT Department,
       EmployeeID,
       Firstname,
       LastName,
       Salary
FROM CTE_Employees
WHERE SalaryRank <= 3;


/*
Q4. Customer sales summary

Display every customer with:

CustomerID
CustomerName
NumberOfOrders
TotalSales
AverageOrderValue

Only include customers whose TotalSales > 100.
*/
WITH CTE_CustomerOrders AS (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           COUNT(o.OrderID) AS NumberOfOrders,
           SUM(o.Sales) AS TotalSales,
           AVG(o.Sales) AS AverageOrderValue
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT CustomerID,
       FirstName,
       LastName,
       NumberOfOrders,
       TotalSales,
       AverageOrderValue
FROM CTE_CustomerOrders
WHERE TotalSales > 100;

/*
Senior Analyst observation

You could also solve this without a CTE:

GROUP BY ...
HAVING SUM(o.Sales) > 100

But because this was mixed practice, your CTE solution is perfectly valid.
*/
SELECT c.CustomerID,
        c.FirstName,
        c.LastName,
        COUNT(o.OrderID) AS NumberOfOrders,
        SUM(o.Sales) AS TotalSales,
        AVG(o.Sales) AS AverageOrderValue
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > 100;



/*
Q5. Products above category average

Display products whose price is greater than the average price of products in their category.

Output:
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
           Price
    FROM Sales.Products AS p1
    WHERE Price > (
          SELECT AVG(Price) AS CategoryAveragePrice
          FROM Sales.Products AS p2
          WHERE p1.Category = p2.Category
    )
)
SELECT ProductID,
       Product,
       Category,
       Price,
       AVG(Price) OVER() AS CategoryAveragePrice
FROM CTE_Products;

/*
This is where I want you to slow down.

Your filtering logic is actually correct:

WHERE Price > (
    SELECT AVG(Price)
    FROM Sales.Products AS p2
    WHERE p1.Category = p2.Category
)

So you've correctly identified:

"average of products in their category"

as a correlated subquery.

The problem is this part:
AVG(Price) OVER() AS CategoryAveragePrice

This does NOT calculate the category average.

It calculates:

average price of all products remaining in the CTE.

You filtered the products first, so the CTE now contains only products whose price is above their category average.

Then:

AVG(Price) OVER()

calculates one average across all those filtered products.

That's not what the output asks for.
*/
WITH CTE_Products AS (
    SELECT ProductID,
           Product,
           Category,
           Price,
           AVG(Price) OVER(PARTITION BY Category) AS CategoryAveragePrice
    FROM Sales.Products
)
SELECT ProductID,
       Product,
       Category,
       Price,
       CategoryAveragePrice
FROM CTE_Products
WHERE Price > CategoryAveragePrice;


/********** Set 2 — Medium+ ***********/
/*
Q6. Latest order per customer

Display the latest order placed by every customer.

If a customer has multiple orders on the latest date, return all of them.

Output:

CustomerID
OrderID
OrderDate
Sales
*/
-- APPROACH 1
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

-- APPROACH 2
WITH CTE_CustomerOrders AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
)
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales
FROM CTE_CustomerOrders
WHERE OrderDateRank = 1;

/*
Your RANK() solution is exactly right.

RANK() OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate DESC
)

Because the question explicitly says:

If multiple orders have the same latest date, return all of them.

RANK() is appropriate.

If the data is:

Customer  OrderDate
1         2026-08-10
1         2026-08-10
1         2026-08-05

both August 10 orders get rank 1.

Important distinction

If the question said:

Return exactly one latest order

then ROW_NUMBER() would generally be preferable.
*/


/*
Q7. Previous order sales

Display every order with:

OrderID
OrderDate
Sales
PreviousOrderSales
SalesDifference

Compare each order with the previous order chronologically.
*/
WITH CTE_Orders AS (
    SELECT OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousOrderSales
    FROM Sales.Orders
)
SELECT OrderID,
       OrderDate,
       Sales,
       PreviousOrderSales,
       Sales - PreviousOrderSales AS SalesDifference
FROM CTE_Orders;

/*
One small interview consideration

If multiple orders can have the exact same OrderDate, consider adding a deterministic tie-breaker:

LAG(Sales) OVER(
    ORDER BY OrderDate, OrderID
)

That makes the ordering unambiguous.

But with the given requirement, your solution is correct.
*/

/*
Q8. Previous order for each customer

For every customer, display:

CustomerID
OrderID
OrderDate
PreviousOrderDate
DaysBetweenOrders

The first order of each customer should have NULL as PreviousOrderDate.
*/
WITH CTE_Orders AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
    FROM Sales.Orders
)
SELECT CustomerID,
       OrderID,
       OrderDate,
       PreviousOrderDate,
       DATEDIFF(day, PreviousOrderDate, OrderDate) AS DaysBetweenOrders
FROM CTE_Orders;



/*
Q9. Second-highest salary per department

Display employees earning the second-highest salary in their department.

If multiple employees have the same second-highest salary, return all of them.
*/
SELECT  EmployeeID,
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
WHERE SalaryRank = 2;

/*
You correctly recognized:

second-highest + ties → RANK()

RANK() OVER(
    PARTITION BY Department
    ORDER BY Salary DESC
)

Then:

WHERE SalaryRank = 2

Exactly right.

Why not ROW_NUMBER()?

Suppose:

Department   Salary
Sales        100000
Sales         90000
Sales         90000
Sales         80000

RANK():

100000 → 1
90000  → 2
90000  → 2
80000  → 4

So both 90,000 employees are returned.

That's exactly what the question asks.
*/


/*
Q10. Customers above average customer total

First calculate total sales for every customer.

Then calculate the average of those customer totals.

Return customers whose total sales are above that average.

Output:

CustomerID
CustomerName
TotalSales
*/
WITH CTE_CustomerTotals AS (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
),
CTE_CustomerTotalsAverage AS (
   SELECT *,
          AVG(TotalSales) OVER() AS AverageCustomerTotals
   FROM CTE_CustomerTotals
)
SELECT *
FROM CTE_CustomerTotalsAverage
WHERE TotalSales > AverageCustomerTotals;


/*
You correctly separated the problem into two logical levels.

Level 1

Calculate each customer's total:

SUM(o.Sales) AS TotalSales
Level 2

Calculate the average of those customer totals:

AVG(TotalSales) OVER()
Level 3

Compare:

WHERE TotalSales > AverageCustomerTotals

That's an excellent CTE pattern:

Orders
   ↓
Customer totals
   ↓
Average of customer totals
   ↓
Compare customers

And this is an important distinction from:

AVG(o.Sales)

because the question asks for:

average customer total

not:

average individual order.

You correctly understood that.
*/


