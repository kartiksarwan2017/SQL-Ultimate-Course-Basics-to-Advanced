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

/*************** Set 3 — Advanced **************/
/*
Q11. Top-selling product in each category

Calculate total sales for every product.

Then return the highest-selling product from each category.

If two products have the same total sales, return both.

Output:

Category
ProductID
Product
TotalSales
*/
WITH CTE_Products AS (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(PARTITION BY p.Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.ProductID,
             p.Product,
             p.Category
)
SELECT ProductID,
       Product,
       Category,
       TotalSales
FROM CTE_Products
WHERE SalesRank = 1;


/*
Q12. Salesperson performance

For every salesperson display:

SalesPersonID
TotalSales
SalesRank

Rank salespeople based on total sales, highest first.

Also classify them:

Top Performer → TotalSales > 200
Average Performer → TotalSales > 100
Needs Improvement → otherwise
*/
SELECT SalesPersonID,
       TotalSales,
       SalesRank,
       CASE WHEN TotalSales > 200 THEN 'Top Performer'
            WHEN TotalSales > 100 THEN 'Average Performer'
            ELSE 'Needs Improvement'
       END AS SalespersonPerformance
FROM (
    SELECT SalesPersonID,
           SUM(Sales) AS TotalSales,
           RANK() OVER(ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM Sales.Orders
    GROUP BY SalesPersonID
) t;


/*
Q13. Highest and lowest order

Display every customer with:

CustomerID
FirstOrderDate
LatestOrderDate
FirstOrderSales
LatestOrderSales

Be careful: first date and first sale are related to the same order, and the same applies to the latest order.
*/
WITH CTE_Orders AS (
    SELECT CustomerID, 
           OrderDate,
           FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
           LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           FIRST_VALUE(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderSales,
           LAST_VALUE(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderSales
    FROM Sales.Orders
)
SELECT *
FROM CTE_Orders
WHERE FirstOrderDate = OrderDate OR LatestOrderDate = OrderDate;

/*
Your idea of using:

FIRST_VALUE()
LAST_VALUE()

is reasonable, but your final filtering:

WHERE FirstOrderDate = OrderDate
   OR LatestOrderDate = OrderDate

can return multiple rows when several orders share the same first/latest date.

More importantly, the question says:

First date and first sale are related to the same order.

The safest approach is to identify the actual first and latest orders, rather than independently filtering by dates.
*/
WITH CTE_Orders AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           ROW_NUMBER() OVER(
               PARTITION BY CustomerID
               ORDER BY OrderDate, OrderID
           ) AS FirstOrderRank,
           ROW_NUMBER() OVER(
               PARTITION BY CustomerID
               ORDER BY OrderDate DESC, OrderID DESC
           ) AS LatestOrderRank
    FROM Sales.Orders
)
SELECT CustomerID,
       MAX(CASE WHEN FirstOrderRank = 1 THEN OrderDate END) AS FirstOrderDate,
       MAX(CASE WHEN LatestOrderRank = 1 THEN OrderDate END) AS LatestOrderDate,
       MAX(CASE WHEN FirstOrderRank = 1 THEN Sales END) AS FirstOrderSales,
       MAX(CASE WHEN LatestOrderRank = 1 THEN Sales END) AS LatestOrderSales
FROM CTE_Orders
GROUP BY CustomerID;


/*
This explicitly establishes:

Customer
   ↓
First actual order
   ↓
FirstOrderDate + FirstOrderSales

and:

Customer
   ↓
Latest actual order
   ↓
LatestOrderDate + LatestOrderSales
Why this is important

Suppose:

Customer  OrderDate    Sales
1         Aug 10       100
1         Aug 10       200

Which is the "first order"?

The date alone doesn't tell us.

That's why adding:

ORDER BY OrderDate, OrderID

gives us a deterministic rule.
*/



/*
Q14. Products never ordered

Display products that have never appeared in Sales.Orders.

Return:

ProductID
Product
Category
Price

Try solving it using two different approaches.
*/
SELECT p.ProductID,
       p.Product,
       p.Category,
       p.Price
FROM Sales.Products AS p
LEFT JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;


SELECT p.ProductID,
       p.Product,
       p.Category,
       p.Price
FROM Sales.Products AS p
LEFT JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
WHERE NOT EXISTS (
      SELECT 1
      FROM Sales.Orders AS o1
      WHERE o1.ProductID = p.ProductID
);

/*
You wrote:

WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders AS o1
    WHERE o1.ProductID = o.ProductID
);

This is incorrect because o.ProductID is from the outer LEFT JOIN.

You want the NOT EXISTS subquery to compare against the outer product:

WHERE o1.ProductID = p.ProductID
Correct NOT EXISTS
SELECT p.ProductID,
       p.Product,
       p.Category,
       p.Price
FROM Sales.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders AS o
    WHERE o.ProductID = p.ProductID
);

That's the classic pattern:

Outer table: Products p
       ↓
Does a matching order exist?
       ↓
NO → return product

So you have demonstrated two different correct approaches once Approach 2 is fixed:

LEFT JOIN + IS NULL
NOT EXISTS
*/



/*
Q15. Orders greater than previous customer order

For every customer, display orders where the current order's sales are greater than that customer's previous order's sales.

Output:

CustomerID
OrderID
OrderDate
Sales
PreviousSales
*/
SELECT *
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales
    FROM Sales.Orders
) t
WHERE Sales > PreviousOrderSales;

/*
Again, for deterministic ordering, if two orders can have the same date, I'd use:

LAG(Sales) OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate, OrderID
)

But your current solution satisfies the stated requirement.
*/
SELECT *
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderSales
    FROM Sales.Orders
) t
WHERE Sales > PreviousOrderSales;


/************** Set 4 — HackerRank-style challenges *************/
/*
Q16. Top 20% employees

Display employees whose salary belongs to the top 20% of company salaries.

Return:

EmployeeID
EmployeeName
Salary

If salaries are tied, consider how your ranking method affects the result.
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
           NTILE(5) OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank <= 2;

/*
Your approach:

NTILE(5) OVER(ORDER BY Salary DESC)

is reasonable if “top 20%” means dividing employees into 5 approximately equal groups.

But the tie requirement matters. NTILE() can split employees with the same salary between groups, so it does not guarantee that tied salaries are kept together.

For an interview, say:

“I would use NTILE(5) when the requirement explicitly means five equal-sized buckets. If ties must be preserved, I would consider PERCENT_RANK() or a rank-based approach.”

So your solution is conceptually acceptable, but clarify the tie behavior.
*/


/*
Q17. Category performance

Calculate total sales for each product category.

Then calculate the average category total sales.

Display only categories whose total sales are greater than the average category total.

Output:

Category
TotalCategorySales
AverageCategorySales
*/
WITH CTE_ProductCategorySales AS (
     SELECT p.Category,
            SUM(o.Sales) AS TotalCategorySales
     FROM Sales.Products AS p
     INNER JOIN Sales.Orders AS o
     ON p.ProductID = o.ProductID
     GROUP BY p.Category
),
CTE_AverageCategoryTotalSales AS (
     SELECT Category,
            TotalCategorySales,
            AVG(TotalCategorySales) OVER() AS AverageCategorySales
     FROM CTE_ProductCategorySales
)
SELECT *
FROM CTE_AverageCategoryTotalSales
WHERE TotalCategorySales > AverageCategorySales;


/*
Q18. Customer purchase behavior

For every customer order, display:

CustomerID
OrderID
OrderDate
Sales
CustomerTotalSales
CustomerAverageSales
PreviousOrderSales
CustomerOrderNumber

You should keep one row per order.
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales,
       AVG(Sales) OVER(PARTITION BY CustomerID) AS CustomerAverageSales,
       LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales,
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS CustomerOrderNumber
FROM Sales.Orders;


/*
Q19. Employees with department salary comparison

Display every employee with:

EmployeeID
EmployeeName
Department
Salary
DepartmentAverageSalary
DepartmentHighestSalary
SalaryDifferenceFromAverage
SalaryRank

Highest salary should receive rank 1.
*/
WITH CTE_Employees AS (
    SELECT EmployeeID,
           FirstName,
           LastName,
           Department,
           Salary,
           AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary,
           MAX(Salary) OVER(PARTITION BY Department) AS DepartmentHighestSalary
    FROM Sales.Employees
) 
SELECT *,
       Salary - DepartmentAverageSalary  AS SalaryDifferenceFromAverage,
       RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM CTE_Employees;


/*
Q20. 🔥 Interview challenge — Complete customer analysis

Display every customer who has placed at least one order.

Return:

CustomerID
CustomerName
FirstOrderDate
LatestOrderDate
NumberOfOrders
TotalSales
AverageOrderValue
HighestOrderValue
PreviousOrderSales
CustomerSalesRank

Rank customers based on their total sales, highest first.
*/
WITH CTE_CustomersOrders AS (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           FIRST_VALUE(o.OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS FirstOrderDate,
           LAST_VALUE(o.OrderDate) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           COUNT(o.OrderID) OVER(PARTITION BY c.CustomerID) AS NumberOfOrders,
           SUM(o.Sales) OVER(PARTITION BY c.CustomerID) AS TotalSales,
           AVG(o.Sales) OVER(PARTITION BY c.CustomerID) AS AverageOrderValue,
           MAX(o.Sales) OVER(PARTITION BY c.CustomerID) AS HighestOrderValue,
           LAG(o.Sales) OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrderSales
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
)
SELECT *,
       RANK() OVER(ORDER BY TotalSales DESC) AS CustomerSalesRank
FROM CTE_CustomersOrders;

/*
Most of your window functions are good:

FIRST_VALUE()
LAST_VALUE()
COUNT()
SUM()
AVG()
MAX()
LAG()

But this is wrong:

RANK() OVER(
    PARTITION BY c.CustomerID
    ORDER BY o.Sales DESC
) AS CustomerSalesRank

That ranks orders within each customer, not customers against other customers.

The requirement is:

Rank customers based on their total sales, highest first.

You need to first calculate customer-level totals, then rank those totals.

For example:

WITH CTE_CustomerAnalysis AS
(
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,

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

           COUNT(o.OrderID) OVER(
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
)
SELECT *,
       RANK() OVER(
           ORDER BY TotalSales DESC
       ) AS CustomerSalesRank
FROM CTE_CustomerAnalysis;

Notice the key idea:

PARTITION BY CustomerID

is used for calculations within a customer.

But:

RANK() OVER(ORDER BY TotalSales DESC)

is used across customers.

That's exactly the kind of distinction HackerRank can test.
*/

