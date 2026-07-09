/*
1. Display employees earning more than 70,000.
*/
SELECT *
FROM employees
WHERE salary > 70000;

/*
2. Find customers from Germany.
*/
SELECT *
FROM customers
WHERE country = 'Germany';

/*
3. Display products costing between 20 and 50.
*/
SELECT *
FROM products
WHERE price >= 20 AND price <= 50;

SELECT * 
FROM products
WHERE price BETWEEN 20 AND 50;

/*
4. Show orders placed after '2025-01-15'.
*/
SELECT *
FROM orders
WHERE orderdate > '2025-01-15';

/*
5. Find employees whose first name starts with 'M'.
*/
SELECT *
FROM employees
WHERE firstname LIKE 'M%';

/*
6.  Display customers whose last name ends with 'son'.
*/
SELECT *
FROM customers
WHERE lastname LIKE '%son';


/*
7. Find orders with quantity equal to 0.
*/
SELECT *
FROM orders
WHERE quantity = 0;


/*
8. Show products whose category is Clothing.
*/
SELECT *
FROM products
WHERE category = 'Clothing';

/*
9.  Display employees born before 1990.
*/


/*
10. Find customers with score greater than 700.
*/
SELECT *
FROM customers 
WHERE score > 700;









