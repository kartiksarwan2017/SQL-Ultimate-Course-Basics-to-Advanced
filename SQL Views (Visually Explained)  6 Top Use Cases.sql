/************** SQL Views (Visually Explained) | 6 Top Use Cases | ******************/
USE SalesDB;

/*
SQL TASK
Find the running total of sales for each month
*/
-- APPROACH 1
WITH CTE_Monthly_Summary AS (
    SELECT DATETRUNC(month, OrderDate) AS OrderMonth,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS TotalOrders,
           SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)
SELECT OrderMonth,
       TotalSales,
       SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary;

/*
GO tells tools like SSMS/Azure Data Studio:
"End this batch here and start a new one."
*/
GO


-- APPROACH 2
/* If a Table or View is created without specifying a schema, it defaults to the DBO */
CREATE VIEW V_Monthly_Summary AS (
    SELECT DATETRUNC(month, OrderDate) AS OrderMonth,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS TotalOrders,
           SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

GO

CREATE VIEW Sales.V_Monthly_Summary AS (
    SELECT DATETRUNC(month, OrderDate) AS OrderMonth,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS TotalOrders,
           SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

GO

SELECT *
FROM Sales.V_Monthly_Summary;

SELECT OrderMonth,
       TotalSales,
       SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM Sales.V_Monthly_Summary;


/* Deleting the existing View */
DROP VIEW V_Monthly_Summary;

/* In order to alter the view firstly we drop the view and recreate it */
-- APPROACH 1
DROP VIEW Sales.V_Monthly_Summary;

GO

CREATE VIEW Sales.V_Monthly_Summary AS (
    SELECT DATETRUNC(month, OrderDate) AS OrderMonth,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS TotalOrders
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

GO 

-- APPROACH 2 T-SQL
IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
   DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS (
    SELECT DATETRUNC(month, OrderDate) AS OrderMonth,
           SUM(Sales) AS TotalSales,
           COUNT(OrderID) AS TotalOrders
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

GO

/*
SQL TASK
Provide a view that combines details from orders, products, customers and employees.
*/
CREATE VIEW Sales.V_Order_Details AS (
    SELECT o.OrderID,
           o.OrderDate,
           p.Product,
           p.Category,
           COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
           c.Country AS CustomerCountry,
           COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
           e.Department,
           o.Sales,
           o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p
    ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c
    ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e
    ON e.EmployeeID = o.SalesPersonID
);

GO

SELECT *
FROM Sales.V_Order_Details;

GO

/*
SQL TASK
Provide a view for the EU Sales Team that combines details from all tables and excludes data
related to the USA.
*/
CREATE VIEW Sales.V_Order_Details_EU AS (
    SELECT o.OrderID,
           o.OrderDate,
           p.Product,
           p.Category,
           COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
           c.Country AS CustomerCountry,
           COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
           e.Department,
           o.Sales,
           o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p
    ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c
    ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e
    ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA'
);

SELECT *
FROM Sales.V_Order_Details_EU;

















