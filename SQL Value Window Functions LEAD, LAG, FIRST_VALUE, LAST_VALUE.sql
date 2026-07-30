/****************** SQL Value Window Functions LEAD, LAG, FIRST_VALUE, LAST_VALUE ****************/

USE SalesDB;

/*
SQL TASK
Analyze the month over month (MoM) performance by finding the percentage change in sales between the current and previous month
*/
SELECT *,
       CurrentMonthSales - PreviousMonthSales AS MoM_Change,
       ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT) / PreviousMonthSales * 100, 1) AS MoM_Percentage
FROM 
(
SELECT MONTH(OrderDate) AS OrderMonth,
       SUM(Sales) AS CurrentMonthSales,
       LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
) t;

/*
SQL TASK
Analyze customer loyalty by ranking customers based on the average number of days between orders.
*/
SELECT CustomerID,
       AVG(DaysUntilNextOrder) AS AvgDays,
       RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAverage
FROM (
SELECT OrderID,
       CustomerID,
       OrderDate AS CurrentOrder,
       LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
       DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS DaysUntilNextOrder
FROM Sales.Orders
) t
GROUP BY CustomerID;


/*
SQL TASK
Find the lowest and highest sales for each product
*/
SELECT OrderID,
       ProductID,
       Sales,
       FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
       LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
       FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
       MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSales2,
       MAX(Sales) OVER(PARTITION BY ProductID) AS HighestSales3
FROM Sales.Orders;


/*
SQL TASK
Find the lowest and highest sales for each product
Find the difference in sales between the current and the lowest sales
*/
SELECT OrderID,
       ProductID,
       Sales,
       FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
       LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
       Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders;
