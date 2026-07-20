/* SQL Aggregate Functions */
USE SalesDB;

/*
SQL TASK
Find the total number of customers
*/
SELECT COUNT(*) AS TotalCustomers
FROM Sales.Customers;

/*
SQL TASK
Find the total number of orders
*/
SELECT COUNT(*) AS TotalNumOfOrders
FROM Sales.Orders;


/*
SQL TASK
Find the total sales of all orders
*/
SELECT SUM(Sales) AS TotalSales
FROM Sales.Orders;


/*
SQL TASK
Find the average sales of all orders.
*/
SELECT AVG(Sales) AS AverageSales
FROM Sales.Orders;


/*
SQL TASK
Find the highest sales of all orders
*/
SELECT MAX(Sales) AS HighestSales
FROM Sales.Orders;


/*
SQL TASK
Find the Lowest Sales of all Orders
*/
SELECT MIN(Sales) AS LowestSales
FROM Sales.Orders;


-- Using GROUP BY With Aggregation
SELECT CustomerID,
       COUNT(*) AS total_orders,
       SUM(Sales) AS TotalSales,
       AVG(Sales) AS AvgSales,
       MAX(Sales) AS HighestSales,
       MIN(Sales) AS LowestSales
FROM Sales.Orders
GROUP BY CustomerID;


/*  
SQL TASK
Analyze the scores in customers table
*/
SELECT SUM(Score) AS TotalScore,
       AVG(Score) AS AvgScore,
       MAX(Score) AS HighestScore,
       MIN(Score) AS LowestScore
FROM Sales.Customers;