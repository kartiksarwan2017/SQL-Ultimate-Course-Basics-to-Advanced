/******************  SQL CASE WHEN Statement (Visually Explained)  *************************/

USE SalesDB;

/*
SQL TASK
Generate a report showing the total sales for each category:
High: If the sales higher than 50
Medium: If the sales between 20 and 50
Low: If the sales equal or lower than 20

Sort the result from lowest to highest.
*/
SELECT Category,
       SUM(Sales) AS TotalSales
FROM (
SELECT OrderID,
       Sales,
       CASE
           WHEN sales > 50 THEN 'High'
           WHEN sales > 20 THEN 'Medium'
           ELSE 'Low'
       END Category
FROM Sales.Orders
) t
GROUP BY Category
ORDER BY TotalSales DESC;


/*
SQL TASK
Retrieve employee details with gender displayed as full text.
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Gender,
       CASE 
           WHEN Gender = 'F' THEN 'Female'
           WHEN Gender = 'M' THEN 'Male'
           ELSE 'Not Available'
       END GenderFullText
FROM Sales.Employees;

/*
SQL TASK
Retrieve customer details with abbreviated country code
*/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       CASE
           WHEN Country = 'Germany' THEN 'DE'
           WHEN Country = 'USA' THEN 'US'
           ELSE 'Not Available'
       END CountryAbbreviation
FROM Sales.Customers;


/* We can use it in large databases to see all possible values of country. */
SELECT DISTINCT Country
FROM Sales.Customers;


/******** QUICK FORM  ********/
SELECT CustomerID,
       FirstName,
       LastName,
       Country,
       CASE
           WHEN Country = 'Germany' THEN 'DE'
           WHEN Country = 'USA' THEN 'US'
           ELSE 'Not Available'
       END CountryAbbreviation,
       CASE Country
           WHEN 'Germany' THEN 'DE'
           WHEN 'USA' THEN 'US'
           ELSE 'Not Available'
       END CountryAbbreviation2
FROM Sales.Customers;


/*
SQL TASK
Find the average scores of customers and treat NUlls as 0.
And additionally provide details such CustomerID & LastName.
*/
SELECT  CustomerID,
        LastName,
        Score,
        CASE 
            WHEN Score IS NULL THEN 0
            ELSE Score
        END ScoreClean,
        AVG(CASE 
                WHEN Score IS NULL THEN 0
                ELSE Score
            END) OVER() AvgCustomerClean,
        AVG(Score) OVER() AvgCustomer
FROM Sales.Customers;


/*
SQL TASK
Count how many times each customer has made an order with sales greater than 30.
*/
SELECT CustomerID,
       SUM(CASE 
               WHEN Sales > 30 THEN 1
               ELSE 0
           END) TotalOrdersHighSales,
       COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID;


