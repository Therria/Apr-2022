USE Northwind
GO
--SELECT statement: identify which columns we want to retrieve

--1. SELECT all columns and rows
SELECT *
FROM Employees

--2. SELECT a list of columns
SELECT EmployeeID, LastName, FirstName, Title, ReportsTo
FROM Employees

SELECT e.EmployeeID, e.LastName, e.FirstName, e.Title, e.ReportsTo
FROM Employees e

--avoid using SELECT *
--1. unecessary data
--2. name coflict
SELECT *
FROM Employees

SELECT *
FROM Customers

SELECT *
	FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID JOIN Customers c ON o.CustomerID = c.CustomerID




--3. SELECT DISTINCT Value: list all the cities that employees located at
SELECT DISTINCT City
FROM Employees



--4. SELECT combined with plain text: retrieve the full name of employees
SELECT FirstName + ' ' +LastName Full Name
FROM Employees


--identifiers: name that we give to db, tables, columns, views..
--1) regular identifier: complies with rules for the format of identifiers
	--a)first char: a-z, A-Z, @, #
	--@: declare variables
		DECLARE @today datetime
		select @today = getdate()
		print @today

		print @today
	--#: create temp tables
	--b)subsequent chars: letter, numbers, @, $, #, _
	--c)the identifier must not be a SQL reserved word. both uppercase and lowercase
	SELECT MAX, AVG
	FROM TABLE
	--d)embedded space or other special cahrs are not allowed


--2) delimited identifiers: :"", []
SELECT FirstName + ' ' +LastName [Full Name]
FROM Employees

SELECT FirstName + ' ' +LastName "Full Name"
FROM Employees

SELECT *
FROM [Order Details]

--WHERE statement: filter records
--1. equal
--Customers who are from Germany
SELECT ContactName, Country
FROM Customers
WHERE Country = 'Germany'


--Product which price is $18
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 18


--2. Customers who are not from UK
SELECT ContactName, Country
FROM Customers
WHERE Country != 'UK'

SELECT ContactName, Country
FROM Customers
WHERE Country <> 'UK'


--IN Operator:retrieve among a list of values
--E.g: Orders that ship to USA AND Canada
SELECT OrderId, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry = 'USA' OR ShipCountry = 'Canada'

SELECT OrderId, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('USA', 'Canada')




--BETWEEN Operator: retreive in a consecutive range ; inclusive
--1. retreive products whose price is between 20 and 30.
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice >= 20 AND UnitPrice <= 30

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 AND 30



--NOT Operator: display a record if the condition is NOT TRUE
-- list orders that does not ship to USA or Canada
SELECT OrderId, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry NOT IN ('USA', 'Canada')

SELECT OrderId, CustomerID, ShipCountry
FROM Orders
WHERE NOT ShipCountry IN ('USA', 'Canada')

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice NOT BETWEEN 20 AND 30

SELECT ProductName, UnitPrice
FROM Products
WHERE NOT UnitPrice BETWEEN 20 AND 30



--NULL Value: a field with no value
--check which employees' region information is empty
SELECT Region
FROM Employees
WHERE Region is null

--exclude the employees whose region is null
SELECT Region
FROM Employees
WHERE Region is not null

--Null in numerical operation
CREATE TABLE TestSalary(EId int primary key identity(1,1), Salary money, Comm money)
INSERT INTO TestSalary VALUES(2000, 500), (2000, NULL),(1500, 500),(2000, 0),(NULL, 500),(NULL,NULL)

SELECT EId, Salary, Comm, ISNULL(Salary,0) + ISNULL(Comm,0) AS TotalCompensation
FROM TestSalary



--LIKE Operator: create a search expression
--1. Work with % wildcard character: % substitute to 0 or more chars
--retrieve all the employees whose last name starts with D
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE 'D%'

--2. Work with [] and % to search in ranges: find customers whose postal code starts with number between 0 and 3
SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode LIKE '[0-3]%'

--3. Work with NOT: 
SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode NOT LIKE '[0-3]%'


--4. Work with ^: any characters not in the brackets
SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode LIKE '[^0-3]%'

--Custermer name starting from letter A but not followed by l-n
SELECT ContactName
FROM Customers
WHERE ContactName LIKE 'A[^l-n]%'


--ORDER BY statement: sort the result set in ascending or descending order
--1. retrieve all customers except those in Boston and sort by Name
SELECT ContactName, City
FROM Customers
WHERE City != 'Boston'
ORDER BY ContactName DESC


--2. retrieve product name and unit price, and sort by unit price in descending order
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--3. Order by multiple columns
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC, ProductName DESC


--Batch Directives
CREATE DATABASE AprBatch
GO
Use AprBatch
GO
CREATE TABLE Employee(Id int, EName varchar(20), Salary money)

select *
from Employee