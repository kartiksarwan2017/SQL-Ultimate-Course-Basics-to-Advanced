/************* SQL Index Maintenance | 5 Things to Do after Creating Indexes | SQL Statistics |  ************/
USE SalesDB;

-- List all indexes on a specific table
sp_helpindex 'Sales.DBCustomers';

-- Monitor Index Usage
SELECT tbl.name AS TableName,
       idx.object_id,
       idx.name AS IndexName,
       idx.type_desc AS IndexType,
       idx.is_primary_key AS IsPrimaryKey,
       idx.is_unique AS IsUnique,
       idx.is_disabled AS IsDisabled,
       s.user_seeks AS UserSeeks,
       s.user_scans AS UserScans,
       s.user_lookups AS UserLookups,
       s.user_updates AS UserUpdates,
       COALESCE(s.last_user_seek, s.last_user_scan) AS LastUpdate
FROM sys.indexes idx
INNER JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

SELECT * FROM sys.indexes;
SELECT * FROM sys.tables;


SELECT *
FROM sys.dm_db_index_usage_stats;

SELECT *
FROM Sales.Products
WHERE Product = 'Caps';


-- Monitor Missing Indexes

/*

SELECT fs.SalesOrderNumber,
       dp.EnglishProductName,
       dp.Color
FROM FactInternetSales fs
INNER JOIN DimProduct dp
ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;

*/

SELECT *
FROM sys.dm_db_missing_index_details;


-- Monitor Duplicate Indexes
SELECT tbl.name AS TableName,
       col.name AS IndexColumn,
       idx.name AS IndexName,
       COUNT(*) OVER(PARTITION BY tbl.name, col.name) AS ColumnCount
FROM sys.indexes idx
INNER JOIN sys.tables tbl 
ON idx.object_id = tbl.object_id
INNER JOIN sys.index_columns ic 
ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
INNER JOIN sys.columns col 
ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC;


-- Update Statistics
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName,
       t.name AS TableName,
       s.name AS StatisticName,
       sp.last_updated AS LastUpdate,
       DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
       sp.rows AS 'Rows',
       sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000002_14270015;

UPDATE STATISTICS Sales.DBCustomers;

EXEC sp_updatestats;


-- FRAGMENTATION METHODS
SELECT tbl.name AS TableName,
       idx.name AS IndexName,
       s.avg_fragmentation_in_percent,
       s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx
ON idx.object_id = s.object_id
AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- reorganise index
ALTER INDEX idx_Customers_Country ON Sales.Customers REORGANIZE;

ALTER INDEX idx_Customers_Country ON Sales.Customers REBUILD;

