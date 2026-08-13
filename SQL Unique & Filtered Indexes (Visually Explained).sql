/************ SQL Unique & Filtered Indexes (Visually Explained)  ***********/
USE SalesDB;

SELECT *
FROM Sales.Products;

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Category
ON Sales.Products (Category);

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product);

INSERT INTO Sales.Products (ProductID, Product)
VALUES (106, 'Caps');

SELECT *
FROM Sales.Customers
WHERE Country = 'USA';

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';










