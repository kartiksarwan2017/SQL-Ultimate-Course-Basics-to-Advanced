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

/**************** Pattern 3 — CTE + Aggregation ****************/
/*
Q9. Top 3 customers by total sales

First calculate total sales for every customer.
Then rank the customers.
Return the top 3.

Output:

CustomerID
TotalSales
SalesRank
*/
WITH CTE_Customer_Total_Sales AS (
   SELECT CustomerID,
          FirstName,
          LastName,
          TotalSales,
          RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
   FROM (
     SELECT c.CustomerID,
            c.FirstName,
            c.LastName,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Customers AS c
     INNER JOIN Sales.Orders AS o
     ON o.CustomerID = c.CustomerID
     GROUP BY c.CustomerID, c.FirstName, c.LastName
   ) t
)
SELECT CustomerID,
       FirstName,
       LastName,
       TotalSales
FROM CTE_Customer_Total_Sales
WHERE SalesRank <= 3;


/*
You correctly did:

Aggregate sales by customer.
Rank the aggregated results.
Filter SalesRank <= 3.

The important part is:

RANK() OVER(ORDER BY TotalSales DESC)

Your nested derived table works correctly.

One improvement

The question specifically says use CTE, and you did use a CTE, 
but you're doing the aggregation inside a derived table and ranking inside the CTE.
*/
WITH CTE_Customer_Total_Sales AS (
     SELECT c.CustomerID,
            c.FirstName,
            c.LastName,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Customers AS c
     INNER JOIN Sales.Orders AS o
     ON c.CustomerID = o.CustomerID
     GROUP BY c.CustomerID, c.FirstName, c.LastName
),
CTE_Customer_Rank AS (
    SELECT *,
           RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
    FROM CTE_Customer_Total_Sales
)
SELECT CustomerID,
       FirstName,
       LastName,
       TotalSales,
       SalesRank
FROM CTE_Customer_Rank
WHERE SalesRank <= 3


/*
Q10. Top-selling product in each category

Calculate total sales for every product and then find the highest-selling product from each category.
If there is a tie, return all tied products.
*/
SELECT ProductID,
       Product,
       Category, 
       TotalSales
FROM (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) TotalSales,
           RANK() OVER(PARTITION BY Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.Product, p.ProductID
) t
WHERE SalesRank = 1;


WITH CTE_Top_Selling_Product AS (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) TotalSales,
           RANK() OVER(PARTITION BY Category ORDER BY SUM(o.Sales) DESC) AS SalesRank
    FROM Sales.Products AS p
    INNER JOIN Sales.Orders AS o
    ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.Product, p.ProductID
)
SELECT ProductID,
       Product,
       Category,
       TotalSales
FROM CTE_Top_Selling_Product 
WHERE SalesRank = 1;



/*
Q11. Salesperson performance

Calculate total sales for every salesperson and classify them:

Top Performer → TotalSales > 200
Average Performer → TotalSales > 100
Needs Improvement → otherwise

Use a CTE.
*/
WITH CTE_SalesPerson_TotalSales AS (
     SELECT e.EmployeeID,
            e.FirstName,
            e.LastName,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Employees AS e
     INNER JOIN Sales.Orders AS o
     ON e.EmployeeID = o.SalesPersonID
     GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT EmployeeID,
       FirstName,
       LastName,
       TotalSales,
       CASE WHEN TotalSales > 200 THEN 'Top Performer'
            WHEN TotalSales > 100 THEN 'Average Performer'
            ELSE 'Needs Improvement'
       END AS SalesPerformance
FROM CTE_SalesPerson_TotalSales; 


/*
Your CTE:

SUM(o.Sales) AS TotalSales

groups by salesperson, then the outer query classifies them.

Your CASE ordering is also correct:

CASE
    WHEN TotalSales > 200 THEN 'Top Performer'
    WHEN TotalSales > 100 THEN 'Average Performer'
    ELSE 'Needs Improvement'
END

Why is the ordering important?

Because someone with TotalSales = 250 satisfies both:

> 200
> 100
SQL takes the first matching condition, so checking > 200 first is correct.
*/



/*
Q12. Customers above average customer sales

First calculate total sales for every customer.

Then calculate the average of those customer totals.

Finally display customers whose total sales are above the average customer total.

This is an important interview pattern:

CTE 1 → customer totals
CTE 2 → average of customer totals
Final query → compare
*/
WITH CTE_TotalSales_Customer AS (
     SELECT c.CustomerID, 
            c.FirstName,
            c.LastName,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Customers AS c
     INNER JOIN Sales.Orders AS o
     ON c.CustomerID = o.CustomerID
     GROUP BY c.CustomerID, c.FirstName, c.LastName
),
CTE_Customer_Average AS (
     SELECT AVG(TotalSales) AS AverageCustomerTotals
     FROM CTE_TotalSales_Customer
)
SELECT CustomerID,
       FirstName,
       LastName,
       TotalSales
FROM CTE_TotalSales_Customer
WHERE TotalSales > (
      SELECT AverageCustomerTotals
      FROM CTE_Customer_Average
);

/*********** Pattern 4 — Multiple / Nested CTEs ***********/
/*
Q13. Department salary analysis

Create a CTE containing:

Department
AverageSalary

Create another CTE containing employee information.

Display employees whose salary is above their department average.
*/
WITH CTE_Department_Average AS (
     SELECT Department,
            AVG(Salary) AS AverageSalary
     FROM Sales.Employees
     GROUP BY Department
),
CTE_Employee_Information AS (
     SELECT *
     FROM Sales.Employees
)
SELECT *
FROM CTE_Employee_Information AS cei
WHERE Salary > (
      SELECT AverageSalary
      FROM CTE_Department_Average AS cda
      WHERE cei.Department = cda.Department
)

/*
One improvement

Your second CTE isn't really necessary:

CTE_Employee_Information AS (
    SELECT *
    FROM Sales.Employees
)

You could simply use Sales.Employees in the final query.

But because the question explicitly asked for an employee-information CTE, your answer satisfies the requirement.
*/

/*
Q14. Customer sales classification

Create a CTE for customer total sales.

Then classify customers:

TotalSales > 150 → Premium
TotalSales > 80  → Regular
Otherwise        → New Customer

Return:

CustomerID
FirstName
LastName
TotalSales
CustomerCategory
*/
WITH CTE_Customer_Total_Sales AS (
     SELECT c.CustomerID,
            c.FirstName,
            c.LastName,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Customers AS c
     INNER JOIN Sales.Orders AS o
     ON c.CustomerID = o.CustomerID
     GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT CustomerID,
       FirstName,
       LastName,
       TotalSales,
       CASE WHEN TotalSales > 150 THEN 'Premium'
            WHEN TotalSales > 80 THEN 'Regular'
            ELSE 'New Customer'
       END AS CustomerCategory
FROM CTE_Customer_Total_Sales;




/*
Q15. Category performance

Create one CTE for product-category total sales.

Create another CTE for the overall average category sales.

Display categories whose total sales are greater than the overall average category sales.
*/
WITH CTE_Product_Category_Sales AS (
     SELECT p.ProductID,
            p.Product,
            p.Category,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Products AS p
     INNER JOIN Sales.Orders AS o
     ON p.ProductID = o.ProductID
     GROUP BY p.ProductID,
              p.Category,
              p.Product
),
CTE_Average_Category_Sales AS (
     SELECT *,
            SUM(TotalSales) OVER(PARTITION BY Category) AS AvgCategorySales
     FROM CTE_Product_Category_Sales
)
SELECT *
FROM CTE_Average_Category_Sales
WHERE TotalSales > (
      SELECT AVG(AvgCategorySales)
      FROM CTE_Average_Category_Sales 
);

/*
This is where I want you to slow down.

Your first CTE
WITH CTE_Product_Category_Sales AS (
    SELECT p.ProductID,
           p.Product,
           p.Category,
           SUM(o.Sales) AS TotalSales
    ...
    GROUP BY p.ProductID, p.Category, p.Product
)

This calculates:

Total sales for each product

not total sales for each category.

For example, imagine:

Category	Product	TotalSales
Clothing	Shirt	100
Clothing	Jeans	200
Accessories	Belt	50
Accessories	Bag	    150

Your CTE produces product-level totals.

But the question asks for:

category total sales

So we need:

Category	TotalCategorySales
Clothing	     300
Accessories	     200
Your second CTE also has a problem

You wrote:

SUM(TotalSales) OVER(PARTITION BY Category) AS AvgCategorySales

The name AvgCategorySales is misleading.

This is:

SUM

not:

AVG

It actually calculates total sales for the category, repeated on every product row.

For example:

Category	Product	TotalSales	AvgCategorySales
Clothing	Shirt	100	         300
Clothing	Jeans	200	         300

So the value 300 is the category total, not average category sales.

The bigger issue

You then do:

SELECT AVG(AvgCategorySales)
FROM CTE_Average_Category_Sales

Because AvgCategorySales is repeated once for every product, you're averaging duplicated category totals.

That can produce the wrong overall average.
*/
WITH CTE_Category_Sales AS (
     SELECT p.Category,
            SUM(o.Sales) AS TotalSales
     FROM Sales.Products AS p
     INNER JOIN Sales.Orders AS o
     ON p.ProductID = o.ProductID
     GROUP BY p.Category
), 
CTE_AverageCategory_Sales AS (
    SELECT AVG(TotalSales) AS AverageCategorySales
    FROM CTE_Category_Sales
)
SELECT Category, 
       TotalSales
FROM CTE_Category_Sales
WHERE TotalSales > (
      SELECT AverageCategorySales
      FROM CTE_AverageCategory_Sales
);

/************ Pattern 5 — CTE + LAG / LEAD ************/
/*
Q16. Sales change

Display every order with:

OrderID
OrderDate
Sales
PreviousSales
SalesDifference

Use a CTE containing LAG().

Then calculate the difference outside the CTE.
*/





/*
Q17. Increasing sales orders

Display orders where the current sale is greater than the previous order's sale.

Output:

OrderID
OrderDate
Sales
PreviousSales

Think:

CTE
 ↓
LAG()
 ↓
WHERE Sales > PreviousSales
*/





/*
Q18. Customer order gap

For every customer, display:

CustomerID
OrderID
OrderDate
PreviousOrderDate
DaysBetweenOrders

Use LAG() inside a CTE and calculate the date difference outside.
*/


/************* Pattern 6 — CTE + Multiple Window Functions ************/
/*
Q19. Employee salary analysis

Display every employee with:

EmployeeID
Department
Salary
DepartmentAverageSalary
DepartmentHighestSalary
SalaryRank

Use a CTE.

You should need:

AVG() OVER()
MAX() OVER()
RANK() OVER()
*/




/*
Q20. Customer order analysis — Interview Challenge

For every customer, display:

CustomerID
OrderID
OrderDate
Sales
FirstOrderDate
LatestOrderDate
PreviousOrderDate
CustomerTotalSales
CustomerOrderRank

This combines:

FIRST_VALUE()
LAST_VALUE()
LAG()
SUM() OVER()
ROW_NUMBER()
PARTITION BY
*/


