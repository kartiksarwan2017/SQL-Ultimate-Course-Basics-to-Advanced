/******** SQL CTE (Common Table Expression) Visually Explained | Full Guide WITH Clause *******/

USE SalesDB;

-- Step 1: Find the total Sales Per Customer (Standalone CTE)
WITH CTE_Total_Sales AS 
(
SELECT CustomerID,
       SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
-- STEP 2: Find the last order date per customer (Standalone CTE)
, CTE_Last_Order AS (
  SELECT CustomerID,
         MAX(OrderDate) AS Last_Order
  FROM Sales.Orders
  GROUP BY CustomerID
)

-- Step 3: Rank Customers based on total sales per customer
, CTE_Customer_Rank  AS (
   SELECT CustomerID,
          TotalSales,
          RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
   FROM CTE_Total_Sales
)

-- Step 4 Segment customers based on their total sales (NESTED CTE)
, CTE_Customer_Segments AS 
(
  SELECT CustomerID,
         TotalSales,
         CASE WHEN TotalSales > 100 THEN 'High'
              WHEN TotalSales > 80 THEN 'Medium'
              ELSE 'Low'
         END AS CustomerSegments
  FROM CTE_Total_Sales
)

-- Main Query
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       cts.TotalSales,
       clo.Last_Order,
       ccr.CustomerRank
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID;

/*
SQL TASK
Generate a Sequence of Numbers from 1 to 20.
*/
WITH Series AS (
   -- Anchor Query
   SELECT 1 AS MyNumber
   UNION ALL
   -- Recursive Query
   SELECT MyNumber + 1
   FROM Series
   WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series;
-- OPTION (MAXRECURSION 10);


/*
SQL TASK
Show the employee hierarchy by displaying each employee's level with in the organisation.
*/
WITH CTE_Emp_Hierarchy AS (
    -- Anchor Query
    SELECT EmployeeID,
           FirstName,
           ManagerID,
           1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query
    SELECT e.EmployeeID,
           e.FirstName,
           e.ManagerID,
           Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
    ON e.ManagerID = ceh.EmployeeID
)

-- Main Query
SELECT *
FROM CTE_Emp_Hierarchy;










