/**************** SQL Aggregate Window Functions | COUNT, AVG, SUM, MAX, MIN **************/
USE SalesDB;


/************* COUNT Window Function **************/
/*
SQL TASK
Find the total number of Orders
*/
SELECT COUNT(*) AS TotalOrders
FROM Sales.Orders;

/*
SQL TASK
Find the total number of orders additionally provide details such order id & order date
*/
SELECT OrderID,
       OrderDate,
       COUNT(*) OVER() AS TotalOrders
FROM Sales.Orders;


/*
SQL TASK
Find the total number of orders. Find the total number of orders for each customers.
Additionally provide details such order Id, order date
*/
SELECT OrderID,
       OrderDate,
       CustomerID,
       COUNT(*) OVER() AS TotalOrders,
       COUNT(*) OVER(PARTITION BY CustomerID) AS OrdersByCustomers
FROM Sales.Orders;

/*
SQL TASK
Find the total number of Customers
Additionally provide All customers details
*/
SELECT *,
       COUNT(*) OVER() AS TotalCustomers
FROM Sales.Customers;


/*
SQL TASK
Find the total number of scores for the customers
*/
SELECT *,
       COUNT(Score) OVER() AS TotalScores
FROM Sales.Customers;


-- SUMMARY QUERY
SELECT *,
       COUNT(*) OVER() AS TotalCustomersStar,
       COUNT(1) OVER() AS TotalCustomersOne,
       COUNT(Score) OVER() AS TotalScores,
       COUNT(Country) OVER() AS TotalCountries
FROM Sales.Customers;


/*
SQL TASK
Check whether the table 'Orders' contains any duplicate rows
*/
SELECT *
FROM (
    SELECT OrderID,
        COUNT(*) OVER (PARTITION BY OrderID) AS CheckPK
    FROM Sales.Orders
) t 
WHERE CheckPK > 1;


SELECT *
FROM (
    SELECT OrderID,
            COUNT(*) OVER (PARTITION BY OrderID) AS CheckPK
    FROM Sales.OrdersArchive
) t 
WHERE CheckPK > 1;


/************* SUM Window Function **************/
/*
Find the total sales across all orders and the total sales for each product
Additionally, provide details such as orderId and order date
*/
SELECT OrderID,
       OrderDate,
       Sales,
       SUM(Sales) OVER() AS TotalSales,
       ProductID,
       SUM(Sales) OVER(PARTITION BY ProductID) AS SalesByProducts
FROM Sales.Orders;

/*
SQL TASK
Find the percentage contribution of each product's sales to the total sales.
*/
SELECT OrderID,
       ProductID,
       Sales,
       SUM(Sales) OVER() AS TotalSales,
       ROUND(CAST(Sales AS Float) / SUM(Sales) OVER() * 100, 2) AS PercentageTotal
FROM Sales.Orders;


/*
SQL TASK
Find the average sales across all orders and the average sales for each product.
Additionally, provide details such as Order ID and Order Date.
*/
SELECT OrderID,
       OrderDate,
       Sales,
       AVG(Sales) OVER() AS AverageSales,
       ProductID,
       AVG(Sales) OVER(PARTITION BY ProductID) AS AverageSalesByProduct
FROM Sales.Orders;

/*
SQL TASK
Find the average scores of customers. Additionally provide details such as Customer ID and Last Name
*/
SELECT CustomerID,
       LastName,
       Score,
       COALESCE(Score, 0) AS CustomerScore,
       AVG(Score) OVER() AS AverageScore,
       AVG(COALESCE(Score, 0)) OVER() AS AverageScoreWithoutNull
FROM Sales.Customers;


/*
SQL TASK
Find all orders where sales are higher than the average sales across all orders.
*/
SELECT *
FROM (
    SELECT OrderID,
           ProductID,
           Sales, 
           AVG(Sales) OVER() AS AverageSales
    FROM Sales.Orders
) t 
WHERE Sales > AverageSales;


/***************** MAX MIN WINDOW FUNCTIONS *****************/
/*

SQL TASK
Find the highest & lowest sales across all orders and the highest
& lowest sales for each product.
Additionally, provide details such as order ID and order date.

*/
SELECT OrderID,
       OrderDate,
       ProductID,
       Sales,
       MAX(Sales) OVER() AS HighestSales,
       MIN(Sales) OVER() AS LowestSales,
       MAX(Sales) OVER(PARTITION BY ProductID) AS HighestSalesByProduct,
       MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders;


/*
SQL TASK
Show the employees with the highest salaries.
*/
SELECT *
FROM (
    SELECT *,
           MAX(Salary) OVER() AS HighestSalary
    FROM Sales.Employees
) t
WHERE salary = HighestSalary;

/*
SQL TASK
Find the deviation of each sales from the minimum and maximum sales amount.
*/
SELECT OrderID,
       OrderDate,
       ProductID,
       Sales,
       MAX(Sales) OVER() AS HighestSales,
       MIN(Sales) OVER() AS LowestSales,
       Sales - MIN(Sales) OVER() AS DeviationFromMIN,
       MAX(Sales) OVER() - Sales  AS DeviationFromMAX
FROM Sales.Orders;


/*
SQL TASK
Calculate moving average of sales for each product over time.
*/
SELECT OrderID,
       ProductID,
       OrderDate,
       Sales,
       AVG(Sales) OVER(PARTITION BY ProductID) AS AvgByProduct,
       AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ASC) AS MovingAverage
FROM Sales.Orders;


/*
SQL TASK
Calculate the moving average of sales for each product over time, including only the next order.
*/
SELECT OrderID,
       ProductID,
       OrderDate,
       Sales,
       AVG(Sales) OVER(PARTITION BY ProductID) AS AvgSales,
       AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAverage
FROM Sales.Orders;















