--JOIN: is used to combine rows from two or more tables, based on a related column between them

--1. INNER JOIN: return the records that have matching values in both tables
--find employees who have deal with any orders
SELECT e.EmployeeID, e.FirstName + '' + e.LastName EmployeeName, o.OrderDate
FROM Employees e INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID

SELECT e.EmployeeID, e.FirstName + '' + e.LastName EmployeeName, o.OrderDate
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID


--another way to write
SELECT e.EmployeeID, e.FirstName + '' + e.LastName EmployeeName, o.OrderDate
FROM Employees e, Orders o 
WHERE e.EmployeeID = o.EmployeeID


--get cusotmers information and corresponding order date
SELECT c.CompanyName, c.City, c.Country, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID

--join multiple tables:
--get customer name, the corresponding employee who is responsible for this order, and the order date
SELECT c.ContactName AS Customer, e.FirstName + ' ' + e.LastName AS Employee, o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID

--add detailed information about quantity and price, join Order details
SELECT c.ContactName Customer, e.FirstName + ' ' + e.LastName AS Employee, o.OrderDate, od.Quantity, od.UnitPrice
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID

--2. OUTER JOIN
--1) LEFT OUTER JOIN: return all the records from the left table, and matchting records from the right table, for the non-matchting records in the right table, the result set will set us null value
--list all customers whether they have made any purchase or not
SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID

SELECT c.ContactName, o.OrderID
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID

--JOIN with WHERE: find out customers who have never placed any order
SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderId is null

--2) RIGHT OUTER JOIN: return all records from the right table, and matchting records from the left table, if not matching, return null
SELECT c.ContactName, o.OrderID
FROM Orders o RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID

--3) FULL OUTER JOIN: return all rows from the left table and right table, if join condition is not met return null
--Match all customers and suppliers by country.
SELECT c.ContactName, c.Country AS CustomerCountry, s.Country AS SupplierCountry, s.CompanyName
FROM Customers c FULL JOIN Suppliers s ON c.Country = s.Country
ORDER BY c.Country, s.Country

--3. CROSS JOIN: create the cartesian product for two tables
--table 1: 10 rows, table 2: 20 rows --> cross join --> 200 rows returned
SELECT COUNT(*)
FROM Suppliers CROSS JOIN Products

SELECT COUNT(*)
FROM Suppliers

SELECT COUNT(*)
FROM Products

--* SELF JOIN： 
SELECT EmployeeID, FirstName, LastName, ReportsTo
FROM Employees

--CEO: Andrew
--Manager: Nancy, Janet, Margaret, Steven, Laura
--Employee: Michael, Robert, Anne

--find emloyees with the their manager name
SELECT e.FirstName + ' ' + e.LastName AS Employee, m.FirstName + ' ' + e.LastName AS Manager
FROM Employees e INNER JOIN Employees m ON e.ReportsTo = m.EmployeeID

--if we want to include Andrew
SELECT e.FirstName + ' ' + e.LastName AS Employee, ISnull(m.FirstName + ' ' + e.LastName,'N/A') AS Manager
FROM Employees e LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID


--Aggregation functions: perform a calculation on a set of values and return a single value
--1. COUNT(): returns the number of rows
SELECT COUNT(OrderId) as NumOfOrders
FROM Orders

--Count(*): equivalent to Count(number)

--COUNT(*) vs. COUNT(colName): COUNT(*) will include null value, but count (colname) will not
SELECT *
FROM Employees

SELECT count(*), count(region)
FROM Employees

--use w/ GROUP BY: group rows taht have the same values into summary rows
--find total number of orders placed by each customers
SELECT c.CustomerID, c.ContactName, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Orders o INNER JOIN Customers c on c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.ContactName, c.Country
ORDER BY NumOfOrders DESC

--a more complex template: 
--only retreive total order numbers where customers located in USA or Canada, and order number should be greater than or equal to 10
SELECT c.CustomerID, c.ContactName, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Orders o INNER JOIN Customers c on c.CustomerID = o.CustomerID 
WHERE c.Country IN ('USA','Canada')
GROUP BY c.CustomerID, c.ContactName, c.Country
HAVING COUNT(o.OrderID) >= 10
ORDER BY NumOfOrders DESC

--SELECT fields, aggregate(fields) 
--FROM table JOIN ...
--WHERE criteria -- optional
--GROUP BY fields
--HAVING criteria --optional
--ORDER BY field --optional

--SQL Execution Order
--FROM/JOIN -> WHERE -> GROUP BY -> HAVING ->SELECT -> DISTINCT -> ORDER BY 
			  --|________________________|
			  --alias in SELECT will not work

SELECT c.CustomerID, c.ContactName, c.Country Cty, COUNT(o.OrderID) AS NumOfOrders
FROM Orders o INNER JOIN Customers c on c.CustomerID = o.CustomerID 
WHERE Cty IN ('USA','Canada')
GROUP BY c.CustomerID, c.ContactName, cty
HAVING NumOfOrders >= 10
ORDER BY NumOfOrders DESC

--WHERE vs. HAVING
--1) both are used as filters. Having applies only to groups a s a whole, and only filters on aggregation functions; but WHERE applies to individual rows
--2)where go before aggreagations, but having go after the aggregation
--3) WHERE can be used with SELECT, UPDATE, DELETE. BUT having can be used only with select

SELECT *
FROM Products

update Products
SET UnitPrice = 18
WHERE ProductID = 1

--COUNT DISTINCT: only count unique value
SELECT City
FROM Customers

SELECT COUNT(Distinct City) AS NumOfCity
FROM Customers


--2. AVG(): return the average value of a numeric column
--list average revenue for each customer
SELECT c.ContactName, AVG(od.UnitPrice * od.Quantity) as AvgRevenuePerCustomer
FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
ORDER BY AvgRevenuePerCustomer DESC


--3. SUM(): 
--list sum of revenue for each customer
SELECT c.ContactName, SUM(od.UnitPrice * od.Quantity) as SumRevenuePerCustomer
FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
ORDER BY SumRevenuePerCustomer DESC

--4. MAX(): 
--list maxinum revenue from each customer
SELECT c.ContactName, max(od.UnitPrice * od.Quantity) as MaxRevenuePerCustomer
FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
ORDER BY MaxRevenuePerCustomer DESC


--5.MIN(): 
--list the cheapeast product bought by each customer
SELECT c.ContactName, MIN(od.UnitPrice) AS CheapestProductPerCustomer
FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName


--TOP predicate: select a specific number or a certain percentage of records from data
--retrieve top 5 most expensive products
SELECT TOP 5 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--retrieve top 10 percent most expensive products
SELECT TOP 10 PERCENT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--list top 5 customers who created the most total revenue
SELECT TOP 5 c.ContactName, SUM(od.UnitPrice * od.Quantity) as SumRevenuePerCustomer
FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
ORDER BY SumRevenuePerCustomer DESC


--Subquery: is a select statement that is embedded in a clause of another SQL statement

--find the customers from the same city whre Alejandra Camino lives 
--find the city where Alejandra Camino lives
SELECT ContactName, City
FROM Customers
WHERE City IN 
(SELECT City
FROM Customers
WHERE ContactName = 'Alejandra Camino')


--find customers who make any orders
--join
SELECT DISTINCT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID

--subquery
SELECT CustomerID, ContactName, City, Country
FROM Customers
WHERE CustomerID IN (
SELECT DISTINCT CustomerID FROM Orders
)


--subquery vs. join
--1) join can only be used in from clause, but subquery can be used in SELECT, WHERE, HAVING, FROM, ORDER BY clause
---list all the order data and the corresponding employee whose in charge of this order
--join
SELECT o.OrderDate, E.FirstName, E.LastName
FROM Orders o INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.City = 'London'
ORDER BY o.OrderDate, E.FirstName, E.LastName

--subquery
SELECT o.OrderDate,
(SELECT e1.FirstName FROM Employees e1 WHERE o.EmployeeID = e1.EmployeeID) AS FirstName,
(SELECT e2.LastName FROM Employees e2 WHERE o.EmployeeID = e2.EmployeeID) AS LastName
FROM Orders o
WHERE (SELECT e3.City FROM Employees e3 WHERE o.EmployeeID = e3.EmployeeID) = 'London'
ORDER BY o.OrderDate,
(SELECT e1.FirstName FROM Employees e1 WHERE o.EmployeeID = e1.EmployeeID) ,
(SELECT e2.LastName FROM Employees e2 WHERE o.EmployeeID = e2.EmployeeID)

--2) subquery is easy to understand and maintain
--find customers who never placed any order
--join
SELECT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID is null

--subquery
SELECT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c 
WHERE CustomerID NOT IN (
select distinct CustomerID FROM Orders
)

--3) usually join will have a better performance than subquery


--Correlated Subquery: subqery where inner query is dependent on the outer query

--Customer name and total number of orders by customer
--join
SELECT c.ContactName, COUNT(o.OrderID) AS NumOfOrders
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
order by NumOfOrders DESC

--corrlated subqury
SELECT c.ContactName,
(SELECT COUNT(o.OrderId) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS NumOfOrders
FROM Customers c 
order by NumOfOrders DESC


--derived table: subquery used in from clause
--syntax
SELECT CustomerID, ContactName
FROM (
SELECT *
FROM Customers) dt


--customers and the number of orders they made
SELECT c.ContactName,c.CompanyName,c.City, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName,c.CompanyName,c.City, c.Country
ORDER BY NumOfOrders DESC

--optimized with derived table
SELECT c.ContactName,c.CompanyName,c.City, c.Country, dt.NumOfOrders
FROM Customers c LEFT JOIN 
(
SELECT CustomerID, COUNT(OrderID) NumOfOrders
FROM Orders 
GROUP BY CustomerID
) dt ON c.CustomerId = dt.CustomerId
ORDER BY dt.NumOfOrders desc
