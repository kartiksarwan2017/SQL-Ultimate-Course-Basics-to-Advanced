/************* SQL Stored Procedure (Visually Explained) *****************/

USE SalesDB;

-- Step 1: Write a Query
-- For US Customers Find the Total Number of Customers and the Average Score

SELECT COUNT(*) TotalCustomers,
        AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

-- Step 2: Turning the Query Into a Stored Procedure
CREATE PROCEDURE GetCustomerSummary AS 
BEGIN 
SELECT COUNT(*) AS TotalCustomers,
       AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END 


-- Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary;


-- For German Customers Find the Total Number of Customers and the Average Score
CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN
SELECT COUNT(*) AS TotalCustomers,
       AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'Germany'
END 

EXEC GetCustomerSummaryGermany;

-- Step 1: Define a Parameter
ALTER PROCEDURE GetCustomerSummaryGermany @Country NVARCHAR(50) = 'USA' AS
BEGIN
SELECT COUNT(*) AS TotalCustomers,
       AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = @Country;

-- Find the total Number of Orders and Total Sales
SELECT COUNT(OrderID) TotalOrders,
       SUM(Sales) AS TotalSales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;
END 

-- Pass the Parameter's Value at Execution
-- EXEC GetCustomerSummaryGermany @Country = 'Germany';
-- EXEC GetCustomerSummaryGermany @Country = 'USA';
-- DROP GetCustomerSummaryGermany @Country = 'USA';

-- Execute the Stored Procedure
EXEC GetCustomerSummaryGermany;
EXEC GetCustomerSummaryGermany @Country = 'Germany';



-- Total Customers from Germany: 2
-- Average Score from Germany: 425
ALTER PROCEDURE GetCustomerSummaryGermany @Country NVARCHAR(50) = 'USA' AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;

SELECT @TotalCustomers = COUNT(*),
       @AvgScore = AVG(Score)
FROM Sales.Customers
WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

-- Find the total Number of Orders and Total Sales
SELECT COUNT(OrderID) TotalOrders,
       SUM(Sales) AS TotalSales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;
END 

GO

EXEC GetCustomerSummaryGermany;
EXEC GetCustomerSummaryGermany @Country = 'Germany';

GO

-- Stored Procedure Control Flow
ALTER PROCEDURE GetCustomerSummaryGermany @Country NVARCHAR(50) = 'USA' 
AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;

-- Prepare & Clean Up Data
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN 
     PRINT('Updating NULL Scores to 0');
     UPDATE Sales.Customers
     SET Score = 0
     WHERE Score IS NULL AND Country = @Country;
END

ELSE 
BEGIN PRINT('No NULL Scores Found')
END;

-- Generating Reports
SELECT @TotalCustomers = COUNT(*),
       @AvgScore = AVG(Score)
FROM Sales.Customers
WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

-- Find the total Number of Orders and Total Sales
SELECT COUNT(OrderID) TotalOrders,
       SUM(Sales) AS TotalSales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;
END 

GO

EXEC GetCustomerSummaryGermany;
EXEC GetCustomerSummaryGermany @Country = 'Germany';

GO

-- Error Handling TRY CATCH
ALTER PROCEDURE GetCustomerSummaryGermany @Country NVARCHAR(50) = 'USA' 
AS
BEGIN
    BEGIN TRY
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;

        -- ===============================
        -- Step 1: Prepare & Clean Up Data
        -- ===============================
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN 
             PRINT('Updating NULL Scores to 0');
             UPDATE Sales.Customers
             SET Score = 0
             WHERE Score IS NULL AND Country = @Country;
        END

        ELSE 
        BEGIN 
             PRINT('No NULL Scores Found')
        END;

        -- ===================================
        -- Step 2: Generating Summary Reports
        -- ===================================
        -- Calculate Total Customers and Average Score for Specific Countryu
        SELECT @TotalCustomers = COUNT(*),
               @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
        PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

        -- Calculate Total Number of Orders abd Total Sales for specific Country.
        SELECT COUNT(OrderID) TotalOrders,
               SUM(Sales) AS TotalSales
        FROM Sales.Orders o
        INNER JOIN Sales.Customers c
        ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;

    END TRY
    BEGIN CATCH
            -- ===============================
            -- Error Handling
            -- ===============================
            PRINT('An error occured.');
            PRINT('Error Message: ' + ERROR_MESSAGE());
            PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
            PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
            PRINT('Error Procedure: ' + ERROR_PROCEDURE());
    END CATCH
END 
GO

EXEC GetCustomerSummaryGermany;
EXEC GetCustomerSummaryGermany @Country = 'Germany';


