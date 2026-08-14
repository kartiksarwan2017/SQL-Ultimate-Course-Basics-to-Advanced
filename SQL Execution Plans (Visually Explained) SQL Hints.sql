/******************** SQL Execution Plans (Visually Explained) | SQL Hints |  ****************/
USE SalesDB;

-- EXECUTION PLAN BASICS 
SELECT *
INTO Sales.Orders_HP
FROM Sales.Orders;

SELECT *
FROM Sales.Orders
ORDER BY OrderID;

SELECT *
FROM Sales.Orders_HP
ORDER BY OrderID;

-- EXECUTION PLAN NONCLUSTERED INDEX
SELECT *
FROM Sales.Orders
WHERE OrderStatus = 'Delivered';

SELECT *
FROM Sales.Orders_HP
WHERE OrderStatus = 'Delivered';

CREATE NONCLUSTERED INDEX idx_OrderStatus_Delivered
ON Sales.Orders_HP (OrderStatus);

/*
Execution Plan
Rowstore vs Columnstore
*/
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;


SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.Sales) AS TotalSales
FROM Sales.Orders_HP AS o
INNER JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

CREATE CLUSTERED COLUMNSTORE INDEX idx_Orders_HP
ON Sales.Orders_HP;


-- SQL HINTS
SELECT o.Sales,
       c.Country
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN);


-- Using INDEX SEEK SCAN
SELECT o.Sales,
       c.Country
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c WITH (FORCESEEK)
ON c.CustomerID = o.CustomerID;

-- USING SPECIFIC INDEX
SELECT o.Sales,
       c.Country
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders_HP AS o WITH (INDEX([idx_Orders_HP]))
ON c.CustomerID = o.CustomerID;

