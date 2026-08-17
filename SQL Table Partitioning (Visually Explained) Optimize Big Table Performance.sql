/************ SQL Table Partitioning (Visually Explained) | Optimize Big Table Performance |  *************/
USE SalesDB;

-- STEP 1: Create a Partition Function
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31');

-- Query lists all existing Partition Function
SELECT name,
       function_id,
       type,
       type_desc,
       boundary_value_on_right
FROM sys.partition_functions;


-- Step 2: Create Filegroups
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

-- Query lists all existing Filegroups
SELECT *
FROM sys.filegroups
WHERE type = 'FG';

-- Step 3: Add .ndf Files to Eahch Filegroup
ALTER DATABASE SalesDB ADD FILE 
(
   NAME = P_2023, -- Logical Name
   FILENAME = 'D:\Code with Barra\SQL ULTIMATE COURSE BASICS TO ADVANCED\SQL Table Partitioning Optimize Big Table Performance\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE 
(
   NAME = P_2024, -- Logical Name
   FILENAME = 'D:\Code with Barra\SQL ULTIMATE COURSE BASICS TO ADVANCED\SQL Table Partitioning Optimize Big Table Performance\P_2024.ndf'
) TO FILEGROUP FG_2024;


ALTER DATABASE SalesDB ADD FILE 
(
   NAME = P_2025, -- Logical Name
   FILENAME = 'D:\Code with Barra\SQL ULTIMATE COURSE BASICS TO ADVANCED\SQL Table Partitioning Optimize Big Table Performance\P_2025.ndf'
) TO FILEGROUP FG_2025;

SELECT fg.name AS FilegroupName,
       mf.name AS LogicalFileName,
       mf.physical_name AS PhysicalFilePath,
       mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf 
ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('Sales_DB');



