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


/*
Pattern 3 — Running Aggregate (ORDER BY)

Clue Words

cumulative
running
till now
progressive total

Think

SUM(...) OVER(
ORDER BY ...
)
*/
/*
Q21 Display every order with the running total sales based on OrderDate.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       SUM(Sales) OVER(ORDER BY OrderDate) AS TotalSales
FROM Sales.Orders;



/*
Q22 Display every order with the running count of orders.
*/
SELECT OrderID,
       OrderDate,
       COUNT(OrderID) OVER(ORDER BY OrderDate) AS RunningCountOfOrders
FROM Sales.Orders;



/*
Q23 Display every order with the running average sales.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       AVG(Sales) OVER(ORDER BY OrderDate) AS RunningAverageSales
FROM Sales.Orders;


/*
Q24 Display every order with the running maximum sales.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       MAX(Sales) OVER(ORDER BY OrderDate) AS RunningMaximumSales
FROM Sales.Orders;



/*
Q25 Display every order with the running minimum sales.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       MIN(Sales) OVER(ORDER BY OrderDate) AS RunningMinimumSales
FROM Sales.Orders;


/*
Pattern 4 — Ranking Functions (Basic)

Clue Words

rank
top
highest
lowest
order

Think

ROW_NUMBER()

RANK()

DENSE_RANK()

NTILE()
*/
/*
Q26 Assign a row number to every employee based on salary (highest first).
*/
SELECT EmployeeID,
       Salary,
       ROW_NUMBER() OVER(ORDER BY Salary DESC) AS EmployeeRanking
FROM Sales.Employees;

/*
Q27 Assign a rank to every employee based on salary.
*/
SELECT EmployeeID,
       Salary,
       RANK() OVER(ORDER BY Salary) AS RankBasedOnSalary
FROM Sales.Employees;

/*
This is syntactically correct.

However, in interviews, when they say:

"Rank employees based on salary"

the default assumption is usually highest salary gets Rank 1.

So I would write:

SELECT EmployeeID,
       Salary,
       RANK() OVER(ORDER BY Salary DESC) AS RankBasedOnSalary
FROM Sales.Employees;
*/

/*
Q28 Assign a dense rank to every employee based on salary.
*/
SELECT EmployeeID,
       Salary,
       DENSE_RANK() OVER(ORDER BY Salary) AS EmployeeRank
FROM Sales.Employees;

/*
because ranking generally implies the highest value gets the best rank unless the question specifies otherwise.
*/
SELECT EmployeeID,
       Salary,
       DENSE_RANK() OVER(ORDER BY Salary DESC) AS EmployeeRank
FROM Sales.Employees;


/*
Q29 Assign a row number to every order based on sales.
ask yourself:

Should the biggest sales get Row 1?
Usually yes.

*/
SELECT OrderID,
       OrderDate,
       Sales,
       ROW_NUMBER() OVER(ORDER BY Sales DESC) AS EmployeeRank
FROM Sales.Orders;


/*
Q30 Assign a rank to every product based on price.
*/
SELECT ProductID,
       Product,
       Price,
       RANK() OVER(ORDER BY Price DESC) AS ProductRanking
FROM Sales.Products;


/*
Pattern 5 — Ranking + PARTITION BY

Clue Words

within department
per customer
within category
*/
/*
Q31 Assign row numbers to employees within each department based on salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalesRank
FROM Sales.Employees;


/*
Q32
Rank employees within each department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS DepartmentRank
FROM Sales.Employees;


/*
Q33
Dense rank products within each category based on price.
*/
SELECT ProductID,
       Product,
       Category,
       Price,
       DENSE_RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
FROM Sales.Products;

/*
Q34
Assign row numbers to orders of each customer based on order date.
*/
SELECT OrderID,
       CustomerID,
       OrderDate,
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS OrderDateRank
FROM Sales.Orders;

/*
Q35
Rank orders of every customer based on sales.
*/
SELECT OrderID,
       CustomerID,
       Sales,
       RANK() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;

/*
Q36
Dense rank customers within each country based on score.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country, 
       Score,
       DENSE_RANK() OVER(PARTITION BY Country ORDER BY Score DESC) AS ScoreRank
FROM Sales.Customers;

/*
Q37
Assign row numbers to products within each category based on price.
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
FROM Sales.Products;

/*
Q38
Rank products within each category based on price.
*/
SELECT ProductID,
       Product,
       Category,
       Price,
       RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
FROM Sales.Products;

/*
Q39
Assign row numbers to orders handled by each salesperson based on sales.
*/
SELECT OrderID,
       SalesPersonID,
       OrderDate,
       Sales,
       ROW_NUMBER() OVER(PARTITION BY SalesPersonID ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;

/*
Q40
Rank employees within each department by birth date (oldest first).
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       BirthDate,
       RANK() OVER(PARTITION BY Department ORDER BY BirthDate) AS BirthDateRank
FROM Sales.Employees;


/*
Pattern 6 — Interview Favorites
These are the questions interviewers ask most often.
*/
/*
Q41
Display the highest paid employee.
(Hint: RANK() or ROW_NUMBER())
*/
SELECT *
FROM 
(
    SELECT EmployeeID,
            FirstName,
            LastName,
            Salary,
            RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank = 1;



/*
Q42
Display the second highest salary.
*/
SELECT *
FROM (
    SELECT EmployeeID,
           Salary,
           RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t 
WHERE SalaryRank = 2;

/*
Q43
Display the top 2 salaries.
*/
SELECT TOP 2 SalaryRank, 
       EmployeeID,
       Salary
FROM (
    SELECT EmployeeID,
           Salary,
           ROW_NUMBER() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t;

SELECT *
FROM (
    SELECT EmployeeID,
           Salary,
           ROW_NUMBER() OVER(ORDER BY Salary DESC) AS SalaryRank
    FROM Sales.Employees
) t
WHERE SalaryRank <= 2;

/*
Q44
Display the highest selling order.
*/
SELECT *
FROM (
    SELECT OrderID,
           OrderDate,
           Sales,
           RANK() OVER(ORDER BY Sales DESC) AS SalesRank
    FROM Sales.Orders
) t
WHERE SalesRank = 1;

/*
Q45
Display the top-selling product based on total sales.
*/
SELECT *
FROM (
    SELECT p.ProductID,
           p.Product,
           SUM(o.Sales) AS TotalSales,
           ROW_NUMBER() OVER(ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Product
) t
WHERE SalesRank = 1;


/*
Q46
Display the latest order of every customer.
*/
SELECT *
FROM (
    SELECT c.CustomerID,
           c.FirstName,
           c.LastName,
           o.OrderID,
           o.OrderDate,
           ROW_NUMBER() OVER(PARTITION BY c.CustomerID ORDER BY o.OrderDate DESC) AS OrderDateRank
    FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
) t
WHERE OrderDateRank = 1;


SELECT *
FROM (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
    FROM Sales.Orders
) t
WHERE OrderDateRank = 1;





/*
Q47
Display the highest sale made by every salesperson.
*/
SELECT *
FROM (
    SELECT OrderID,
           SalesPersonID,
           Sales,
           RANK() OVER(PARTITION BY SalesPersonID ORDER BY Sales DESC) AS SalesRank
    FROM Sales.Orders
) t
WHERE SalesRank = 1;

/*
Q48
Display the highest priced product in each category.
*/
SELECT *
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
Q49
Display the top 2 customers based on total sales.
*/
SELECT *
FROM (
    SELECT CustomerID,
           SUM(Sales) AS TotalSales,
           ROW_NUMBER() OVER(ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM Sales.Orders
    GROUP BY CustomerID
) t
WHERE SalesRank <= 2;

/*
Use:

ROW_NUMBER() OVER(ORDER BY SUM(Sales) DESC)

or even better:

RANK() OVER(ORDER BY SUM(Sales) DESC)

if you want tied customers included.
*/


/*
Q50
Divide employees into 4 salary groups using NTILE(4).
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       NTILE(4) OVER(ORDER BY Salary) AS EmployeeGroups
FROM Sales.Employees;