/*
Pattern 1 — Aggregate Window Functions (Basic)

Clue Words

running
total
average
department total
customer total
cumulative

Think

SUM() OVER(...)
AVG() OVER(...)
COUNT() OVER(...)
MIN() OVER(...)
MAX() OVER(...)

*/
USE SalesDB;

/*
Q1 Display every order with the total sales of all orders.

Output
OrderID
Sales
TotalSales

*/
SELECT OrderID,
       Sales,
       SUM(Sales) OVER() AS TotalSales
FROM Sales.Orders;



/*
Q2
Display every employee with the average salary of all employees.

Output

EmployeeName
Salary
AverageSalary
*/
SELECT FirstName,
       LastName,
       Salary,
       AVG(Salary) OVER() AS AverageSales
FROM Sales.Employees;


/*
Q3
Display every product with the highest product price.
*/
SELECT *,
       MAX(Price) OVER() AS HighestProductPrice
FROM Sales.Products;


/*
Q4
Display every customer with the lowest customer score.
*/
SELECT *,
       MIN(Score) OVER() AS LowestCustomerScore
FROM Sales.Customers;



/*
Q5
Display every order with the number of total orders.
*/
SELECT *,
       COUNT(OrderID) OVER() AS TotalOrders
FROM Sales.Orders;



/*
Q6
Display every employee along with the total salary paid to all employees.
*/
SELECT *,
       SUM(Salary) OVER() AS TotalSalary
FROM Sales.Employees;


/*
Q7
Display every product along with the average product price.
*/
SELECT *,
       AVG(Price) OVER() AS AvgProductPrice
FROM Sales.Products;


/*
Q8
Display every order with the maximum sales amount.
*/
SELECT *,
       MAX(Sales) OVER() AS MaxSalesAmount
FROM Sales.Orders;



/*
Q9
Display every order with the minimum sales amount.
*/
SELECT *,
       MIN(Sales) OVER() AS MinSalesAmount
FROM Sales.Orders;


/*
Q10
Display every customer with the highest customer score.
*/
SELECT *,
       MAX(Score) OVER() AS HighestCustomerScore
FROM Sales.Customers;


/*
Pattern 2 — Aggregate Window Functions + PARTITION BY

Clue Words

within department
per customer
per category
by country
within group

Think

SUM(...) OVER(PARTITION BY ...)
*/

/*
Q11
Display every employee with the total salary of their department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       SUM(Salary) OVER(PARTITION BY Department) AS TotalSalaryPerDepartment
FROM Sales.Employees;

/*
Q12
Display every employee with the average salary of their department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       AVG(Salary) OVER(PARTITION BY Department) AS AverageSalary
FROM Sales.Employees;

/*
Q13
Display every product with the average price of its category.
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       AVG(Price) OVER(PARTITION BY Category) AS AveragePricePerCategory
FROM Sales.Products;

/*
Q14
Display every product with the maximum price in its category.
*/
SELECT ProductID,
       Product,
       Category,
       MAX(Price) OVER(PARTITION BY Category) AS MaxPricePerCategory
FROM Sales.Products;

/*
Q15
Display every product with the minimum price in its category.
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       MIN(Price) OVER(PARTITION BY Category) AS MinPricePerCategory
FROM Sales.Products;

/*
Q16
Display every customer with the average customer score by country.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       Score,
       AVG(Score) OVER(PARTITION BY Country) AS AverageScoreBasedOnCountry
FROM Sales.Customers;


/*
Q17
Display every customer with the highest score in each country.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       Score,
       MAX(Score) OVER(PARTITION BY Country) AS HighestScoreEachCountry
FROM Sales.Customers;

/*
Q18
Display every customer with the lowest score in each country.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country, 
       Score,
       MIN(Score) OVER(PARTITION BY Country) AS LowestScoreEachCountry
FROM Sales.Customers;

/*
Q19
Display every order with the total sales by customer.
Output

CustomerID
OrderID
Sales
CustomerTotalSales
*/
SELECT CustomerID,
       OrderID,
       Sales,
       SUM(Sales) OVER(PARTITION BY CustomerID) AS CustomerTotalSales
FROM Sales.Orders;

/*
Q20
Display every order with the total sales handled by each salesperson.
*/
SELECT OrderID,
       SalesPersonID,
       Sales,
       SUM(Sales) OVER(PARTITION BY SalesPersonID) AS TotalSalesPerSalesPerson
FROM Sales.Orders;