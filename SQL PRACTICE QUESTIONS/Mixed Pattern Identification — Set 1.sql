/************* Mixed Pattern Identification — Set 1 ***************/
USE SalesDB;

/*
Q1 Display every employee along with the average salary of their department.

Return:

EmployeeID
FirstName
Department
Salary
DepartmentAverageSalary

PATTERN: 
WINDOW FUNCTION + PARTITION BY

Why this pattern?
Here we have to provider details of every employee along with AVG of their department
We require detailed row that's why we use Window Function
*/
SELECT EmployeeID,
       FirstName,
       Department, 
       Salary,
       AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary
FROM Sales.Employees;



/*
Q2

Display each department with its total salary.

Return:

Department
TotalSalary

PATTERN: GROUP BY + Aggregation SUM()

Why this pattern?
Here we are using this pattern we require one department per row along with its aggregated total salary.
*/
SELECT Department,
       SUM(Salary) AS TotalSalary
FROM Sales.Employees
GROUP BY Department;


/*
Q3

Display employees whose salary is greater than the average salary of the entire company.

Return:

EmployeeID
FirstName
Salary

PATTERN: SUBQUERY

Why this pattern ?
Here we will be usign subquery to find the average salary of entire company and compare it with the 
Salary of individual employees meet condition

*/
SELECT EmployeeID,
       FirstName,
       Salary
FROM Sales.Employees
WHERE Salary > (
      SELECT AVG(Salary)
      FROM Sales.Employees
);




/*
Q4

Display the top 3 highest-paid employees from every department.

If salaries are tied, return all employees sharing the relevant rank.

PATTERN: RANKING FUNCTION RANK() + derived table to filter te results.

Why this pattern ?
We are using this pattern to RANK() the employees based on their salary
its mentioned in question to return all employees with same rank 
we are using RANK() Function.
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
WHERE SalaryRank <= 3;




/*
Q5

Display every order along with the customer's total sales.

The result must contain one row for every order.

Return:

OrderID
CustomerID
Sales
CustomerTotalSales

PATTERN: WINDOW FUNCTION 
Why this pattern ?
We used this pattern since we require one order per group i.e each row with order details
along with the customer total sales

*/
SELECT OrderID,
       CustomerID,
       Sales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
FROM Sales.Orders;


/*
Q6

Display customers who have never placed an order.

Return:

CustomerID
FirstName
LastName

PATTERN: LEFT ANTI JOIN or NOT EXISTS 

Why this pattern ?
we are having two tables customers, orders. we are performing LEFT ANTI JOIN ot find the customers
who have never ordered any order.

*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
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
Q7

Display the second-highest salary in every department.

If multiple employees have that salary, return all of them.

PATTERN: RANKING FUNCTION

Why this pattern ?
we are using this pattern to find the RANK employees department wise
and use derived table to filter out the ranking result 
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
WHERE SalaryRank = 2;



/*
Q8

Display every order with:

OrderID
OrderDate
Sales
PreviousSales
SalesDifference

PreviousSales should be the previous order chronologically.

PATTERN: LAG() to find previous sales and finding salesdifference using derived table

why this pattern?
LAG() Function finds the previous record data and stores it in the same row so that we can
compare the data row wise
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
Q9

Display customers whose total sales are greater than the average total sales of all customers.

For example:

Customer A → 100
Customer B → 200
Customer C → 300

Average customer total = 200.

Return only customers above 200.

PATTERN: CTE + Subquery

WHy this pattern?
the result of CTE - will compute the TotalSales Per Customer using GROUP BY 
              Subquery to find the average of total sales

*/
WITH CTE_Customer_TotalSales AS (
     SELECT CustomerID,
            SUM(Sales) AS TotalSales
     FROM Sales.Orders
     GROUP BY CustomerID
)
SELECT CustomerID,
       TotalSales
FROM CTE_Customer_TotalSales
WHERE TotalSales > (
      SELECT AVG(TotalSales)
      FROM CTE_Customer_TotalSales
);


/*
Q10 Display products whose price is higher than every Accessories product.

PATTERN: SUBQUERY + ALL

Why this pattern ?
to compare each Price of each product with the every price of Accessories category

*/
SELECT *
FROM Sales.Products
WHERE Price > ALL (
      SELECT Price
      FROM Sales.Products
      WHERE Category = 'Accessories'
);

/*************** Set 2 — More Difficult ***************/
/*
Q11 Display the highest-selling product from every category.
    Total sales should be calculated from Sales.Orders.
    If two products have the same total sales, return both.

Return:
Category
ProductID
Product
TotalSales

Pattern: INNER JOIN + GROUP BY to combine two tables Products and Orders and group by 
         to get each product per row and its total sales.

         THEN use RANK() Function to rank the TotalSales Based on Category 
       
*/
WITH CTE_Products AS (
    SELECT p.Category,
           p.ProductID,
           p.Product,
           SUM(o.Sales) AS TotalSales,
           RANK() OVER(PARTITION BY p.Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.ProductID, p.Product
)
SELECT Category,
       ProductID,
       Product,
       TotalSales
FROM CTE_Products
WHERE SalesRank = 1;


/*
Q12

Display every salesperson with:

SalesPersonID
TotalSales
SalesRank

Rank salespeople from highest total sales to lowest.

Tied salespeople should receive the same rank.

PATTERN:
We can use GROUP BY to get each salesperson per row along with its total Sales using SUM()
Then find the ranking using RANK() function since we have to show tied salesperspm as well. 
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
Q13

Display every customer order with:

CustomerID
OrderID
OrderDate
Sales
PreviousCustomerOrderSales
CustomerOrderNumber

CustomerOrderNumber should be:

1
2
3
...

for each customer based on order date.

PATTERN: 
we can use LAG to get the previous customer order sales with PARTITION BY CustomerID 
ORDER BY OrderDate

we can use ROW_NUMBER() to get the CustomerOrderNumber
*/
SELECT CustomerID,
       OrderID,
       Orderdate,
       Sales,
       LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousCustomerOrderSales,
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS CustomerOrderNumber
FROM Sales.Orders;


/*
Q14

Display products whose price is higher than any Clothing product.

PATTERN:
Non Correlated SubQuery we can use to find the Price of any Clothing Product
using ANY to compare this subquery results with Price of each product from main query
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
Q15

Display every department with:

Department
AverageSalary
HighestSalary
LowestSalary

PATTERN:
Here we have to display the every department USIGN GROUP BY and Aggregation.
*/
SELECT Department, 
       AVG(Salary) AS AverageSalary,
       MAX(Salary) AS HighestSalary,
       MIN(Salary) AS LowestSalary
FROM Sales.Employees
GROUP BY Department;


/*
Q16

Display the latest order of every customer.

If a customer has two orders on the same latest date, return both.

PATTERN: 
Here we could use RANKING Window Function RANK() to find the rank based on OrderDate and find the latest order
with rank as 1.

and display rank 1 customers with thier latest order.

*/
SELECT CustomerID,
       OrderID,
       OrderDate
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
) t
WHERE OrderDateRank = 1;

/*
Q17

Display employees whose salary is greater than every employee in the Marketing department.

PATTERN:
Non correlated subquery + ALL 

we can use non correlated subquery to compute the Salary of employees in Marketing Department
compare the result of this subquery with the Salary of employees from Main query.
*/
SELECT *
FROM Sales.Employees
WHERE Salary > ALL (
      SELECT Salary
      FROM Sales.Employees
      WHERE Department = 'Marketing'
);



/*
Q18

Display products that have never appeared in Sales.Orders.

PATTERN:
LEFT ANTI JOIN to get the products without orders.
or 
NOT EXISTS
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
      WHERE o.ProductID = p.ProductID
);


/*
Q19

Display every employee with:

EmployeeID
Department
Salary
DepartmentAverageSalary
DepartmentHighestSalary
SalaryDifferenceFromAverage
SalaryRank

Highest salary should have rank 1 within each department.

PATTERN:
USE WINDOW FUNCTION + RANKING FUNCTION 

here we are using window function because we require detailed employee details per row along with the 
AVG, MAX Salary per Department

*/
WITH CTE_Employees AS (
    SELECT EmployeeID,
           Department,
           Salary,
           AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary,
           MAX(Salary) OVER(PARTITION BY Department) AS DepartmentHighestSalary,
           RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
)
SELECT *,
       DepartmentAverageSalary - Salary AS SalaryDifferenceFromAverage
FROM CTE_Employees;


/*
Tiny improvement

You wrote:

DepartmentAverageSalary - Salary AS SalaryDifferenceFromAverage

The question doesn't explicitly define the direction of the difference.

Usually I'd use:

Salary - DepartmentAverageSalary

so:

positive = employee is above average
negative = employee is below average

Your calculation is mathematically valid, but the naming SalaryDifferenceFromAverage is more intuitive with:

Salary - DepartmentAverageSalary
*/

/*
Q20

Display product categories whose total sales are greater than the average category total sales.

Important: calculate the average using category totals, not individual orders.

PATTERN:
INNER JOIN + GROUP BY to get category wise total sales
store this result in CTE and compare total sales with avg of total sales outside CTE
*/
WITH CTE_Products AS (
    SELECT p.Category,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category
)
SELECT Category,
       TotalSales
FROM CTE_Products
WHERE TotalSales > (
      SELECT AVG(TotalSales)
      FROM CTE_Products
);


/*************** Set 3 — Interview-Level Pattern Recognition ***************/
/*
Q21

Display every customer who has placed at least one order with:

CustomerID
TotalSales
NumberOfOrders
AverageOrderValue
HighestOrderValue

PATTERN: Use GROUP BY + Aggregation 

we're using group up here to get one customer per group and its aggregation 
*/
SELECT CustomerID,
       SUM(Sales) AS TotalSales,
       COUNT(OrderID) AS NumberOfOrders,
       AVG(Sales) AS AverageOrderValue,
       MAX(Sales) AS HighestOrderValue
FROM Sales.Orders
GROUP BY CustomerID
HAVING COUNT(orderID) >= 1;

/*
Small improvement

Because you're already reading from Sales.Orders, every returned customer necessarily has at least one order.

So:

HAVING COUNT(OrderID) >= 1

is unnecessary.

Your query can simply be:

SELECT CustomerID,
       SUM(Sales) AS TotalSales,
       COUNT(OrderID) AS NumberOfOrders,
       AVG(Sales) AS AverageOrderValue,
       MAX(Sales) AS HighestOrderValue
FROM Sales.Orders
GROUP BY CustomerID;
*/


/*
Q22 Display the top 20% of employees based on salary.
    If salaries are tied, consider which ranking approach is appropriate.

    PATTERN: Using NTILE() to categorise the ranking in form of buckets.
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
           NTILE(5) OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank <= 2;

/*
You identified:

NTILE()

Correct.

But your implementation has an important mistake.

You used:

NTILE(5)

There are 5 buckets:

Bucket 1 → top 20%
Bucket 2 → next 20%
Bucket 3 → next 20%
Bucket 4
Bucket 5

Therefore:

WHERE SalaryRank = 1

would represent the top 20%.

You used:

WHERE SalaryRank <= 2

That gives approximately top 40%, not top 20%.

Correct pattern
NTILE(5) OVER(ORDER BY Salary DESC)

then:

WHERE SalaryRank = 1
Important interview point

NTILE(5) divides rows, not salary values.

So if the question emphasizes:

"If salaries are tied, return everyone tied at the boundary"

then NTILE() may not satisfy that requirement exactly.

You need to think about RANK(), PERCENT_RANK(), or another approach depending on the exact definition of "top 20%."
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
           NTILE(5) OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank = 1;


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
           PERCENT_RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank <= 0.25;



/*
Q23

Display every customer order with:

CustomerID
OrderID
OrderDate
Sales
FirstOrderDate
LatestOrderDate
PreviousOrderDate
CustomerTotalSales

Keep one row per order.

PATTERN: WINDOW FUNCTION + PARTITION BY
         FIRST_VALUE to find FirstOrderDate
         LAST_VALUE to find LatestOrderDate
         LAG to find previous order date
         SUM() Aggregate window function to find CustomerTotalSales
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales,
       FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
       LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
       LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
FROM Sales.Orders;


/*
Q24

Display the most expensive product from every category, but only include 
categories where the highest product price is greater than the overall average product price.

PATTERN: WINDOW FUNCTION + PARTITION BY

we have to use WINDOW FUNCTION here because we require MAX Price along with the Product details per row.
*/
WITH CTE_Products AS (
    SELECT ProductID,
           Product,
           Category,
           Price,
           MAX(Price) OVER(PARTITION BY Category) AS HighestProductPrice
    FROM Sales.Products
)
SELECT ProductID,
       Product,
       Category,
       Price
FROM CTE_Products
WHERE Price = HighestProductPrice 
AND HighestProductPrice > (
    SELECT AVG(Price)
    FROM Sales.Products
);

/*
You identified:

Window Function + PARTITION BY

Correct.

This part is good:

MAX(Price) OVER(PARTITION BY Category)

And then:

WHERE Price = HighestProductPrice

correctly retrieves the product(s) having the maximum price.

The overall-average comparison is also correct.

Important distinction

You don't necessarily need RANK() here because you're asking for:

highest price

rather than explicitly asking for ranking.

Your approach is valid.
*/


/*
Q25

Display customers who purchased both Clothing and Accessories.

A customer may have purchased many products, but must have purchased at least one product from each of these two categories.

PATTERN: GROUP BY + HAVING(COUNT DISTINCT)

*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       COUNT(DISTINCT p.Category) AS NumberOfCategory
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
WHERE p.Category = 'Clothing' OR p.Category = 'Accessories'
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(DISTINCT p.Category) = 2;


/*
Q26

Display employees whose salary is above their department average, and show:

EmployeeID
Department
Salary
DepartmentAverageSalary
SalaryRank

PATTERN: CTE

Earlier thoguth to use correlated query as first solution but later saw we have to dispay the AverageDepartmentSalary
as well WINDOW FUNCTION + CTE is suitable to solve this question

*/
WITH CTE_Employees AS (
    SELECT EmployeeID,
           Department,
           Salary,
           AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary,
           RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
)
SELECT*
FROM CTE_Employees
WHERE Salary > DepartmentAverageSalary;

/*
This is a particularly good observation.

You initially thought about a correlated subquery, but then noticed:

"I also need to display DepartmentAverageSalary."

That is exactly when a window function becomes attractive.

AVG(Salary) OVER(PARTITION BY Department)

Then:

WHERE Salary > DepartmentAverageSalary

You also added:

RANK()

which was required by the question.

Your thought process is improving

You are beginning to recognize:

"I need the aggregate AND the original rows" → Window Function

That's one of the most important distinctions in SQL
*/


/*
Q27

Display the top-selling product in each category, but only consider products whose total sales are 
greater than the overall average product total sales.

PATTERN:
CTE 

*/
WITH CTE_Products AS (
     SELECT p.ProductID,
            p.Product,
            p.Category,
            o.Sales,
            RANK() OVER(PARTITION BY p.Category ORDER BY o.Sales DESC) AS SalesRank,
            SUM(o.Sales) OVER(PARTITION BY p.Category) AS TotalSales
     FROM Sales.Products AS p
     INNER JOIN Sales.Orders AS o
     ON p.ProductID = o.ProductID
),
CTE_Average_TotalSales AS (
    SELECT *,
           AVG(TotalSales) OVER() AS AvgProductTotalSales
    FROM CTE_Products
)
SELECT ProductID,
       Product,
       Category, 
       TotalSales,
       AvgProductTotalSales
FROM CTE_Average_TotalSales
WHERE SalesRank = 1 
AND TotalSales > AvgProductTotalSales;

/*
This is your biggest mistake in this set.

You wrote:

SUM(o.Sales) OVER(PARTITION BY p.Category) AS TotalSales

But that calculates:

Total sales of the entire category

It does not calculate:

Total sales of each product.

Suppose:

Category	Product	Sales
Clothing	Shirt	100
Clothing	Shirt	150
Clothing	Jeans	200

You need:

Shirt = 250
Jeans = 200

Then rank:

Shirt = 1
Jeans = 2

But:

SUM(Sales) OVER(PARTITION BY Category)

would give:

Clothing = 450

for every row.

Correct pattern

Think:

Step 1

Calculate product-level totals:

GROUP BY ProductID, Product, Category

Step 2

Rank products inside category:

RANK() OVER(
    PARTITION BY Category
    ORDER BY TotalSales DESC
)

Step 3

Compare product totals against the overall average product total.

So this question is:

GROUP BY → CTE → RANK → comparison

not simply:

Window Function + PARTITION BY.

This is an extremely important lesson for you.

Ask yourself:

"What exactly am I partitioning?"

If the requirement says total sales for each product, you need product-level aggregation first.
*/
WITH CTE_Products AS (
     SELECT p.ProductID,
            p.Product,
            p.Category,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Products AS p
     INNER JOIN Sales.Orders AS o
     ON p.ProductID = o.ProductID
     GROUP BY p.ProductID, p.Product, p.Category
),
CTE_Average_TotalSales AS (
    SELECT *,
           RANK() OVER(PARTITION BY Category ORDER BY TotalSales DESC) AS SalesRank,
           AVG(TotalSales) OVER() AS AvgProductTotalSales
    FROM CTE_Products
)
SELECT ProductID,
       Product,
       Category, 
       TotalSales,
       AvgProductTotalSales
FROM CTE_Average_TotalSales
WHERE SalesRank = 1 
AND TotalSales > AvgProductTotalSales;


/*
Yes — this corrected Q27 is now logically correct. ✅

Your biggest correction is that you first calculate total sales per product using GROUP BY, and only then apply the window functions.

Your logic is now:
Sales.Orders
     +
Sales.Products
     ↓
GROUP BY Product
     ↓
TotalSales per Product
     ↓
RANK() within Category
     +
AVG() across Product TotalSales
     ↓
Filter
Step 1 — Product-level aggregation ✅
SUM(o.Sales) AS TotalSales

with:

GROUP BY p.ProductID, p.Product, p.Category

This correctly produces one row per product.

Step 2 — Ranking within category ✅
RANK() OVER(
    PARTITION BY Category
    ORDER BY TotalSales DESC
) AS SalesRank

This gives the highest-selling product in each category rank 1.

Because you're using RANK(), tied products will both get rank 1, which satisfies:

If two products have the same total sales, return both.

Step 3 — Average product total sales ✅
AVG(TotalSales) OVER() AS AvgProductTotalSales

This calculates the average of all product-level total sales.

That's important because the question says:

"overall average product total sales"

It does not mean average individual order sales.

Step 4 — Final filtering ✅
WHERE SalesRank = 1 
  AND TotalSales > AvgProductTotalSales

Exactly right.

One subtle distinction to remember

Your current query calculates:

Average of total sales per product across all products.

For example:

Product	TotalSales
Shirt	300
Jeans	200
Shoes	100
Watch	400

Average product total:

(300 + 200 + 100 + 400) / 4 = 250

That's what:

AVG(TotalSales) OVER()

is calculating.

⭐ Pattern you should memorize

When you see:

"Top-selling product in each category, based on total sales"

think:

GROUP BY Product
        ↓
SUM(Sales)
        ↓
RANK() PARTITION BY Category

And if you additionally see:

"greater than the overall average product total sales"

then:

Product totals
      ↓
AVG(TotalSales) OVER()
      ↓
compare

So Q27 is now a correct solution. Your pattern identification for this question should be:

JOIN + GROUP BY → CTE → Window Ranking + Window Average → Filter.
*/


/*
Q28

Display every customer with:

CustomerID
FirstOrderDate
LatestOrderDate
NumberOfOrders
TotalSales
PreviousOrderSales
CustomerSalesRank

CustomerSalesRank should rank customers against other customers, not orders within the same customer.

PATTERN: Window Function + PARITION BY 
         FIRST_VALUE for first order date,
         LAST_VALUE for latest order date,
         COUNT() AND SUM() Aggregate window function to get the Number of Orders and TotalSales
         LAG to get previous order sale
         CustomerSalesRank use TotalSales and RANK() Function
*/
SELECT *,
       DENSE_RANK() OVER(ORDER BY TotalSales DESC) AS CustomerSalesRank
FROM (
    SELECT CustomerID,
           FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
           LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           COUNT(OrderID) OVER(PARTITION BY CustomerID) AS NumberOfOrders,
           SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSales,
           LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales
    FROM Sales.Orders
) t;
       
/*
Your overall pattern recognition is very good.

You correctly identified:

FIRST_VALUE
LAST_VALUE
LAG
COUNT OVER
SUM OVER
RANK

And you correctly understood that:

CustomerSalesRank must compare customers against other customers, not orders within the same customer.

That's excellent.

You therefore correctly did:

DENSE_RANK() OVER(ORDER BY TotalSales DESC)
One thing to remember

Your final result still has one row per order, so the customer's rank will repeat for every order belonging to that customer.

That's fine if the question explicitly wants one row per order.
*/


/*
Q29

Display departments whose total salary is greater than the average department total salary.

For example:

IT        → 300,000
Sales     → 250,000
Marketing → 150,000
HR        → 100,000

Calculate the average of the department totals, then return departments above that average.

PATTERN:
GROUP BY + SUM Aggregation to compute the departments along with their total salary
then enclose it in CTE 

use comparison outside CTE

*/
WITH CTE_Employees_DeptTotals AS (
    SELECT department,
           SUM(Salary) AS TotalSalary
    FROM Sales.Employees
    GROUP BY Department
)
SELECT *
FROM CTE_Employees_DeptTotals
WHERE TotalSalary > (
      SELECT AVG(TotalSalary)
      FROM CTE_Employees_DeptTotals
);



/*
Q30 — 🔥 Final Challenge

Display a complete customer order analysis:

CustomerID
OrderID
OrderDate
Sales
CustomerOrderNumber
PreviousOrderSales
FirstOrderDate
LatestOrderDate
CustomerTotalSales
CustomerAverageSales
HighestOrderValue
CustomerSalesRank

Requirements:

One row per order
Order number resets for each customer
Previous sales must be from the same customer
Total sales must be customer-level
Average sales must be customer-level
Highest order value must be customer-level
Customer rank must compare customers against other customers
*/
WITH CTE_Customer_Orders_Analysis AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           Sales,
           ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS CustomerOrderNumber,
           LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderSales,
           FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
           LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate,
           SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales,
           AVG(Sales) OVER(PARTITION BY CustomerID) AS CustomerAverageSales,
           MAX(Sales) OVER(PARTITION BY CustomerID) AS HighestOrderValue
    FROM Sales.Orders
)
SELECT *,
       DENSE_RANK() OVER(ORDER BY CustomerTotalSales DESC) AS CustomerSalesRank
FROM CTE_Customer_Orders_Analysis;

/*
Your identification of the required functions is excellent:

ROW_NUMBER()
LAG()
FIRST_VALUE()
LAST_VALUE()
SUM() OVER()
AVG() OVER()
MAX() OVER()
DENSE_RANK()

This is very close.

However, your final ranking has the wrong direction:

You wrote:

DENSE_RANK() OVER(
    ORDER BY CustomerTotalSales
)

That gives:

Lowest sales → Rank 1
Highest sales → highest rank

But the question says:

Customer rank should compare customers based on total sales.

Usually, based on the challenge wording and your previous questions, highest sales should rank 1.

So:

DENSE_RANK() OVER(
    ORDER BY CustomerTotalSales DESC
)
Important

You made the same type of mistake here that you sometimes make with ranking:

Always ask:

"Who should receive Rank 1?"

If it's highest:

ORDER BY ... DESC

If it's lowest:

ORDER BY ... ASC

Pattern identification: ✅
*/


