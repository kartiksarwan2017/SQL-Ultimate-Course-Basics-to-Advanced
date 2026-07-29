/***************** SQL Ranking Window Functions | ROW_NUMBER, RANK, DENSE_RANK, NTILE  *****************/

USE SalesDB;

/*
SQL TASK
Rank the orders based on their sales from highest to lowest
*/
SELECT OrderID,
       ProductID,
       Sales,
       ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRank_Row,
       RANK() OVER(ORDER BY Sales DESC) AS SalesRank_Rank,
       DENSE_RANK() OVER(ORDER BY Sales DESC) AS SalesRank_Dense
FROM Sales.Orders;

/*
SQL TASK
Find the top highest sales for each product
*/
SELECT *
FROM (
    SELECT OrderID,
           ProductID,
           Sales,
           ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
    FROM Sales.Orders
) t
WHERE RankByProduct = 1;
     
/*
SQL TASK
Find the lowest 2 customers based on their total sales
*/
SELECT *
FROM (
    SELECT CustomerID,
            SUM(Sales) AS TotalSales,
            ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS RankCustomers
    FROM Sales.Orders
    GROUP BY CustomerID
) t 
WHERE RankCustomers <= 2;


/*
SQL TASK
Assign unique IDs to the rows of the 'Orders Archive' table
*/
SELECT ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) AS UniqueID,
       *
FROM Sales.OrdersArchive;

/*
SQL TASK
Identify dupicate rows in the table 'Orders Archive' and return a clean result without 
any duplicates
*/
SELECT * FROM (
    SELECT ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
           *
    FROM Sales.OrdersArchive
) t 
WHERE rn = 1; 


SELECT OrderID,
       Sales,
       NTILE(4) OVER (ORDER BY Sales DESC) AS FourBucket,
       NTILE(3) OVER (ORDER BY Sales DESC) AS ThreeBucket,
       NTILE(2) OVER (ORDER BY Sales DESC) AS TwoBucket,
       NTILE(1) OVER (ORDER BY Sales DESC) AS OneBucket
FROM Sales.Orders;



/*
SQL TASK
Segment all orders into 3 categories:
high, medium and low sales
*/
SELECT *,
       CASE WHEN Buckets = 1 THEN 'High'
            WHEN Buckets = 2 THEN 'Medium'
            WHEN Buckets = 3 THEN 'Low'
       END AS SalesSegmentations
FROM (
        SELECT OrderID,
               Sales,
               NTILE(3) OVER (ORDER BY Sales DESC) AS Buckets
        FROM Sales.Orders
) t;

/*
SQL TASK
In order to export the data, divide the orders into 2 groups.
*/
SELECT NTILE(2) OVER (ORDER BY OrderID) AS Buckets,
       *
FROM Sales.Orders;

/*
SQL TASK
Find the products that fall within the highest 40% of the prices
*/
SELECT *,
       CONCAT(DistRank * 100, '%') AS DistRankPercent
FROM (
    SELECT Product,
           Price,
           CUME_DIST() OVER (ORDER BY Price DESC) AS DistRank
    FROM Sales.Products
) t
WHERE DistRank <= 0.4;


SELECT *,
       CONCAT(DistRank * 100, '%') AS DistRankPercent
FROM (
    SELECT Product,
           Price,
           PERCENT_RANK() OVER (ORDER BY Price DESC) AS DistRank
    FROM Sales.Products
) t
WHERE DistRank <= 0.4;