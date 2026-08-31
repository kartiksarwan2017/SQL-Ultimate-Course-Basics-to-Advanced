/************* Set 1 — Mixed Interview Questions ****************/
USE SalesDB;

/*
Q1 — Customer Sales

Display customers who have placed more than 3 orders.

Return:

CustomerID
NumberOfOrders
TotalSales
*/
SELECT *
FROM (
    SELECT CustomerID,
           COUNT(OrderID) AS NumberOfOrders,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t
WHERE NumberOfOrders > 3;

/*
One important improvement

For Q1, because the question says:
customers who have placed more than 3 orders
you can directly use HAVING:
Your solution is still valid. 
But in a HackerRank test, recognizing that a condition on an aggregate after GROUP BY → HAVING will save time.
*/
SELECT CustomerID,
       COUNT(OrderID) AS NumberOfOrders,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;

/*
Q2 — Employee Department Comparison

Display every employee with:

EmployeeID
FirstName
Department
Salary
DepartmentAverageSalary
*/
SELECT EmployeeID,
       FirstName,
       Department,
       Salary,
       AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary
FROM Sales.Employees;


/*
Q3 — Second Highest

Display employees earning the second-highest salary in the company.
If multiple employees have the same salary, return all of them.

Return:
EmployeeID
FirstName
LastName
Salary
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
           RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank = 2;

/*
Q4 — Customers Without Orders

Display customers who have never placed an order.

Return:

CustomerID
FirstName
LastName
*/
SELECT c.CustomerID,
       c.FirstName,
       c.lastName
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


SELECT CustomerID,
       FirstName,
       LastName
FROM Sales.Customers AS c
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o
      WHERE c.CustomerID = o.CustomerID
);

/*
Q5 — Product Category Ranking

Display the top 2 highest-priced products from every category.
If two products have the same price at the relevant rank, return all tied products.

Return:

Category
ProductID
Product
Price
PriceRank
*/
SELECT *
FROM (
    SELECT Category,
           ProductID,
           Product,
           Price,
           RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
    FROM Sales.Products
) t
WHERE PriceRank <= 2;

/*
Q6 — Previous Order

Display every order with:

OrderID
CustomerID
OrderDate
Sales
PreviousOrderSales

PreviousOrderSales must represent the previous order of the same customer, based on OrderDate.
*/
SELECT OrderID,
       CustomerID,
       OrderDate,
       Sales,
       LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales
FROM Sales.Orders;



/*
Q7 — Above Average Customer

Calculate total sales for every customer.

Then display customers whose total sales are greater than the average customer total sales.

Return:

CustomerID
TotalSales
*/
WITH CTE_Customers_Orders AS (
     SELECT CustomerID,
            SUM(Sales) AS TotalSales
     FROM Sales.Orders
     GROUP BY CustomerID
)
SELECT CustomerID,
       TotalSales
FROM CTE_Customers_Orders
WHERE TotalSales > (
      SELECT AVG(TotalSales)
      FROM CTE_Customers_Orders
);


/*
Q8 — Product Price Comparison

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
Q9 — Salesperson Ranking

Calculate total sales for every salesperson.
Then rank salespeople from highest total sales to lowest.
Tied salespeople should receive the same rank.

Return:

SalesPersonID
TotalSales
SalesRank
*/
SELECT SalesPersonID,
       TotalSales,
       RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
FROM (
    SELECT SalesPersonID,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY SalesPersonID
) t;


/*
Q10 — Latest Customer Order

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


/************** Mixed Interview SQL — Set 2: Date Functions *************/
/*
Q1 — Customer Order Gap

Display every customer order with:

CustomerID
OrderID
OrderDate
PreviousOrderDate
DaysBetweenOrders

PreviousOrderDate should be the previous order of the same customer.

DaysBetweenOrders should show the number of days between the current order and previous order.

For the first order of each customer, PreviousOrderDate and DaysBetweenOrders should be NULL.
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       PreviousOrderDate,
       DATEDIFF(day, PreviousOrderDate, OrderDate) AS DaysBetweenOrders
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
    FROM Sales.Orders
) t;



/*
Q2 — Monthly Sales

Display total sales for each month.

Return:

OrderYear
OrderMonth
TotalSales

For example:

2025 | 1 | 12500
2025 | 2 | 18400
2025 | 3 | 16200

Orders from the same month and year should be combined.
*/
SELECT YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate);



/*
Q3 — Employees Hired Recently

Display employees who were hired within the last 2 years from today.

Return:

EmployeeID
FirstName
LastName
HireDate

Use the current date dynamically. Do not hard-code a date.
*/
-- We dont have column hireDate in the database
-- Assuming column HireDate the query would be
WITH CTE_Employees AS (
SELECT EmployeeID,
       FirstName,
       LastName,
       HireDate,
       DATEDIFF(year, HireDate, GETDATE()) AS YearsDifference
FROM Sales.Employees
)
SELECT EmployeeID,
       FirstName,
       LastName,
       HireDate
FROM CTE_Employees
WHERE YearsDifference = 2;

/*
You correctly noticed that your database doesn't have HireDate, so you can't actually test this against your schema.

But assuming HireDate exists, this part is wrong:

WHERE YearsDifference = 2

Why?

DATEDIFF(year, HireDate, GETDATE()) counts year boundaries crossed, not "exactly within the last 2 years."

For example, an employee hired near the end of 2024 could have:

DATEDIFF(year, HireDate, GETDATE()) = 2

even though they might be more than 2 actual years old depending on today's date.

The cleaner approach is:

WHERE HireDate >= DATEADD(year, -2, GETDATE())

So the pattern is:

Date filtering + DATEADD

This is an important interview pattern.
*/
WITH CTE_Employees AS (
    SELECT EmployeeID,
           FirstName,
           LastName,
           HireDate,
           DATEDIFF(year, HireDate, GETDATE()) AS YearsDifference
    FROM Sales.Employees
)
SELECT EmployeeID,
       FirstName,
       LastName,
       HireDate
FROM CTE_Employees
WHERE HireDate >= DATEADD(year, -2, GETDATE());


/*
Q4 — Customer First and Latest Order

For every customer who has placed at least one order, display:

CustomerID
FirstOrderDate
LatestOrderDate
DaysAsCustomer

DaysAsCustomer should represent the number of days between the customer's first and latest order.
*/
WITH CTE_Customer_Orders AS (
    SELECT CustomerID,
           FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
           LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate
    FROM Sales.Orders
)
SELECT *,
       DATEDIFF(day, FirstOrderDate, LatestOrderDate) AS DaysAsCustomer
FROM CTE_Customer_Orders;


/*
Q5 — Orders from Previous Month

Display orders that were placed during the previous calendar month.

Return:

OrderID
CustomerID
OrderDate
Sales

For example, if today is August 21, the query should return orders from July 1 through July 31, not simply the previous 30 days.
*/
SELECT OrderID,
       CustomerID,
       OrderDate,
       Sales
FROM Sales.Orders
WHERE OrderDate >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0)
AND OrderDate < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0);

/*
The important conceptual pattern is:

Current month start
        ↓
DATEADD / DATEDIFF
        ↓
Previous month start
        ↓
Previous month end boundary
Easier way to remember it

For date-range questions, prefer:

>= start_date
AND < next_start_date

rather than trying to construct the last day of the month.
*/


/*
Q6 — Monthly Customer Sales

Display every customer with their sales for each month.

Return:

CustomerID
OrderYear
OrderMonth
TotalSales

Multiple orders from the same customer in the same month should be combined.
*/
SELECT CustomerID,
       YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate);



/*
Q7 — Latest Order + Days Since Order

Display the latest order for every customer.

Return:

CustomerID
OrderID
OrderDate
Sales
DaysSinceLastOrder

DaysSinceLastOrder should calculate the number of days between the latest order date and today.

If multiple orders occurred on the customer's latest date, return all of them.
*/
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
       Sales,
       DATEDIFF(day, OrderDate, GETDATE()) AS DaysSinceLastOrder
FROM CTE_CustomerOrders
WHERE OrderDateRank = 1;

/*
Q8 — Year-over-Year Sales

Calculate total sales for every year.

Return:

OrderYear
TotalSales
PreviousYearSales
SalesDifference

Example:

2024 | 100000 | NULL   | NULL
2025 | 130000 | 100000 | 30000
2026 | 150000 | 130000 | 20000

PreviousYearSales should contain the total sales from the previous year.
*/
WITH CTE_Orders AS (
    SELECT YEAR(OrderDate) AS OrderYear,
           SUM(Sales) AS TotalSales,
           LAG(SUM(Sales)) OVER(ORDER BY YEAR(OrderDate)) AS PreviousYearSales
    FROM Sales.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT *, 
       TotalSales - PreviousYearSales AS SalesDifference
FROM CTE_Orders;


/*
Q9 — Customer Order Number + Date Gap

For every customer order, display:

CustomerID
OrderID
OrderDate
Sales
CustomerOrderNumber
PreviousOrderDate
DaysBetweenOrders

Requirements:

CustomerOrderNumber should be 1, 2, 3... for each customer.
Order number should follow chronological order.
PreviousOrderDate must belong to the same customer.
DaysBetweenOrders should calculate the difference between the two dates.
*/
WITH CTE_Orders AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS CustomerOrderNumber,
           LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
    FROM Sales.Orders
)
SELECT *,
       DATEDIFF(day, PreviousOrderDate, OrderDate) AS DaysBetweenOrders
FROM CTE_Orders;


/*
You have:

ROW_NUMBER() OVER(
    PARTITION BY CustomerID
    ORDER BY OrderID
)

But the question says:

CustomerOrderNumber should follow chronological order.

Therefore your ROW_NUMBER() should use:

ORDER BY OrderDate

not:

ORDER BY OrderID

So:

ROW_NUMBER() OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate
)
Important interview lesson

Whenever the question says:

chronological
according to date
earliest to latest
latest to earliest

your window function should almost always be ordered using the date column.

Your LAG() correctly uses:

ORDER BY OrderDate

So only the ROW_NUMBER() ordering needs changing.
*/

/*
🏆 Q10 — Interview Challenge

For every customer who has placed at least one order, display:

CustomerID
FirstOrderDate
LatestOrderDate
NumberOfOrders
TotalSales
AverageOrderValue
PreviousOrderDate
DaysSinceLatestOrder
CustomerSalesRank

Requirements:

FirstOrderDate → customer's first order.
LatestOrderDate → customer's latest order.
NumberOfOrders → number of orders.
TotalSales → total sales of the customer.
AverageOrderValue → average sales per order.
PreviousOrderDate → previous order date for each order.
DaysSinceLatestOrder → days between latest order and today.
CustomerSalesRank → rank customers based on their total sales, highest first.
Keep one row per order.
*/
WITH CTE_Customers_Orders AS (
    SELECT CustomerID,
           FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
           LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           COUNT(OrderID) OVER(PARTITION BY CustomerID) AS NumberOfOrders,
           SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSales,
           AVG(Sales) OVER(PARTITION BY CustomerID) AS AverageOrderValue,
           LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
    FROM Sales.Orders
),
CTE_CustomerRank AS (
   SELECT *,
          RANK() OVER(ORDER BY TotalSales DESC) AS CustomerSalesRank
   FROM CTE_Customers_Orders
)
SELECT *,
       DATEDIFF(day, LatestOrderDate, GETDATE()) AS DaysSinceLatestOrder
FROM CTE_CustomerRank;



