/****************** Pattern 1 — UNION *****************

Clue Words
combine
merge
list all
together
from both tables
customers and employees

Use: UNION (removes duplicates)
*/
USE SalesDB;

/*
Q1

Display all first names from customers and employees.

Output
FirstName

*/
SELECT firstname
FROM Sales.Customers
UNION 
SELECT firstname
FROM Sales.Employees;


/* 
Q2
Display all countries and departments in one list.

Output

Location

(Remove duplicates.)
*/
SELECT country AS Location
FROM Sales.Customers
UNION
SELECT department AS Location
FROM Sales.Employees;


/*
Q3

Display all product categories and employee departments.

Output

Category_Department
*/
SELECT category AS Category_Department
FROM Sales.Products
UNION
SELECT department 
FROM Sales.Employees;


/*
Q4

Display all customer IDs and salesperson IDs.

Output

PersonID

(Remove duplicates.)
*/
SELECT customerid AS PersonID
FROM Sales.Customers 
UNION 
SELECT salespersonid
FROM Sales.Orders;




/*
Q5

Display all billing addresses and shipping addresses.

Output

Address

(Remove duplicates.)

*/
SELECT billaddress
FROM Sales.Orders
UNION
SELECT shipaddress
FROM Sales.Orders;


/*
Q6

Display all order dates from orders and orders_archive.

(Remove duplicates.)
*/
SELECT orderdate
FROM Sales.Orders
UNION 
SELECT orderdate
FROM Sales.OrdersArchive;


/*

Q7
Display every unique order status from current and archive orders.
*/
SELECT orderstatus
FROM Sales.Orders
UNION
SELECT orderstatus
FROM Sales.OrdersArchive;



/*
Q8

Display all product names and customer first names in one column.

Output
Name
*/
SELECT product AS Name
FROM Sales.Products
UNION 
SELECT firstname
FROM Sales.Customers;


/*
Q9
Display all countries from customers and all ship addresses.
*/
SELECT country
FROM Sales.Customers
UNION 
SELECT shipaddress
FROM Sales.Orders;


/*
Q10
Display all creation timestamps from current and archived orders.
*/
SELECT creationtime
FROM Sales.Orders
UNION 
SELECT creationtime
FROM Sales.OrdersArchive;


/******************************* Pattern 2 — UNION ALL ***************************

Clue Words
include duplicates
every record
complete history
append
stack

Think

UNION ALL
*/

/*
Q1

Display all orders from

orders

and

orders_archive

including duplicates.
*/
SELECT 
      OrderID,
      ProductID,
      CustomerID,
      SalesPersonID,
      OrderDate,
      ShipDate,
      OrderStatus,
      ShipAddress,
      BillAddress,
      Quantity,
      Sales,
      CreationTime
FROM Sales.Orders
UNION ALL
SELECT
      OrderID,
      ProductID,
      CustomerID,
      SalesPersonID,
      OrderDate,
      ShipDate,
      OrderStatus,
      ShipAddress,
      BillAddress,
      Quantity,
      Sales,
      CreationTime
FROM Sales.OrdersArchive;



/* 
Q2

Display all customer IDs from

Customers

and

Orders

including duplicates.

*/
SELECT customerid
FROM Sales.Customers
UNION ALL
SELECT customerid
FROM Sales.Orders;


/* 
Q3

Display all salesperson IDs from

Employees

and

Orders.
*/
SELECT employeeid
FROM Sales.Employees
UNION ALL
SELECT salespersonid
FROM Sales.Orders;


/* 
Q4

Display every order status from current and archive orders.

Include duplicates.
*/
SELECT orderstatus
FROM Sales.Orders
UNION ALL
SELECT orderstatus
FROM Sales.OrdersArchive;


/* 
Q5

Display every product ID from

Products

and

Orders.
*/
SELECT productid 
FROM Sales.Products
UNION ALL
SELECT productid
FROM Sales.Orders;



/* 
Q6

Display every order date from current and archived orders.
*/
SELECT orderdate
FROM Sales.Orders
UNION ALL
SELECT orderdate
FROM Sales.OrdersArchive;


/* 
Q7

Display every quantity from both order tables.
*/
SELECT quantity
FROM Sales.Orders
UNION ALL
SELECT quantity
FROM Sales.OrdersArchive;



/* 
Q8

Display every sales amount from both order tables.
*/
SELECT sales
FROM Sales.Orders
UNION ALL 
SELECT sales
FROM Sales.OrdersArchive;



/* 
Q9

Display every ship address from both order tables.
*/
SELECT shipaddress
FROM Sales.Orders
UNION ALL
SELECT shipaddress
FROM Sales.OrdersArchive;



/*  

Q10

Display every bill address from both order tables.
*/
SELECT billaddress
FROM Sales.Orders
UNION ALL
SELECT billaddress
FROM Sales.OrdersArchive;


/************************  Pattern — INTERSECT  *************************

Clue Words
common
exists in both
present in both
shared

Think
INTERSECT
*/

 
/*  Q1

Display customer IDs present in both

Customers

and

Orders.  */
SELECT customerid
FROM Sales.Customers
INTERSECT
SELECT customerid 
FROM Sales.Orders;



/* Q2

Display salesperson IDs present in both

Employees

and

Orders.  */
SELECT employeeid
FROM Sales.Employees
INTERSECT
SELECT salespersonid
FROM Sales.Orders;



/* Q3

Display product IDs present in both

Products

and

Orders.  */
SELECT productid
FROM Sales.Products 
INTERSECT
SELECT productid
FROM Sales.Orders;




/* Q4

Display order statuses common to

Orders

and

Orders Archive.  */
SELECT orderstatus
FROM Sales.Orders
INTERSECT
SELECT orderstatus
FROM Sales.OrdersArchive;



/*  Q5

Display order dates appearing in both tables. */
SELECT orderdate
FROM Sales.Orders
INTERSECT
SELECT orderdate
FROM Sales.OrdersArchive;




/*  Q6

Display ship addresses existing in both tables. */
SELECT shipaddress
FROM Sales.Orders
INTERSECT
SELECT shipaddress
FROM Sales.OrdersArchive;


/*  Q7

Display bill addresses existing in both tables. */
SELECT billaddress
FROM Sales.Orders
INTERSECT
SELECT billaddress
FROM Sales.OrdersArchive;



/* Q8

Display sales amounts common to both order tables.  */
SELECT sales
FROM Sales.Orders
INTERSECT
SELECT sales
FROM Sales.OrdersArchive;



/* Q9

Display quantities appearing in both tables.  */
SELECT quantity
FROM Sales.Orders
INTERSECT
SELECT quantity
FROM Sales.OrdersArchive;




/*  Q10

Display product IDs sold in both years (current and archive). */
SELECT productid
FROM Sales.Orders
INTERSECT
SELECT productid
FROM Sales.OrdersArchive;


/************************* Pattern — EXCEPT  ******************************
(MySQL uses NOT EXISTS or LEFT ANTI JOIN instead.)

Practice these first as EXCEPT.

Clue Words
only in
except
not in
missing from
excluding

Think
EXCEPT

*/

/*  Q1
Display customer IDs present in Customers but not in Orders.  */
SELECT customerid
FROM Sales.Customers
EXCEPT
SELECT customerid
FROM Sales.Orders;


/*  Q2
Display employee IDs never appearing as salesperson. */
SELECT employeeid
FROM Sales.Employees
EXCEPT
SELECT salespersonid
FROM Sales.Orders;



/*  Q3
Display products never ordered. */
SELECT productid
FROM Sales.Products
EXCEPT
SELECT productid
FROM Sales.Orders;



/*  Q4
Display order statuses existing in Orders but not in Orders Archive */
SELECT orderstatus
FROM Sales.Orders
EXCEPT
SELECT orderstatus
FROM Sales.OrdersArchive;



/* Q5
Display order dates present in Orders but missing from Orders Archive.  */
SELECT orderdate
FROM Sales.Orders
EXCEPT
SELECT orderdate
FROM Sales.OrdersArchive;



/*  Q6
Display ship addresses existing only in Orders. */
SELECT shipaddress
FROM Sales.Orders
EXCEPT
SELECT shipaddress
FROM Sales.OrdersArchive;



/*  Q7
Display bill addresses existing only in Archive. */
SELECT billaddress
FROM Sales.OrdersArchive
EXCEPT
SELECT billaddress
FROM Sales.Orders;



/*  Q8
Display product IDs sold only in current orders. */
SELECT productid
FROM Sales.Orders
EXCEPT
SELECT productid
FROM Sales.OrdersArchive;




/* Q9
Display product IDs sold only in archive orders.  */
SELECT productid
FROM Sales.OrdersArchive
EXCEPT
SELECT productid
FROM Sales.Orders;




/*  Q10
Display sales amounts existing in current orders but not archive. */
SELECT sales
FROM Sales.Orders
EXCEPT
SELECT sales
FROM Sales.OrdersArchive;