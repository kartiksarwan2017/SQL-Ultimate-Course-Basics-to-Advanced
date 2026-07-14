USE SalesDB;

/* Date Calculations
   DATEADD
 */
SELECT orderid,
        orderdate,
        DATEADD(day, -10, orderdate) AS TenDaysBefore,
        DATEADD(month, 3, orderdate) AS ThreeMonthsLater,
        DATEADD(year, 2, orderdate) AS TwoYearsLater
FROM Sales.Orders;

/* SQL TASK
   Calculate the age of employees
*/
SELECT employeeid,
       birthdate,
       DATEDIFF(year, birthdate, GETDATE()) AS Age
FROM Sales.Employees;

/*
SQL TASK
Find the average shipping duration in days for each month
*/
SELECT MONTH(orderdate) AS OrderDate,
       AVG(DATEDIFF(day, orderdate, shipdate)) AS AvgShip
FROM Sales.Orders
GROUP BY MONTH(orderdate);

/*

TIME GAP ANALYSIS

SQL TASK
Find the number of days between each order and previous order.
*/
SELECT orderid,
       orderdate AS CurrentOrderDate,
       LAG(orderdate) OVER (ORDER BY orderdate) AS previousorderdate,
       DATEDIFF(day, LAG(orderdate) OVER (ORDER BY orderdate), orderdate) AS NoofDays
FROM Sales.Orders;

/* ISDATE */
SELECT ISDATE('123') AS DateCheck1,
       ISDATE('2025-08-20') AS DateCheck2,
       ISDATE('20-08-2025') AS DateCheck3,
       ISDATE(2025) AS DateCheck4,
       ISDATE('08') AS DateCheck4;

SELECT 
-- CAST(orderdate AS DATE) AS orderdate,
orderdate,
ISDATE(orderdate),
CASE WHEN ISDATE(orderdate) = 1 THEN CAST(orderdate AS DATE) 
     ELSE '9999-01-01'
END NewOrderDate
FROM 
(
  SELECT '2025-08-20' AS OrderDate UNION
  SELECT '2025-08-21' UNION
  SELECT '2025-08-23' UNION
  SELECT '2025-08'
) t
 -- WHERE ISDATE(orderdate) = 0;



