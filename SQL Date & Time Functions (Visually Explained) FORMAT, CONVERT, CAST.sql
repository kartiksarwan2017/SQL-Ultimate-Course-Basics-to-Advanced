USE SalesDB;

/* FORMAT() */

SELECT orderid,
       creationtime,
       FORMAT(creationtime, 'MM-dd-yyyy') AS USA_Format,
       FORMAT(creationtime, 'dd-MM-yyyy') AS EU_Format,
       FORMAT(creationtime, 'dd') AS dd,
       FORMAT(creationtime, 'ddd') AS ddd,
       FORMAT(creationtime, 'dddd') AS dddd,
       FORMAT(creationtime, 'MM') AS MM,
       FORMAT(creationtime, 'MMM') AS MMM,
       FORMAT(creationtime, 'MMMM') AS MMMM
FROM Sales.Orders;


/*
SQL TASK
Show CreationTime usign the following format:
Day Wed Jan Q1 2025 12:34:56 PM
*/
SELECT orderid,
       creationtime,
       'Day ' + FORMAT(creationtime, 'ddd MMM') + ' Q' + DATENAME(quarter, creationtime) + ' ' + FORMAT(creationtime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;


/* SQL TASK
   Show CreationTime using the following format: 
   MMM yy
*/
SELECT FORMAT(orderdate, 'MMM yy') AS orderdate,
       COUNT(*) AS numoforders
FROM Sales.Orders
GROUP BY FORMAT(orderdate, 'MMM yy');

SELECT CONVERT(INT, '123') AS [String to Int CONVERT],
       CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
       creationtime,
       CONVERT(DATE, creationtime) AS [Datetime to Date Convert]
FROM Sales.Orders;

SELECT creationtime,
       CONVERT(DATE, creationtime) AS [Datetime to Date Convert],
       CONVERT(VARCHAR, creationtime, 32) AS [USA Std. Style:32],
       CONVERT(VARCHAR, creationtime, 34) AS [EURO Std. Style:32]
FROM Sales.Orders;

SELECT CAST('123' AS INT) AS [String to Int],
       CAST(123 AS VARCHAR) AS [Int to String],
       CAST('2025-08-20' AS DATE) AS [String to Date],
       CAST('2025-08-20' AS DATETIME2) AS [String to DateTime],
       creationtime,
       CAST(creationtime AS DATE) AS [Datetime to Date]
FROM Sales.Orders;





