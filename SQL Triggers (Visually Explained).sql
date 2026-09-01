/**************** SQL TRIGGERS (VISUALLY EXPLAINED) ***********************/

USE SalesDB;

-- STEP 1 Create Log TABLE
CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1, 1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATE
);

GO

-- STEP 2 Create Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS 
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT EmployeeID,
           'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
           GETDATE()
    FROM INSERTED
END

-- STEP 3 Insert New Data Into Employees
SELECT *
FROM Sales.EmployeeLogs;


INSERT INTO Sales.Employees
VALUES
(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);


