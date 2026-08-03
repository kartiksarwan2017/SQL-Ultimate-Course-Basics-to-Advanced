/**************** SQL VALUE WINDOW FUNCTIONS PRACTICE QUESTIONS *******************/

USE SalesDB;

/*
Pattern 1 — LAG() (Previous Row)
Clue Words
previous
yesterday
last order
previous sale
before
prior
difference from previous

Think

LAG(column) OVER(...)
*/

/*
Q1 Display every order with the previous order's sales.

Output
OrderID
OrderDate
Sales
PreviousSales
*/
SELECT OrderID,
       OrderDate,
       Sales,
       LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSales
FROM Sales.Orders;

/*
Q2 Display every employee with the previous employee's salary based on salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LAG(Salary) OVER(ORDER BY EmployeeID) AS PreviousEmployeeSalary
FROM Sales.Employees;

/*
You wrote:

LAG(Salary) OVER(ORDER BY EmployeeID)

It should be

LAG(Salary) OVER(ORDER BY Salary)

Because the clue explicitly says based on salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LAG(Salary) OVER(ORDER BY Salary) AS PreviousEmployeeSalary
FROM Sales.Employees;


/*
Q3 Display every product with the previous product price based on price.
*/
SELECT ProductID,
       Product,
       Price,
       LAG(Price) OVER(ORDER BY ProductID) AS PreviousProductPrice
FROM Sales.Products;

/*
You wrote

ORDER BY ProductID

Better
LAG(Price) OVER(ORDER BY Price)
*/
SELECT ProductID,
       Product,
       Price,
       LAG(Price) OVER(ORDER BY Price) AS PreviousProductPrice
FROM Sales.Products;


/*
Q4 Display every order with the previous order date.
*/
SELECT OrderID,
       OrderDate,
       LAG(OrderDate) OVER(ORDER BY OrderDate) AS PreviousOrderDate
FROM Sales.Orders;


/*
Q5 Display every customer's score along with the previous customer's score ordered by CustomerID.
*/
SELECT CustomerID,
       Score,
       LAG(Score) OVER(ORDER BY CustomerID) AS PreviousCustomerScore
FROM Sales.Customers;



/*
Q6 Display every order and calculate the difference between current sales and previous sales.

Output
OrderID
Sales
PreviousSales
Difference
*/
SELECT OrderID,
       Sales,
       LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSales,
       Sales - LAG(Sales) OVER(ORDER BY OrderDate) AS Difference
FROM Sales.Orders;



/*
Q7 Display every employee and the salary increase compared to the previous salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LAG(Salary) OVER(ORDER BY EmployeeID) AS PreviousSalary,
       Salary - LAG(Salary) OVER(ORDER BY EmployeeID) AS SalaryIncrease
FROM Sales.Employees;

/*
You used
ORDER BY EmployeeID
Usually better is
ORDER BY Salary
unless the question says
previous employee
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LAG(Salary) OVER(ORDER BY Salary) AS PreviousSalary,
       Salary - LAG(Salary) OVER(ORDER BY Salary) AS SalaryIncrease
FROM Sales.Employees;


/*
Q8 Display each order with the previous order handled by the same salesperson.
(Hint: PARTITION BY SalesPersonID)
*/
SELECT OrderID,
       SalesPersonID,
       OrderDate,
       LAG(OrderID) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate) AS PreviousOrder
FROM Sales.Orders;


/*
Q9 Display every product with the previous price within the same category.
*/
SELECT ProductID,
       Product,
       Category,
       Price,
       LAG(Price) OVER(PARTITION BY Category ORDER BY ProductID) AS PreviousPrice
FROM Sales.Products;

/*
Ordering by ProductID is reasonable here.
Could also use
ORDER BY Price
depending on business meaning.
*/


/*
Q10 Display every customer with the previous score in the same country.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       Score,
       LAG(Score) OVER(PARTITION BY Country ORDER BY CustomerID) AS PreviousScore
FROM Sales.Customers;


/*************** Pattern 2 — LEAD() (Next Row) ***************

Clue Words
next
upcoming
following
after
next sale
future

Think
LEAD(column) OVER(...)

*/

/*
Q11 Display every order with the next order's sales.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       LEAD(Sales) OVER(ORDER BY OrderDate) AS NextOrderSale
FROM Sales.Orders;



/*
Q12 Display every employee with the next employee's salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LEAD(Salary) OVER(ORDER BY Salary) AS NextEmployeeSalary
FROM Sales.Employees;

/*
Q13 Display every product with the next product price.
*/
SELECT ProductID,
       Product,
       Price,
       LEAD(Price) OVER(ORDER BY Price) AS NextProductPrice
FROM Sales.Products;

/*
Q14 Display every order with the next order date.
*/
SELECT OrderID,
       OrderDate,
       LEAD(OrderDate) OVER(ORDER BY OrderDate) AS NextOrderDate
FROM Sales.Orders;

/*
Q15 Display every customer's score with the next customer's score.
*/
SELECT CustomerID,
       Score,
       LEAD(Score) OVER(ORDER BY Score) AS NextCustomerScore
FROM Sales.Customers;

/*
The question says:

Display every customer's score with the next customer's score.

Since it doesn't mention "based on score," the safer interpretation is:

LEAD(Score) OVER(ORDER BY CustomerID)

or another stable customer ordering.

If the question had said:

next score based on score

then ORDER BY Score would be correct.
*/
SELECT CustomerID,
       Score,
       LEAD(Score) OVER(ORDER BY CustomerID) AS NextCustomerScore
FROM Sales.Customers;


/*
Q16 Display the difference between current sales and next sales.
*/
SELECT OrderID,
       Sales,
       LEAD(Sales) OVER(ORDER BY Sales) AS NextSales,
       LEAD(Sales) OVER(ORDER BY OrderDate) - Sales AS SalesDifference
FROM Sales.Orders;

/*
The question simply says:

difference between current sales and next sales

If no ordering is specified, I would use the business sequence:

ORDER BY OrderDate

or

ORDER BY OrderID

Using ORDER BY Sales compares neighboring sales values rather than consecutive orders.
*/

/*
Q17 Display every employee with the salary difference from the next employee.
*/
SELECT EmployeeID,
       Salary,
       LEAD(Salary) OVER(ORDER BY EmployeeID) AS NextEmployeeSalary,
       LEAD(Salary) OVER(ORDER BY EmployeeID) - Salary AS SalaryDifference
FROM Sales.Employees;

/*
If the intention is:

salary difference from the next employee

this is acceptable.

If the question meant salary sequence, then

ORDER BY Salary

would be better.

Because the wording is slightly ambiguous, your solution is still reasonable.
*/

/*
Q18 Display every salesperson's order with the next order handled by the same salesperson.
*/
SELECT OrderID,
       SalesPersonID,
       OrderDate,
       LEAD(OrderID) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate)
FROM Sales.Orders;

/*
Q19 Display every product with the next product price within the same category.
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       LEAD(Price) OVER(PARTITION BY Category ORDER BY Price) AS NextProductPrice
FROM Sales.Products;


/*
Q20 Display every customer with the next score in the same country.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       Score,
       LEAD(Score) OVER(PARTITION BY Country ORDER BY CustomerID) AS NextScore
FROM Sales.Customers;

/*
The question says:

next score in the same country

Without "based on score," I would normally write:

PARTITION BY Country
ORDER BY CustomerID

or

ORDER BY FirstName

depending on how customers are naturally ordered.

Still, your logic is valid if you intentionally want to compare customers sorted by score.
*/

/*
Pattern 3 — FIRST_VALUE()
Clue Words
first
earliest
oldest
lowest
first order
first salary

Think

FIRST_VALUE(column)
OVER(...)
*/
/*
Q21 Display every order with the first sales amount.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       FIRST_VALUE(Sales) OVER(ORDER BY OrderDate) AS FirstSalesAmount
FROM Sales.Orders;

/*
Q22 Display every employee with the lowest salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName, 
       Salary,
       FIRST_VALUE(Salary) OVER(ORDER BY EmployeeID) AS LowestSalary
FROM Sales.Employees;

/*
Question

Lowest salary

EmployeeID has nothing to do with salary.

Correct

FIRST_VALUE(Salary)
OVER(ORDER BY Salary)
*/
SELECT EmployeeID,
       FirstName,
       LastName, 
       Salary,
       FIRST_VALUE(Salary) OVER(ORDER BY Salary) AS LowestSalary
FROM Sales.Employees;

/*
Q23 Display every product with the lowest product price.
*/
SELECT ProductID,
       Product,
       Price,
       FIRST_VALUE(Price) OVER(ORDER BY ProductID) AS LowestProductPrice
FROM Sales.Products;

/*
Question

Lowest product price

Correct

FIRST_VALUE(Price)
OVER(ORDER BY Price)
*/
SELECT ProductID,
       Product,
       Price,
       FIRST_VALUE(Price) OVER(ORDER BY Price) AS LowestProductPrice
FROM Sales.Products;

/*
Q24 Display every customer with the first customer score.
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Score,
       FIRST_VALUE(Score) OVER(ORDER BY CustomerID) AS FirstCustomerScore
FROM Sales.Customers;

/*
Q25 Display every salesperson's orders with the first sale made by that salesperson.
*/
SELECT SalesPersonID,
       OrderID,
       OrderDate,
       Sales,
       FIRST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate) AS FirstSales
FROM Sales.Orders;

/*
Q26 Display every customer's orders with the first order date.
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate
FROM Sales.Orders;


/*
Q27 Display every category with the lowest priced product.
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       FIRST_VALUE(Price) OVER(ORDER BY ProductID) AS LowestPricedProduct
FROM Sales.Products;

/*
Question

Lowest priced product in each category

Need

FIRST_VALUE(Price)
OVER(
PARTITION BY Category
ORDER BY Price
)

You missed both:

PARTITION BY Category
ORDER BY Price
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       FIRST_VALUE(Price) OVER(PARTITION BY Category ORDER BY Price) AS LowestPricedProduct
FROM Sales.Products;

/*
Q28 Display every country with the first customer score.
*/
SELECT CustomerID,
       Country,
       Score,
       FIRST_VALUE(Score) OVER(ORDER BY CustomerID) AS FirstCustomerScore
FROM Sales.Customers;

/*
You wrote

PARTITION BY none
ORDER BY CustomerID

Question

Every country with first customer score

Need

FIRST_VALUE(Score)
OVER(
PARTITION BY Country
ORDER BY CustomerID
)
*/
SELECT CustomerID,
       Country,
       Score,
       FIRST_VALUE(Score) OVER(PARTITION BY Country ORDER BY CustomerID) AS FirstCustomerScore
FROM Sales.Customers;


/*
Q29 Display every employee with the first salary in the department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       FIRST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY EmployeeID) AS FirstSalary
FROM Sales.Employees;

/*
First salary in department

You used

ORDER BY EmployeeID

Business question:

First salary?

or

Lowest salary?

Usually interviewers mean

FIRST_VALUE(Salary)
OVER(
PARTITION BY Department
ORDER BY Salary
)
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       FIRST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY Salary) AS FirstSalary
FROM Sales.Employees;


/*
Q30 Display every product with the first product alphabetically in its category.
*/
SELECT ProductID,
       Product,
       Category,
       FIRST_VALUE(Product) OVER(PARTITION BY Category ORDER BY Product) AS FirstProduct
FROM Sales.Products;


/*
Pattern 4 — LAST_VALUE()
Clue Words
last
latest
newest
final
most recent

Think

LAST_VALUE(column)
OVER(
...
ROWS BETWEEN
UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
)
*/
/*
Q31 Display every order with the last sales amount.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       LAST_VALUE(Sales) OVER(ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSalesAmount
FROM Sales.Orders;


/*
Q32 Display every employee with the highest salary.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       LAST_VALUE(Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestSalary
FROM Sales.Employees;

/*
Q33 Display every product with the highest product price.
*/
SELECT ProductID,
       Product,
       Price,
       LAST_VALUE(Price) OVER(ORDER BY Price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestProductPrice
FROM Sales.Products;

/*
Q34 Display every customer with the last customer score.
*/
SELECT CustomerID,
       Score,
       LAST_VALUE(Score) OVER(ORDER BY CustomerID ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastCustomerScore
FROM Sales.Customers;

/*
Question

Last customer score

Means score of last customer.

Acceptable.

If interviewer asked

Highest score

↓

ORDER BY Score
*/

/*
Q35 Display every salesperson's orders with the last sale made by that salesperson.
*/
SELECT OrderID,
       SalesPersonID,
       OrderDate,
       Sales,
       LAST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSale
FROM Sales.Orders;

/*
Q36 Display every customer's orders with the latest order date.
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate
FROM Sales.Orders;

/*
Q37 Display every category with the highest priced product.
*/
SELECT Product,
       Category,
       Price,
       LAST_VALUE(Price) OVER(PARTITION BY Category ORDER BY Price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestPriceProduct
FROM Sales.Products;

/*
Q38 Display every country with the highest customer score.
*/
SELECT CustomerID,
       Country,
       Score,
       LAST_VALUE(Score) OVER(PARTITION BY Country ORDER BY Score ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestCustomerScore
FROM Sales.Customers;

/*
Q39 Display every employee with the last salary in the department.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       LAST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY EmployeeID ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSalary
FROM Sales.Employees;

/*
Question

Last salary

Usually interviewer means

Highest salary
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       LAST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSalary
FROM Sales.Employees;

/*
Q40 Display every product with the last product alphabetically in its category.
*/
SELECT ProductID,
       Product,
       Category,
       LAST_VALUE(Product) OVER(PARTITION BY Category ORDER BY Product ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastProduct
FROM Sales.Products;


/************ Pattern 5 — Interview Favorites (Mixed) *****************/
/*
Q41
Display every order with:

Previous Sales
Next Sales
*/
SELECT OrderID,
       Sales,
       LAG(Sales) OVER(ORDER BY Sales) AS PreviousSales,
       LEAD(Sales) OVER(ORDER BY Sales) AS NextSales
FROM Sales.Orders;


/*
Q42 Display every order and calculate:

Difference from Previous Sale
Difference to Next Sale
*/
SELECT OrderID,
       Sales,
       LAG(Sales) OVER(ORDER BY Sales) AS PreviousSales,
       Sales - LAG(Sales) OVER(ORDER BY Sales) AS PreviousSaleDiff,
       LEAD(Sales) OVER(ORDER BY Sales) AS NextSales,
       LEAD(Sales) OVER(ORDER BY Sales) - Sales AS NextSaleDiff
FROM Sales.Orders;



/*
Q43

Display every employee with:

Lowest salary in department
Highest salary in department
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Department,
       Salary,
       FIRST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY Salary) AS LowestSalary,
       LAST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestSalary
FROM Sales.Employees;


/*
Q44

Display every customer's orders with:

First Order Date
Latest Order Date
*/
SELECT CustomerID,
       OrderID,
       OrderDate,
       FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrderDate,
       LAST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LatestOrderDate
FROM Sales.Orders;


/*
Q45

Display every product with:

Previous Price
Next Price
Lowest Price in Category
Highest Price in Category
*/
SELECT ProductID,
       Product,
       Category, 
       Price,
       LAG(Price) OVER(PARTITION BY Category ORDER BY Price) AS PreviousPrice,
       LEAD(Price) OVER(PARTITION BY Category ORDER BY Price) AS NextPrice,
       FIRST_VALUE(Price) OVER(PARTITION BY Category ORDER BY Price) AS LowestPrice,
       LAST_VALUE(Price) OVER(PARTITION BY Category ORDER BY Price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestPrice
FROM Sales.Products;


/*
Q46 Display every salesperson's orders with:

Previous Sale
Next Sale
First Sale
Last Sale
*/
SELECT SalesPersonID,
       OrderID,
       Sales,
       LAG(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS PreviousSales,
       LEAD(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS NextSales,
       FIRST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS FirstSale,
       LAST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSale
FROM Sales.Orders;

-- CORRECT QUERY
/*
If someone asks

First Sale

I would ask

first according to sales?

or

first according to date?

Business usually means

ORDER BY OrderDate

rather than

ORDER BY Sales

unless the question explicitly says

lowest sale
or
highest sale.
*/
SELECT SalesPersonID,
       OrderID,
       OrderDate,
       Sales,
       LAG(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS PreviousSales,
       LEAD(Sales) OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS NextSales,
       FIRST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate) AS FirstSale,
       LAST_VALUE(Sales) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSale
FROM Sales.Orders;


/*
Q47 Display every customer's score with:

Previous Score
Next Score

within the same country.
*/
SELECT CustomerID,
       Country,
       Score,
       LAG(Score) OVER(PARTITION BY Country ORDER BY Score) AS PreviousScore,
       LEAD(Score) OVER(PARTITION BY Country ORDER BY Score) AS NextScore
FROM Sales.Customers;


/*
Q48 Display every order and classify sales as:

Increased
Decreased
Same

compared to the previous order.

(Hint: LAG() + CASE)
*/
SELECT OrderID,
       OrderDate,
       CurrentSales,
       PreviousSale,
       SalesClassification
FROM (
    SELECT OrderID,
           OrderDate,
           COALESCE(Sales, 0) AS CurrentSales,
           LAG(COALESCE(Sales, 0)) OVER(ORDER BY OrderDate) AS PreviousSale,
           CASE WHEN Sales > LAG(Sales) OVER(ORDER BY OrderDate) THEN 'Increased'
                WHEN Sales < LAG(Sales) OVER(ORDER BY OrderDate) THEN 'Decreased'
                ELSE 'Same' 
           END AS SalesClassification
    FROM Sales.Orders
) AS t;


-- BETTER QUERY
SELECT *,
       CASE
           WHEN CurrentSales > PreviousSale THEN 'Increased'
           WHEN CurrentSales < PreviousSale THEN 'Decreased'
           ELSE 'Same'
       END AS SalesClassification
FROM (
    SELECT OrderID,
           OrderDate,
           Sales AS CurrentSales,
           LAG(Sales) OVER(ORDER BY OrderDate) AS PreviousSale
    FROM Sales.Orders
) AS t;


/*
Q49 Display every employee whose salary is greater than the previous employee's salary.

(Hint: LAG() in a derived table or CTE, then filter.)
*/
SELECT *
FROM (
    SELECT EmployeeID,
            FirstName,
            LastName,
            Salary,
            LAG(Salary) OVER(ORDER BY EmployeeID) AS PreviousEmpSalary
    FROM Sales.Employees
) AS t
WHERE Salary > PreviousEmpSalary;


/*
Q50 Display every product whose price is equal to the highest price in its category.

(Hint: LAST_VALUE() or MAX() OVER(PARTITION BY ...))
*/
SELECT *
FROM (
    SELECT ProductID,
           Product,
           Category,
           Price,
           LAST_VALUE(Price) OVER(PARTITION BY Category ORDER BY Price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestPrice
    FROM Sales.Products
) AS t
WHERE Price = HighestPrice;


SELECT *
FROM (
     SELECT ProductID,
            Product,
            Category,
            Price,
            MAX(Price) OVER(PARTITION BY Category) AS HighestPrice
     FROM Sales.Products
) AS t
WHERE Price = HighestPrice;
