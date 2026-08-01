/****************  SQL Subquery (Visually Explained) | Complete Guide with Correlated Subquery  ********************/
USE SalesDB;

/*
SCALAR QUERY
*/
SELECT AVG(Sales)
FROM Sales.Orders;

SELECT CustomerID
FROM Sales.Orders;

SELECT OrderID,
       OrderDate
FROM Sales.Orders;

/********* USing Subquery in FROM Clause **************/
/*
SQL TASK
Find the products that have a price higher than the average price of all products.
*/
-- Main Query
SELECT *
FROM (
    -- SubQuery
    SELECT ProductID,
           Product,
           Price,
           AVG(Price) OVER() AS AvgPrice
    FROM Sales.Products
) t
WHERE Price > AvgPrice;


/*
SQL TASK
Rank Customers based on their total amount of sales
*/
-- Main Query
SELECT CustomerID,
       TotalSales,
       RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    -- Subquery
    SELECT CustomerID,
           SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t;

/********* USing Subquery in SELECT Clause **************/
/*
SQL TASK
Show the product IDs, names, prices and total number of orders
*/
-- Main Query
SELECT ProductID,
       Product,
       Price,
       -- SUBQUERY
       (SELECT COUNT(OrderID) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;



/********* USing Subquery in JOIN Clause **************/
/*
SQL TASK
Show all customer details and find the total orders for each customer.
*/
SELECT c.*,
       o.TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT CustomerID,
           COUNT(*) AS TotalOrders
    FROM Sales.Orders
    GROUP BY CustomerID) AS o
ON c.CustomerID = o.CustomerID;



/********* USing Subquery in WHERE Clause **************/
/*
SQL TASK
Find the products that have a price higher than the average price of all products.
*/
-- Main Query
SELECT ProductID,
       Product,
       Price, 
       (SELECT AVG(Price) AS AvgPrice FROM Sales.Products) AS AvgPrice
FROM Sales.Products
WHERE Price > (
      -- Subquery
      SELECT AVG(Price) AS AvgPrice
      FROM Sales.Products
);

/*
SQL TASK
Show the details of orders made by customers in Germany
*/
-- Main Queru
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
      -- Subquery
      SELECT CustomerID
      FROM Sales.Customers
      WHERE Country = 'Germany'
);


/*
SQL TASK
Show the details of orders for customers who are not from Germany
*/
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (
      SELECT CustomerID
      FROM Sales.Customers
      WHERE Country = 'Germany'
);

/*
SQL TASK
Find female employees whose salaries are greater than the salaries of any male employees
*/
-- Main Query
SELECT EmployeeID,
       FirstName,
       LastName, 
       Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

/*
SQL TASK
Find female employees whose salaries are greater than the salaries of all male employees
*/
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


/*
SQL TASK
Show all customer details and find the total orders for each customer.
*/
-- Main Query
SELECT *,
       (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM Sales.Customers c;


/*
SQL TASK
Show the order details for customers in Germany.
*/
-- Main Query
SELECT *
FROM Sales.Orders o
WHERE EXISTS (
      SELECT 1
      FROM Sales.Customers c
      WHERE Country = 'Germany'
      AND c.CustomerID = o.CustomerID
);


/*
SQL TASK
Show the order details for customers Not in Germany
*/
SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS (
          SELECT 1
          FROM Sales.Customers c
          WHERE Country = 'Germany'
          AND c.CustomerID = o.CustomerID
);
















