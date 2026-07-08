/**************** Joining Multiple Tables in SQL (Visually Explained) | 3+ Table Joins  *******************/

USE salesdb;

/*
SQL TASK
Using SalesDB, Retrieve a list of all orders, along with the related customer, product, and employee details.
For each order, display:
Order ID
Customer's Name
Product name
Sales amount
Product price
Salesperson's name
*/

/* Main Table - ORDERS  */
SELECT o.orderid,
       o.sales,
       c.firstname AS customer_firstname,  
       c.lastname AS customer_lastname,
       p.product AS product_name,
       p.price,
       e.firstname AS salesperson_firstname, 
       e.lastname AS salesperson_lastname
FROM orders AS o 
LEFT JOIN customers AS c
ON o.customerid = c.customerid
LEFT JOIN products AS p 
ON o.productid = p.productid   
LEFT JOIN employees e 
ON o.salespersonid = e.employeeid;


    
    












