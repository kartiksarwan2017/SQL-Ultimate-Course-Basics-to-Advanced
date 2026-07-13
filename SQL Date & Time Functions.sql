/*******************  SQL Date & Time Functions *******************/
USE SalesDB;

SELECT orderid,
       orderdate,
       shipdate,
       creationtime
FROM Sales.Orders;


/* Hardcoded date string */
SELECT orderid,
       creationtime,
       '2026-10-27' AS Hardcoded
FROM Sales.Orders;

/* GETDATE() Function */
SELECT GETDATE() AS today;


/* PART EXTRACTION
   DAY | MONTH | YEAR
*/
SELECT orderid,
       creationtime,
       YEAR(creationtime) AS Year,
       MONTH(creationtime) AS Month,
       DAY(creationtime) AS Day
FROM Sales.Orders;


/*
PART EXTRACTION
DATEPART() 
*/
SELECT orderid,
       creationtime,
       DATEPART(year, creationtime) AS Year_dp,
       DATEPART(month, creationtime) AS Month_dp,
       DATEPART(day, creationtime) AS Day_dp,
       DATEPART(hour, creationtime) AS Hour_dp,
       DATEPART(quarter, creationtime) AS Quarter_dp,
       DATEPART(week, creationtime) AS Week_dp
FROM Sales.Orders;


/* DATENAME() */
SELECT orderid,
       creationtime,
       DATENAME(month, creationtime) AS Month_dn,
       DATENAME(weekday, creationtime) AS weekday_dn,
       DATENAME(day, creationtime) AS day_dn,
       DATENAME(year, creationtime) AS year_dn
FROM Sales.Orders;



/* DATETRUNC() */
SELECT orderid,
       creationtime,
       DATETRUNC(year, creationtime) AS year_dt,
       DATETRUNC(day, creationtime) AS day_dt,
       DATETRUNC(minute, creationtime) AS minute_dt
FROM Sales.Orders;


SELECT DATETRUNC(month, creationtime) AS Creation,
       COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month, creationtime);


SELECT DATETRUNC(year, creationtime) AS Creation,
       COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year, creationtime);


/* Part Extraction - EOMONTH() */
SELECT orderid,
       creationtime,
       EOMONTH(creationtime) AS EndOfMonth
FROM Sales.Orders;
       

/* Getting the the day of month as 1 */
SELECT orderid,
       creationtime,
       CAST(DATETRUNC(month, creationtime) AS DATE) AS StartOfMonth,
       EOMONTH(creationtime) AS EndOfMonth
FROM Sales.Orders;

/*
SQL TASK
How many orders were placed each year ?
*/
SELECT YEAR(orderdate) AS Year,
       COUNT(*) AS NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(orderdate);


/*
SQL TASK
How many orders were placed each month ?
*/
SELECT MONTH(orderdate) AS Month,
       COUNT(*) AS NrOfOrders
FROM Sales.Orders
GROUP BY MONTH(orderdate);


SELECT DATENAME(month, orderdate) AS Month,
       COUNT(*) AS NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month, orderdate);


/*
SQL TASK
Show all orders that were placed during the month of february
*/
SELECT *
FROM Sales.Orders
WHERE MONTH(orderdate) = 2;



