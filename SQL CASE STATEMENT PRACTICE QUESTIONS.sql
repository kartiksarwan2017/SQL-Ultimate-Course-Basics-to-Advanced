/********* SQL CASE STATEMENTS **********/

USE SalesDB;

/*
Pattern 1 — Simple CASE (Value Mapping)
Clue Words
display as
convert
show as
replace values
map values

Think:

CASE column
    WHEN value1 THEN ...
    WHEN value2 THEN ...
    ELSE ...
END
*/

/*
Q1
Display employee gender.
Show
M → Male
F → Female
*/
SELECT CASE
           WHEN Gender = 'M' THEN 'Male'
           WHEN Gender = 'F' THEN 'Female'
       END AS employee_gender
FROM Sales.Employees;

/*
Interview Tip

You can also write:

CASE Gender
    WHEN 'M' THEN 'Male'
    WHEN 'F' THEN 'Female'
END

Since you're comparing the same column, the simple CASE syntax is slightly cleaner.
*/

/*
Q2

Display order status.

Show
Delivered → Completed
Shipped → In Transit

Else Pending.
*/
SELECT CASE 
           WHEN orderstatus = 'Delivered' THEN 'Completed'
           WHEN orderstatus = 'Shipped' THEN 'In Transit'
           ELSE 'Pending'
       END AS OrderStatus
FROM Sales.Orders;


/*
Q3

Display customer country.

Show
USA → United States
Germany → Deutschland

*/
SELECT CASE 
           WHEN Country = 'USA' THEN 'United States'
           WHEN Country = 'Germany' THEN 'Deutschland'
       END AS customer_country
FROM Sales.Customers;

/*
One small suggestion:

Always include an ELSE.

ELSE Country

because tomorrow your database may contain

India
Canada
Japan

Without ELSE they become NULL.
*/
-- BETTER QUERY
SELECT CASE Country 
            WHEN 'USA' THEN 'United States'
            WHEN 'Germany' THEN 'Deutschland'
            ELSE Country
       END AS Country
FROM Sales.Customers;
           

/*
Q4

Display product category.

Show

Clothing → Apparel
Accessories → Fashion Accessories

*/
SELECT CASE 
           WHEN Category = 'Clothing' THEN 'Apparel'
           WHEN Category = 'Accessories' THEN 'Fashion Accessories'
           ELSE Category
       END AS ProductCategory
FROM Sales.Products;


/*
Q5

Display quantity.

Show

0 → Out of Stock

Otherwise show the quantity.
*/
SELECT CASE
           WHEN Quantity = 0 THEN 'Out of Stock'
           ELSE CAST(Quantity AS VARCHAR) 
       END AS Quantity
FROM Sales.Orders;

/*
Exactly right.

Notice something important:

CASE returns one datatype.

You correctly converted

Quantity

to

VARCHAR

Otherwise SQL Server would throw an error.

This is an interview favorite.
*/

/*
Q6

Display manager.

If ManagerID is NULL display

Top Manager

Otherwise display ManagerID.
*/
SELECT CASE
           WHEN ManagerID IS NULL THEN 'Top Manager'
           ELSE CAST(ManagerID AS VARCHAR)
       END AS ManagerID
FROM Sales.Employees;

/*
Q7

Display billing address.

If NULL show

No Billing Address

Otherwise display address.
*/
SELECT CASE
           WHEN BillAddress IS NULL THEN 'No Billing Address'
           ELSE BillAddress
       END AS BillingAddress
FROM Sales.Orders;

/*
Q8

Display shipping address.

If NULL show

Pickup
*/
SELECT CASE
           WHEN ShipAddress IS NULL THEN 'Pickup'
           ELSE ShipAddress 
       END AS ShippingAddress
FROM Sales.Orders;


/*
Q9

Display customer score.

If NULL display

No Score

Otherwise show score.
*/
SELECT CASE 
           WHEN Score IS NULL THEN 'No Score'
           ELSE CAST(Score AS VARCHAR)
       END AS CustomerScore
FROM Sales.Customers;

/* You're remembering to CAST numeric values whenever CASE mixes text and numbers. */


/*

Q10

Display product price.

If price = 30

display

Premium
Else
Standard
*/
SELECT Price,
       CASE 
           WHEN Price = 30 THEN 'Premium'
           ELSE 'Standard'
       END AS ProductPrice
FROM Sales.Products;


/**************** Pattern 2 — Searched CASE (Interview Favorite) ******************
Clue Words
greater than
less than
between
category
grade
classify
bucket

Think:

CASE
WHEN condition THEN ...
WHEN condition THEN ...
ELSE ...
END

*/

/*
Q11

Classify customer score.

≥800 → Excellent
≥500 → Good
Else → Average
*/
SELECT Score,
       CASE
           WHEN Score >= 800 THEN 'Excellent'
           WHEN Score >= 500 THEN 'Good'
           ELSE 'Average'
       END AS CustomerScore
FROM Sales.Customers;

/*
This is exactly how SQL evaluates CASE.

Example:

900 → Excellent
750 → Good
350 → Average
NULL → Average

Notice:

NULL >= 800

is UNKNOWN, not TRUE.

Therefore SQL reaches

ELSE 'Average'

If you wanted NULL separately, you'd write

WHEN Score IS NULL THEN 'No Score'

like you did in Q16.
*/


/*
Q12

Classify employee salary.

≥80000 → High
≥60000 → Medium
Else → Low
*/
SELECT Salary,
       CASE 
           WHEN Salary >= 80000 THEN 'High'
           WHEN Salary >= 60000 THEN 'Medium'
           ELSE 'Low'
       END AS EmployeeSalary
FROM Sales.Employees;


/*

Q13

Classify product price.

≥25 → Expensive
≥15 → Moderate
Else Cheap
*/
SELECT Price,
       CASE 
           WHEN Price >= 25 THEN 'Expensive'
           WHEN Price >= 15 THEN 'Moderate'
           ELSE 'Cheap'
       END AS ProductPrice
FROM Sales.Products;



/*
Q14

Display shipping speed.

Using

DATEDIFF(day,OrderDate,ShipDate)
≤5 Fast
≤10 Normal
Else Slow

*/
SELECT DATEDIFF(day,OrderDate,ShipDate) AS DaysTaken,
       CASE
           WHEN DATEDIFF(day, OrderDate, ShipDate) <= 5 THEN 'Fast'
           WHEN DATEDIFF(day, Orderdate, ShipDate) <= 10 THEN 'Normal'
           ELSE 'Slow'
       END AS ShippingSpeed
FROM Sales.Orders;

/* issue: DATEDIFF() is calculated twice. */
SELECT OrderDate,
       ShipDate,
       DaysTaken,
       CASE
           WHEN DaysTaken <= 5 THEN 'Fast'
           WHEN DaysTaken <= 10 THEN 'Normal'
           ELSE 'Slow'
       END AS ShippingSpeed
FROM
(
    SELECT OrderDate,
           ShipDate,
           DATEDIFF(day, OrderDate, ShipDate) AS DaysTaken
    FROM Sales.Orders
) AS O;

/*
Why is this better?
DATEDIFF() executes only once.
Easier to read.
Easier to maintain.
Preferred in real projects.
*/

/*
Q15

Classify quantity.

0 No Stock
1 Low Stock

1 In Stock
*/
SELECT Quantity,
       CASE
           WHEN Quantity = 0 THEN 'No Stock'
           WHEN Quantity = 1 THEN 'Low Stock'
           ELSE 'In Stock'
       END AS QuantityStatus
FROM Sales.Orders;



/*
Q16

Classify customer score.

If NULL

No Score

Else

≥700 High
Else Low
*/
SELECT Score,
       CASE 
           WHEN Score IS NULL THEN 'No Score'
           WHEN Score >= 700 THEN 'High'
           ELSE 'Low'
       END AS customer_score
FROM Sales.Customers;


/*
Q17

Display employee age group.

<35 Young
35–50 Middle

50 Senior

(Hint: use DATEDIFF(YEAR, BirthDate, GETDATE()) or the equivalent in your SQL dialect.)
*/
SELECT DATEDIFF(year, BirthDate, GETDATE()) AS employee_age,
       CASE 
           WHEN DATEDIFF(year, BirthDate, GETDATE()) < 35 THEN 'Young'
           WHEN DATEDIFF(year, BirthDate, GETDATE()) >= 35 AND DATEDIFF(year, BirthDate, GETDATE()) < 50 THEN 'Middle'
           ELSE 'Senior' 
       END AS employee_age_group
FROM Sales.Employees;


-- BETTER SOLUTION
SELECT EmployeeAge,
       CASE
           WHEN EmployeeAge < 35 THEN 'Young'
           WHEN EmployeeAge < 50 THEN 'Middle'
           ELSE 'Senior'
       END AS EmployeeAgeGroup
FROM
(
    SELECT DATEDIFF(year, BirthDate, GETDATE()) AS EmployeeAge
    FROM Sales.Employees
) AS E;

/*
Q18

Classify sales.

≥50 High Sales
≥20 Medium Sales
Else Low Sales
*/
SELECT Sales,
       CASE 
           WHEN Sales >= 50 THEN 'High Sales'
           WHEN Sales >= 20 THEN 'Medium Sales'
           ELSE 'Low Sales'
       END AS sales_category
FROM Sales.Orders;

/*
Q19

Classify orders.

Delivered → Completed
Shipped → In Transit
Else Pending

(using searched CASE)
*/
SELECT OrderStatus,
       CASE
           WHEN OrderStatus = 'Delivered' THEN 'Completed'
           WHEN OrderStatus = 'Shipped' THEN 'In Transit'
           ELSE 'Pending'
       END AS OrderStatusResult
FROM Sales.Orders;



/*
Q20

Display product type.

If category = Clothing

Wearable

Else

Utility

*/
SELECT Category,
       CASE 
           WHEN Category = 'Clothing' THEN 'Wearable'
           ELSE 'Utility'
       END AS CategoryResult
FROM Sales.Products;


/*
Pattern 3 — CASE + Aggregate (Most Asked)
Clue Words
count delivered
total shipped
conditional sum
conditional count
pivot
dashboard

Think:

SUM(CASE WHEN ... THEN ... END)
COUNT(CASE WHEN ... THEN ... END)
*/
/*
Q21
Count Delivered orders.
*/
SELECT COUNT(CASE WHEN OrderStatus = 'Delivered' THEN OrderID END) AS num_delivered_orders
FROM Sales.Orders;

/*
Instead of

COUNT(CASE WHEN OrderStatus='Delivered' THEN OrderID END)

many interviewers prefer

COUNT(CASE WHEN OrderStatus='Delivered' THEN 1 END)

because you're only counting rows, not values.
*/
SELECT COUNT(CASE WHEN OrderStatus = 'Delivered' THEN 1 END) AS DeliveredOrders
FROM Sales.Orders;


/*
Q22
Count Shipped orders.
*/
SELECT COUNT(CASE WHEN OrderStatus = 'Shipped' THEN OrderID END) AS num_shipped_orders
FROM Sales.Orders;

/*
Q23
Total sales of Delivered orders.
*/
SELECT SUM(CASE WHEN OrderStatus = 'Delivered' THEN Sales END) AS total_sales
FROM Sales.Orders;

/*
Instead of

SELECT SUM(CASE WHEN Category='Clothing' THEN Sales END)

you can write

SELECT
    SUM(CASE WHEN Category='Clothing' THEN Sales ELSE 0 END) AS ClothingSales

Why?

Without ELSE 0

SUM(NULL,NULL,NULL)

returns NULL if there are no matching rows.

With

ELSE 0
it returns
0
which is usually what dashboards and reports expect.
*/
SELECT SUM(CASE WHEN p.Category = 'Clothing' THEN o.Sales ELSE 0 END) AS ClothingSales
FROM Sales.Products AS p
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID;


/*
Q24
Total sales of Shipped orders.
*/
SELECT SUM(CASE WHEN OrderStatus = 'Shipped' THEN Sales END) AS total_sales
FROM Sales.Orders;

/*
Q25
Count USA customers.

*/
SELECT COUNT(CASE WHEN Country = 'USA' THEN CustomerID END) AS num_usa_customers
FROM Sales.Customers;


/*
Q26
Count Germany customers.
*/
SELECT COUNT(CASE WHEN Country = 'Germany' THEN CustomerID END) AS num_customers
FROM Sales.Customers;

/*
Q27
Total Clothing sales.
*/
SELECT SUM(CASE WHEN p.Category = 'Clothing' THEN o.Sales END) AS total_sales
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID;

/*
Q28
Total Accessories sales.
*/
SELECT SUM(CASE WHEN p.Category = 'Accessories' THEN o.sales END) AS TotalAccessories
FROM Sales.Products AS p
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID;

/*
Q29
Count employees in Sales department.
*/
SELECT COUNT(CASE WHEN Department = 'Sales' THEN EmployeeID END) AS num_employees
FROM Sales.Employees;

/*
Q30
Count employees in Marketing department.
*/
SELECT COUNT(CASE WHEN department = 'Marketing' THEN EmployeeID END) AS num_employees
FROM Sales.Employees;


/**************** Pattern 4 — CASE + GROUP BY (Interview Favorite)  *********************
Clue Words
per customer
per employee
per category
grouped classification
*/
/*
Q31
Show each customer with
High Spender / Low Spender
based on total sales.
*/
SELECT c.FirstName,
       c.LastName,
       SUM(o.sales) AS TotalSales,
       CASE 
           WHEN SUM(o.sales) >= 125 THEN 'High Spender'
           ELSE 'Low Spender'
       END AS CustomerType
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;




/*
Q32
Show each employee with
Top Seller / Average Seller
based on total sales.
*/
SELECT e.FirstName,
       e.LastName,
       SUM(o.Sales) AS TotalSales,
       CASE 
           WHEN SUM(o.Sales) >= 195 THEN 'Top Seller'
           ELSE 'Average Seller' 
       END AS SellerType
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o 
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;



/*
Q33

Show product category with
High Revenue / Low Revenue.
*/
SELECT p.Category,
       SUM(o.sales) AS TotalSales,
       CASE 
           WHEN SUM(o.sales) >= 100 THEN 'High Revenue'
           ELSE 'Low Revenue'
       END AS RevenueType
FROM Sales.Products AS p
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.Category;



/*
Q34

Show each country with
Premium Market / Regular Market
based on average score.
*/
SELECT Country, 
       AVG(Score) AS avg_score,
       CASE 
           WHEN AVG(Score) >= 100 THEN 'Premium Market'
           ELSE 'Regular Market'
       END AS MarketType
FROM Sales.Customers
GROUP BY Country;

/*

Interview tip:

The cutoff value (100) is completely business-dependent. 
An interviewer is checking whether you know how to use AVG() with CASE, 
not whether you picked the "correct" threshold.

*/

/*
Q35
Show departments with
High Salary / Low Salary.
*/
SELECT Department,
       SUM(Salary) AS totalSalary,
       CASE 
           WHEN SUM(Salary) > 100000 THEN 'High Salary'
           ELSE 'Low Salary'
       END AS SalaryType
FROM Sales.Employees
GROUP BY Department;



/****************** Pattern 5 — CASE + JOIN (Interview Level)  **********************/
/*
Clue Words
report
dashboard
label
customer type
sales report
*/
/*
Q36
Display customer name and score category.
*/
SELECT FirstName,
       LastName,
       CASE 
           WHEN Score >= 800 THEN 'Excellent'
           WHEN Score >= 500 THEN 'Good'
           WHEN Score < 500 THEN 'Average'
           WHEN Score IS NULL THEN 'No Score'
        END AS ScoreCategory
FROM Sales.Customers;

/*
Improvement

Always check NULL first.

Why?

NULL >= 800 is neither true nor false, so SQL evaluates each condition until it reaches IS NULL. 
While your query still works, checking NULL first is the recommended practice.
*/
SELECT FirstName,
       LastName,
       CASE 
           WHEN Score IS NULL THEN 'No Score'
           WHEN Score >= 800 THEN 'Excellent'
           WHEN Score >= 500 THEN 'Good'
           ELSE 'Average'
        END AS ScoreCategory
FROM Sales.Customers;



/*
Q37
Display employee name and salary category.
*/
SELECT FirstName,
       LastName,
       CASE
           WHEN Salary >= 80000 THEN 'High Salary'
           WHEN Salary >= 60000 THEN 'Medium Salary'
           WHEN Salary < 60000 THEN 'Low Salary'
       END AS SalaryType
FROM Sales.Employees;

-- CLEANER QUERY
SELECT FirstName,
       LastName,
       CASE 
           WHEN Salary >= 80000 THEN 'High Salary'
           WHEN Salary >= 60000 THEN 'Medium Salary'
           ELSE 'Low Salary'
       END 
FROM Sales.Employees;


/*
Q38
Display product name and price category.
*/
SELECT Product,
       CASE 
           WHEN Price >= 25 THEN 'Expensive'
           WHEN Price >= 15 THEN 'Moderate'
           ELSE 'Cheap'
       END AS price_category
FROM Sales.Products;


/*
Q39
Display customer, product and order priority.
If sales ≥50
Priority
Else
Normal
*/
SELECT c.FirstName,
       c.LastName,
       p.Product,
       CASE 
           WHEN o.Sales >= 50 THEN 'Priority'
           ELSE 'Normal'
       END AS order_priority
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID;




/*
Q40
Display complete sales report.
Include:
Customer Name
Employee Name
Product Name
Sales
Sales Category
High (≥50)
Medium (20–49)
Low (<20)
*/
SELECT c.FirstName AS customer_firstname,
       c.LastName AS customer_lastname,
       e.FirstName AS employee_firstname,
       e.LastName AS employee_lastname,
       p.Product,
       o.Sales,
       CASE
           WHEN o.Sales >= 50 THEN 'High'
           WHEN o.Sales >= 20 THEN 'Medium'
           ELSE 'Low'
       END AS sales_category
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Employees AS e
ON e.EmployeeID = o.SalesPersonID
INNER JOIN Sales.Products AS p
ON p.ProductID = o.ProductID;




/*****************  Pattern 6 — CASE + Derived Table  *********************
Clue Words
based on total
after calculating
classify aggregated data
report
dashboard
summary

Think:

FROM
(
    SELECT ...
    GROUP BY ...
) AS T

Then apply CASE to the aggregated columns

*/
/*
Q1 Customer Spending Report

Display
Customer Name
Total Sales
Customer Category

Categories
≥ 100 → Premium
≥ 50 → Regular
Else → New Customer
*/
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       SUM(o.Sales) AS TotalSales,
       CASE  
           WHEN SUM(o.Sales) >= 100 THEN 'Premium'
           WHEN SUM(o.Sales) >= 50 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;



SELECT CustomerName,
       TotalSales,
       CASE
           WHEN TotalSales >= 100 THEN 'Premium'
           WHEN TotalSales >= 50 THEN 'Regular'
           ELSE 'New Customer'
       END AS CustomerCategory
FROM 
(
  SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
         SUM(o.Sales) AS TotalSales
  FROM Sales.Customers AS c
  INNER JOIN Sales.Orders AS o
  ON c.CustomerID = o.CustomerID
  GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS T;




/*
Q2 Employee Performance Report

Display

Employee Name
Total Revenue
Performance

Categories

≥100 → Top Performer
≥60 → Good Performer
Else → Needs Improvement
*/
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       SUM(o.Sales) AS TotalRevenue,
       CASE 
           WHEN SUM(o.Sales) >= 100 THEN 'Top Performer'
           WHEN SUM(o.Sales) >= 60 THEN 'Good Performer'
           ELSE 'Needs Improvement'
       END AS PerformanceCategory
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o 
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;


-- USING Derived Tables
SELECT EmployeeName, 
       TotalRevenue,
       CASE 
           WHEN TotalRevenue >= 100 THEN 'Top Performer'
           WHEN TotalRevenue >= 60 THEN 'Good Performer'
           ELSE 'Needs Improvement'
       END AS PerformanceCategory
FROM (
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       SUM(o.Sales) AS TotalRevenue
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o 
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName) AS T;




/*
Q3 Product Revenue Report

Display

Product Name
Revenue
Revenue Category

Categories

≥ 80 → High Revenue
≥ 40 → Medium Revenue
Else → Low Revenue
*/
SELECT p.Product AS ProductName,
       SUM(o.Sales) AS TotalSales,
       CASE 
           WHEN SUM(o.Sales) >= 80 THEN 'High Revenue'
           WHEN SUM(o.Sales) >= 40 THEN 'Medium Revenue'
           ELSE 'Low Revenue'
       END AS RevenueCategory
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o 
ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Product;

-- DERIVED TABLE
SELECT ProductName,
       TotalSales,
       CASE 
           WHEN TotalSales >= 80 THEN 'High Revenue'
           WHEN TotalSales >= 40 THEN 'Medium Revenue'
           ELSE 'Low Revenue'
       END AS RevenueCategory
FROM (
SELECT p.Product AS ProductName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o 
ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Product) AS T;




/*
Q4 Country Sales Report

Display

Country
Total Sales
Market Category

Categories

≥100 → Major Market
Else → Minor Market
*/
SELECT Country,
       SUM(o.Sales) AS TotalSales,
       CASE 
           WHEN SUM(o.Sales) >= 100 THEN 'Major Market'
           ELSE 'Minor Market'
       END AS MarketCategory
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY Country;

-- DERIVED TABLE
SELECT Country, 
       TotalSales,
       CASE 
           WHEN TotalSales >= 100 THEN 'Major Market'
           ELSE 'Minor Market'
       END AS MarketCategory
FROM (
SELECT Country,
       SUM(o.Sales) AS TotalSales
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY Country
) AS T;


/*
Q5 Department Revenue Report

Display

Department
Revenue
Department Rating

Categories

≥150 → Excellent
≥80 → Good
Else → Average

*/
SELECT e.Department,
       SUM(o.Sales) AS TotalSales,
       CASE 
           WHEN SUM(o.Sales) >= 150 THEN 'Excellent'
           WHEN SUM(o.Sales) >= 80 THEN 'Good'
           ELSE 'Average'
       END AS DepartmentRating
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.Department;

-- DERIVED TABLE
SELECT Department,
       TotalSales,
       CASE 
           WHEN TotalSales >= 150 THEN 'Excellent'
           WHEN TotalSales >= 80 THEN 'Good'
           ELSE 'Average'
       END AS DepartmentRating
FROM (
SELECT e.Department AS Department,
       SUM(o.Sales) AS TotalSales
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.Department) AS T;



/*
Q6 Customer Order Report

Display

Customer Name
Number of Orders
Customer Type

Categories

≥3 → Frequent Customer
2 → Regular Customer
1 → New Customer
*/
SELECT CustomerName,
       NumOrders,
       CASE
           WHEN NumOrders >= 3 THEN 'Frequent Customer'
           WHEN NumOrders = 2 THEN 'Regular Customer'
           WHEN NumOrders = 1 THEN 'New Customer'
       END AS CustomerType
FROM (
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       COUNT(o.OrderID) AS NumOrders
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS T;



/*
Q7 Product Popularity

Display

Product Name
Number of Orders
Popularity

Categories

≥3 → Best Seller
2 → Popular
Else → Slow Moving
*/
SELECT p.Product AS ProductName,
       COUNT(o.OrderID) AS NumOrders,
       CASE
           WHEN COUNT(o.OrderID) >= 3 THEN 'Best Seller'
           WHEN COUNT(o.OrderID) = 2 THEN 'Popular'
           ELSE 'Slow Moving'
       END AS Popularity
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Product;

-- DERIVED TABLE
SELECT ProductName,
       NumOrders,
       CASE
            WHEN NumOrders >= 3 THEN 'Best Seller'
            WHEN NumOrders = 2 THEN 'Popular'
            ELSE 'Slow Moving'
       END AS Popularity
FROM (
    SELECT p.Product AS ProductName,
           COUNT(o.OrderID) AS NumOrders
    FROM Sales.Products AS p 
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Product
) AS T;



/*
Q8 Employee Workload

Display

Employee Name
Orders Handled
Workload

Categories

≥ 4 → Heavy
≥ 2 → Medium
Else → Light
*/
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       COUNT(o.OrderID) AS OrdersHandled,
       CASE 
           WHEN COUNT(o.OrderID) >= 4 THEN 'Heavy'
           WHEN COUNT(o.OrderID) >= 2 THEN 'Medium'
           ELSE 'Light'
       END AS 'Workload'
FROM Sales.Employees AS e
INNER JOIN Sales.Orders AS o
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- DERIVED TABLE
SELECT EmployeeName,
       OrdersHandled,
       CASE 
           WHEN OrdersHandled >= 4 THEN 'Heavy'
           WHEN OrdersHandled >= 2 THEN 'Medium'
           ELSE 'Light'
       END AS 'Workload'
FROM (
        SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
               COUNT(o.OrderID) AS OrdersHandled
        FROM Sales.Employees AS e
        INNER JOIN Sales.Orders AS o
        ON e.EmployeeID = o.SalesPersonID
        GROUP BY e.EmployeeID, e.FirstName, e.LastName
) AS T;


/*
Q9 Category Performance

Display

Category
Average Sales
Category Rating

Categories

≥40 → Excellent
≥20 → Good
Else → Average
*/
SELECT p.Category AS ProductCategory,
       AVG(o.Sales) AS AvgSales,
       CASE
           WHEN AVG(o.Sales) >= 40 THEN 'Excellent'
           WHEN AVG(o.Sales) >= 20 THEN 'Good'
           ELSE 'Average'
       END AS CategoryRating
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.Category;

-- DERIVED TABLE
SELECT ProductCategory,
       AvgSales,
       CASE
            WHEN AvgSales >= 40 THEN 'Excellent'
            WHEN AvgSales >= 20 THEN 'Good'
            ELSE 'Average'
        END AS CategoryRating
FROM (
    SELECT p.Category AS ProductCategory,
        AVG(o.Sales) AS AvgSales
    FROM Sales.Products AS p 
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category  
) AS T;


/*
Q10 Monthly Revenue

Display

Month
Total Sales
Revenue Category

Categories

≥ 100 → High
≥ 50 → Medium
Else → Low
*/
SELECT DATENAME(month, OrderDate) AS Month,
       SUM(Sales) AS TotalSales,
       CASE
           WHEN SUM(Sales) >= 100 THEN 'High'
           WHEN SUM(Sales) >= 50 THEN 'Medium'
           ELSE 'Low'
       END AS RevenueCategory
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

/*
GROUP BY DATENAME(month, OrderDate)

This works for your sample data but is not interview-safe.

Imagine:

Jan 2024
Jan 2025

Both become

January

and will be grouped together.

Interviewers usually expect

GROUP BY
YEAR(OrderDate),
MONTH(OrderDate)

or

FORMAT(OrderDate,'yyyy-MM')

Example

SELECT
FORMAT(OrderDate,'yyyy-MM') AS Month,
SUM(Sales) AS TotalSales
FROM Orders
GROUP BY FORMAT(OrderDate,'yyyy-MM');

Much safer.
*/
SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month,
       SUM(Sales) AS TotalSales,
       CASE
           WHEN SUM(Sales) >= 100 THEN 'High'
           WHEN SUM(Sales) >= 50 THEN 'Medium'
           ELSE 'Low'
       END AS RevenueCategory
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM');


-- DERIVED TABLE
SELECT Month,
       TotalSales,
       CASE
           WHEN TotalSales >= 100 THEN 'High'
           WHEN TotalSales >= 50 THEN 'Medium'
           ELSE 'Low'
       END AS RevenueCategory
FROM (
     SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month,
     SUM(Sales) AS TotalSales
     FROM Sales.Orders 
     GROUP BY FORMAT(OrderDate, 'yyyy-MM')
) AS T; 

/***************** Interview-Level Derived Table Questions  ********************/
/*
Q11

Find customers whose total sales are above the average customer sales.

(Hint: Derived Table + Aggregate + CASE)
*/
SELECT CustomerName
FROM (
    SELECT CASE
               WHEN SUM(o.Sales) > AVG(o.Sales) THEN CONCAT(c.FirstName, ' ', c.LastName) 
           END AS CustomerName
    FROM Sales.Orders AS o
    INNER JOIN Sales.Customers AS c
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS T;

/*
Your query compares:

SUM(o.Sales) > AVG(o.Sales)

This is wrong.

Why?

For each customer,

Customer A

Orders

10
20
30

SUM = 60
AVG = 20

60 > 20

This will almost always be true.

The interviewer is asking:

Customer Total Sales

John 150
Mary 90
Kevin 40
Anna 30

Average Customer Sales

(150+90+40+30)/4 = 77.5

Now compare

150 > 77.5 ✔
90 > 77.5 ✔
40 ✘
30 ✘

You need two levels of aggregation.
*/
-- BETTER QUERY
SELECT CustomerName
FROM (
    SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Customers c
    INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS T
WHERE TotalSales > (
      SELECT AVG(TotalSales)
      FROM (
          SELECT SUM(Sales) AS TotalSales
          FROM Sales.Orders 
          GROUP BY CustomerID
      ) AS X
);



/*
Q12

Show every employee and classify them as

Above Average Revenue
Below Average Revenue

based on the average revenue generated by all employees.
*/
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       CASE
           WHEN SUM(o.Sales) > AVG(o.Sales) THEN 'Above Average Revenue'
           WHEN SUM(o.Sales) < AVG(o.Sales) THEN 'Below Average Revenue'
       END AS RevenueType
FROM Sales.Employees AS e 
INNER JOIN Sales.Orders AS o
ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;


-- DERIVED TABLE
SELECT EmployeeName,
       CASE
           WHEN TotalSales > AvgSales THEN 'Above Average Revenue'
           WHEN TotalSales < AvgSales THEN 'Below Average Revenue'
       END AS RevenueType
FROM (
     SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
            SUM(o.Sales) AS TotalSales,
            AVG(o.Sales) AS AvgSales
     FROM Sales.Employees AS e 
     INNER JOIN Sales.Orders AS o
     ON e.EmployeeID = o.SalesPersonID
     GROUP BY e.EmployeeID, e.FirstName, e.LastName
) AS T;


/*
Q13

Display product categories and classify them as

Profitable
Less Profitable

based on total revenue.
*/
SELECT p.Category AS product_category,
       CASE 
           WHEN SUM(o.Sales) > 100 THEN 'Profitable'
           ELSE 'Less Profitable'
       END AS ProfitStatus
FROM Sales.Products AS p 
INNER JOIN Sales.Orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.Category;


-- DERIVED TABLE

SELECT ProductCategory,
       CASE
           WHEN TotalSales > 100 THEN 'Profitable'
           ELSE 'Less Profitable'
       END AS ProfitStatus
FROM (
    SELECT p.Category AS ProductCategory,
           SUM(o.Sales) AS TotalSales
    FROM Sales.Products AS p 
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category
) AS T;


/*
Q14

Display customer names and classify them as

Loyal
Occasional

based on total number of orders.
*/
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       CASE
           WHEN COUNT(o.OrderID) > 5 THEN 'Loyal'
           ELSE 'Occasional'
       END AS CustomerOrderCategory
FROM Sales.Customers AS c 
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;


-- DERIVED TABLE
SELECT CustomerName, 
       CASE
           WHEN NumOrders > 5 THEN 'Loyal'
           ELSE 'Occasional'
       END AS CustomerOrderCategory
FROM (
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       COUNT(o.OrderID) AS NumOrders
FROM Sales.Customers AS c 
INNER JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName) AS T;

/*
Q15

Display monthly sales and classify them as

Best Month
Average Month

based on monthly revenue.
*/
SELECT DATENAME(month, OrderDate) AS Month,
       SUM(Sales) AS TotalRevenue,
       CASE
           WHEN SUM(Sales) > 100 THEN 'Best Month'
           ELSE 'Average Month'
       END AS RevenueStatus
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);


-- DERIVED TABLE

SELECT Month,
       TotalRevenue,
       CASE
           WHEN TotalRevenue > 100 THEN 'Best Month'
           ELSE 'Average Month'
       END AS RevenueStatus
FROM (
        SELECT DATENAME(month, OrderDate) AS Month,
               SUM(Sales) AS TotalRevenue
        FROM Sales.Orders
        GROUP BY DATENAME(month, OrderDate)
) AS T;

/*
Only improvement:

Instead of

GROUP BY DATENAME(month,OrderDate)

prefer

GROUP BY
YEAR(OrderDate),
MONTH(OrderDate)

because

January 2024

January 2025

would otherwise merge together.
*/
SELECT YEAR(OrderDate) AS Year, 
       MONTH(OrderDate) AS Month,
       SUM(Sales) AS TotalRevenue,
       CASE
           WHEN SUM(Sales) > 100 THEN 'Best Month'
           ELSE 'Average Month'
       END AS RevenueStatus
FROM Sales.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate);


-- DERIVED TABLE

SELECT Month,
       Year
       TotalRevenue,
       CASE
           WHEN TotalRevenue > 100 THEN 'Best Month'
           ELSE 'Average Month'
       END AS RevenueStatus
FROM (
        SELECT YEAR(OrderDate) AS Year,
               MONTH(OrderDate) AS Month,
               SUM(Sales) AS TotalRevenue
        FROM Sales.Orders
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
) AS T;

