/****** SQL NULL vs Empty String vs Blank Space (Visually Explained) *******/

USE SalesDB;

WITH Products AS (
   SELECT 1 Id, 'A' Category UNION
   SELECT 2, NULL UNION
   SELECT 3, '' UNION
   SELECT 4, '  '
)
SELECT *, 
       DATALENGTH(Category) AS CategoryLen,
       DATALENGTH(TRIM(Category)) AS Policy1,
       NULLIF(TRIM(Category), '') AS Policy2,
       COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Sales.Products;




