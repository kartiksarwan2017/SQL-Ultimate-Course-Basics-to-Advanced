/************** SQL Indexes (Visually Explained Clustered vs Nonclustered ***********/
USE SalesDB;

SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;


SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1;

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;


/********* Non Clustered Index *******/
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

SELECT *
FROM Sales.DBCustomers
WHERE FirstName = 'Anna';

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

/******** COMPOSITE INDEX ***********/
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500;

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA';





