/******** CTE Practice — Interview Set Pattern 1 — Standalone CTE ********/
USE SalesDB;

/********* Pattern 1 — Standalone CTE *********/
/*
Q1. Employees above average salary

Display employees whose salary is greater than the company's average salary.

Output:

EmployeeID
FirstName
LastName
Salary

Use a CTE to calculate the average salary.
*/
WITH CTE_Average_Salary AS (
   SELECT AVG(Salary) AS AverageSalary
   FROM Sales.Employees
)
-- Main Query
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM Sales.Employees
WHERE Salary > (
      SELECT AverageSalary
      FROM CTE_Average_Salary
);


/*
Q2. Customers with high total sales

Display customers whose total sales are greater than 150.

Output:

CustomerID
TotalSales

Use:
CTE → GROUP BY → WHERE
*/
WITH CTE_Customer_Total_Sales AS (
     SELECT CustomerID,
            SUM(Sales) AS TotalSales
     FROM Sales.Orders
     GROUP BY CustomerID
)
SELECT CustomerID,
       TotalSales
FROM CTE_Customer_Total_Sales 
WHERE TotalSales > 150;



/*
Q3. Department salary summary

Display every department with:

Department
TotalSalary
AverageSalary
HighestSalary
LowestSalary

Use a CTE.
*/
WITH CTE_Total_Salary AS (
     SELECT EmployeeID,
            Department,
            SUM(Salary) OVER(PARTITION BY Department) AS TotalSalary
     FROM Sales.Employees
),
CTE_Average_Salary AS (
     SELECT EmployeeID,
            Department,
            AVG(Salary) OVER(PARTITION BY Department) AS AverageSalary
     FROM Sales.Employees
),
CTE_Highest_Salary AS (
    SELECT EmployeeID,
           Department,
           MAX(Salary) OVER(PARTITION BY Department) AS HighestSalary
    FROM Sales.Employees
),
CTE_Lowest_Salary AS (
    SELECT EmployeeID,
           Department,
           MIN(Salary) OVER(PARTITION BY Department) AS LowestSalary
    FROM Sales.Employees
)
SELECT e.Department,
       cts.TotalSalary,
       cas.AverageSalary, 
       chs.HighestSalary,
       cls.LowestSalary
FROM Sales.Employees AS e
INNER JOIN CTE_Total_Salary AS cts
ON cts.EmployeeID = e.EmployeeID
INNER JOIN CTE_Average_Salary AS cas
ON cas.EmployeeID = e.EmployeeID
INNER JOIN CTE_Highest_Salary AS chs
ON chs.EmployeeID = e.EmployeeID
INNER JOIN CTE_Lowest_Salary AS cls
ON cls.EmployeeID = e.EmployeeID; 


/*
Your answer will work, but this is unnecessarily complicated.

You created four separate CTEs:

CTE_Total_Salary
CTE_Average_Salary
CTE_Highest_Salary
CTE_Lowest_Salary

and then joined all four back to Employees.

That's a lot of work for one grouped summary.

The business requirement is:

"Give me one row per department."

Whenever you see:

every department + total + average + highest + lowest

think:

GROUP BY Department

You can calculate all four metrics in one CTE.
*/
WITH CTE_Department_Salary AS (
     SELECT Department,
            SUM(Salary) AS TotalSalary,
            AVG(Salary) AS AverageSalary,
            MAX(Salary) AS HighestSalary,
            MIN(Salary) AS LowestSalary
     FROM Sales.Employees
     GROUP BY Department
)
SELECT Department,
       TotalSalary,
       AverageSalary,
       HighestSalary,
       LowestSalary
FROM CTE_Department_Salary;

/*
Senior analyst feedback

Your solution demonstrates that you understand window functions, but you're using them where GROUP BY is the natural tool.

Remember:

One row per group → GROUP BY

Keep every original row + calculate group information → Window Function

This distinction is very important for interviews.
*/


/*
Q4. Products above category average

Display products whose price is greater than the average price of their category.

Output:

ProductID
Product
Category
Price
CategoryAveragePrice

Use a CTE + window function.
*/
WITH CTE_Average_Price AS (
   SELECT ProductID,
          AVG(Price) OVER(PARTITION BY Category) AS CategoryAveragePrice,
          Category
   FROM Sales.Products
)
SELECT p.ProductID,
       p.Product,
       p.Category,
       p.Price,
       cap.CategoryAveragePrice
FROM Sales.Products AS p
INNER JOIN CTE_Average_Price AS cap
ON p.ProductID = cap.ProductID;

/*
This is the one you need to correct. ❌

You correctly created:

AVG(Price) OVER(PARTITION BY Category)

So you successfully calculated the category average.

But the question says:

Display products whose price is greater than the average price of their category.

Your final query doesn't actually compare:

Price > CategoryAveragePrice

You only joined the CTE back to Products.

Therefore, you're currently returning all products, not just products above their category average.

Correct solution

You don't even need the join.
*/
WITH CTE_Average_Price AS (
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
FROM CTE_Average_Price
WHERE Price > CategoryAveragePrice;

/*
Why?

Your CTE already contains everything you need:

ProductID
Product
Category
Price
CategoryAveragePrice

So why go back to Sales.Products?

That's an important SQL optimization/thinking habit:

If the CTE already contains the required columns, don't join the original table again unnecessarily.
*/

/***************** Pattern 2 — CTE + Window Functions ****************/
/*
Q5. Rank employees within department

Display every employee with their salary rank within their department.

Output:
EmployeeID
EmployeeName
Department
Salary
SalaryRank

Use:

CTE → RANK() → PARTITION BY
*/
WITH CTE_Employees_Rank AS (
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Sales.Employees
) 
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       SalaryRank
FROM CTE_Employees_Rank;


/*
Q6. Top 2 employees per department

Display the top 2 highest-paid employees from every department.

If two employees have the same salary, return both.
*/
WITH CTE_Employees_Per_Department AS (
     SELECT EmployeeID,
            FirstName,
            LastName, 
            Department,
            Salary,
            RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
     FROM Sales.Employees
)
SELECT EmployeeID,
       FirstName,
       LastName, 
       Department,
       Salary
FROM CTE_Employees_Per_Department
WHERE SalaryRank <= 2;


/*
Q7. Latest order of every customer

Display the latest order for every customer.

Output:

CustomerID
OrderID
OrderDate
Sales

Use:

CTE → ROW_NUMBER() → PARTITION BY
*/
WITH CTE_CUSTOMER_LATESTORDER AS (
     SELECT CustomerID,
            OrderID,
            OrderDate,
            Sales,
            ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderDateRank
     FROM Sales.Orders
)
SELECT CustomerID,
       OrderID,
       OrderDate,
       Sales
FROM CTE_CUSTOMER_LATESTORDER
WHERE OrderDateRank = 1;


/*
FEEDBACK
Your solution: ✅ Excellent
ROW_NUMBER() OVER(
    PARTITION BY CustomerID
    ORDER BY OrderDate DESC
)

Then:

WHERE OrderDateRank = 1

Perfect.

Your thought process should now automatically be:

"Latest order of every customer"

↓

every customer
→ PARTITION BY CustomerID

latest
→ ORDER BY OrderDate DESC

one latest order
→ ROW_NUMBER() = 1

That's exactly the kind of pattern recognition you need for HackerRank.

One minor real-world consideration

If two orders can have exactly the same OrderDate, ROW_NUMBER() arbitrarily chooses one unless you add a tie-breaker.

For example:

ORDER BY OrderDate DESC, OrderID DESC

But based on the question as given, your answer is completely correct.
*/


/*
Q8. Second-highest product price in every category

Display the second-most-expensive product from every category.

If two products have the same second-highest price, display both.

Think carefully about RANK vs ROW_NUMBER.
*/
WITH CTE_Product AS (
    SELECT ProductID,
           Product,
           Category,
           Price,
           RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS PriceRank
    FROM Sales.Products
) 
SELECT ProductID,
       Product,
       Category,
       Price
FROM CTE_Product
WHERE PriceRank = 2;



