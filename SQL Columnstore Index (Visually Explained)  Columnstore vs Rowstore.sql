/*********** SQL Columnstore Index (Visually Explained) Columnstore vs Rowstore ***********/
USE SalesDB;

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;

DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers;

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers;


