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
