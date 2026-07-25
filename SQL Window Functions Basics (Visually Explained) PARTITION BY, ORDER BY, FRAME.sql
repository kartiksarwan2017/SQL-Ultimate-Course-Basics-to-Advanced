/*****************  SQL Window Functions Basics (Visually Explained) | PARTITION BY, ORDER BY, FRAME **********************/
USE SalesDB;

/*
SQL TASK
Find the total sales across all orders
*/
SELECT SUM(Sales) AS TotalSales
FROM Sales.Orders;

/*
SQL TASK
Find the total Sales for each product
*/
SELECT ProductID,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY ProductID;

/*
SQL TASK
Find the total sales for each product, additionally provide details such order id, order date.
*/
SELECT OrderID,
       OrderDate,
       ProductID,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY OrderID, OrderDate, ProductID;

-- USING WINDOW FUNCTIONS
SELECT OrderID,
       OrderDate,
       ProductID,
       SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders;


/*
SQL TASK
Find the total sales across all orders additionally provide details such as order id & order date
*/
SELECT  OrderID,
        OrderDate,
        SUM(Sales) OVER() AS TotalSales
FROM Sales.Orders;

/*
SQL TASK
Find the total sales for each product, additionally provide details such order id & order date
*/
SELECT OrderID,
       OrderDate,
       ProductID,
       SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSales
FROM Sales.Orders;


/*
SQL TASK
Find the total sales across all orders
Find the total sales for each product, additionally provide details such order id & order date
*/
SELECT OrderID,
       OrderDate,
       SUM(Sales) OVER() TotalSales,
       SUM(Sales) OVER (PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders;


/*
SQL TASK
Find the total sales for each combination of product and order status
*/
SELECT ProductID,
       OrderStatus,
       SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) AS TotalSalesByProductAndSales
FROM Sales.Orders;


/*
SQL TASK
Rank each order based on their sales from highest to lowest, Additionaly provider details such as order id, order date
*/
SELECT OrderID,
       OrderDate,
       Sales,
       RANK() OVER(ORDER BY Sales DESC) AS SalesRanking
FROM Sales.Orders;


/* WINDOW FRAME */
SELECT OrderID,
       OrderDate,
       OrderStatus,
       Sales,
       SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS TotalSales
FROM Sales.Orders;


SELECT OrderID,
       OrderDate,
       OrderStatus,
       Sales,
       SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS TotalSales
FROM Sales.Orders;

SELECT OrderID,
       OrderDate,
       OrderStatus,
       Sales,
       SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS 2 PRECEDING) AS TotalSales
FROM Sales.Orders;

/* DEFAULT FRAME */
SELECT OrderID,
       OrderDate,
       OrderStatus,
       Sales,
       SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS TotalSales
FROM Sales.Orders;

SELECT OrderID,
       OrderDate,
       OrderStatus,
       Sales,
       SUM(Sales) OVER (PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
ORDER BY SUM(Sales) OVER (PARTITION BY OrderStatus) DESC;


/*
SQL TASK
Find the total sales for each order status, only for two products 101 and 102
*/
SELECT OrderID,
       OrderDate,
       OrderStatus,
       ProductID,
       Sales,
       SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102);

/*
SQL TASK
Rank customers based on their total sales
*/
SELECT CustomerID,
       SUM(Sales) AS TotalSales,
       RANK() OVER (ORDER BY SUM(Sales) DESC)
FROM Sales.Orders
GROUP BY CustomerID;







