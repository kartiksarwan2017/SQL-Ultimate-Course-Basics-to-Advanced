/********* SQL Temp Tables (Visually Explained) ************/

USE SalesDB;

SELECT *
INTO #Orders
FROM Sales.Orders;

SELECT *
FROM #Orders;

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';

/* If we require the intermediate result from the TEMP table to be stored permanently  */
SELECT *
INTO Sales.OrdersTest
FROM #Orders;

SELECT *
FROM Sales.OrdersTest;