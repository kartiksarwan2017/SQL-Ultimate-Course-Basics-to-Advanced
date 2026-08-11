/************* SQL CTAS How to Create SQL Tables From a Query **************/

USE SalesDB;

/*
SQL TASK
The total number of orders in each month
*/
SELECT DATENAME(month, OrderDate) AS OrderMonth,
       COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

SELECT * 
FROM Sales.MonthlyOrders;

DROP TABLE Sales.MonthlyOrders;


/******** How to Refresh CTAS *********/
-- U stands for User Defined Tables
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
   DROP TABLE Sales.MonthlyOrders
GO
SELECT DATENAME(month, OrderDate) AS OrderMonth,
       COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);
