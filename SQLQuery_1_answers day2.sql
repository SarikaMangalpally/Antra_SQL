
--1. How many products can you find in the Production.Product table?
SELECT count(ProductID) 'Products Count'
from Production.Product

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT count(ProductID) 'No Of Products'
FROM Production.Product
where ProductSubcategoryID is not NULL

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, count(ProductID) as 'Counted Products'
From Production.Product
WHERE ProductSubcategoryID is NOT NULL
GROUP BY ProductSubcategoryID
ORDER BY 'Counted Products' DESC

--4. How many products that do not have a product subcategory.
SELECT count(ISNULL(ProductSubcategoryID, 0))
from Production.ProductSubcategory

--5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT sum(Quantity) 'Sum of all Products Quantity'
From Production.ProductInventory

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100. 
SELECT ProductID, sum(Quantity) TheSum
From Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity)<100

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, sum(Quantity) TheSum
From Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity)<100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, Avg(Quantity) AverageQuantity
from Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT Shelf, ProductID, avg(Quantity) AverageQuantity
from Production.ProductInventory
GROUP BY ProductID, Shelf

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT Shelf, ProductID, avg(Quantity) AverageQuantity
from Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf

--11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, Count(ListPrice) TheCount, AVG(ListPrice) 'AvgPrice'
FROM Production.Product
where Color IS NOT Null and Class IS NOT NULL
GROUP by Color, Class

--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT cr.Name Country, sp.StateProvinceCode Province
from Person.StateProvince sp
left join Person.CountryRegion cr on sp.CountryRegionCode = cr.CountryRegionCode

--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

SELECT cr.Name Country, sp.StateProvinceCode Province
from Person.StateProvince sp
left join Person.CountryRegion cr on sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')


---------------------------------------------------
        -- USING NORTHWIND DATABASE --
---------------------------------------------------

--14. List all Products that has been sold at least once in last 27 years.
SELECT p.ProductID, p.ProductName, o.OrderID, o.OrderDate
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate <= DATEADD(YEAR, -27, GETDATE())

--15. List top 5 locations (Zip Code) where the products sold most.
SELECT top 5 o.OrderID, count(o.OrderID) 'Orders Sold', o.ShipPostalCode
FROM [Order Details] od
join Orders o on od.OrderID = o.OrderID
GROUP by o.OrderID, o.ShipPostalCode
ORDER BY 'Orders Sold' DESC


--16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT top 5 o.OrderID, count(o.OrderID) 'Orders Sold', o.ShipPostalCode
FROM [Order Details] od
join Orders o on od.OrderID = o.OrderID
WHERE o.OrderDate <= DATEADD(YEAR, -27, GETDATE())
GROUP by o.OrderID, o.ShipPostalCode
ORDER BY 'Orders Sold' DESC

--17.   List all city names and number of customers in that city.
SELECT c.City,  count(c.CustomerID) 'Number of Customers'
From customers c
JOIN Orders o on o.CustomerID = c.CustomerID
GROUP by c.City
ORDER BY [Number of Customers] DESC


--18. List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, count(c.CustomerID) 'Number of Customers'
From customers c
JOIN Orders o on o.CustomerID = c.CustomerID
GROUP by c.City
HAVING COUNT(c.CustomerID) > 2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT distinct c.CompanyName
from customers c
join orders o on o.CustomerID = c.CustomerID
WHERE o.OrderDate > '1/1/98'
--20. List the names of all customers with most recent order dates
select c.CustomerID, c.CompanyName, max(o.OrderDate) RecentOrders
from Customers c
JOIN Orders o on o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY RecentOrders DESC

--21. Display the names of all customers  along with the  count of products they bought
select distinct c.ContactName, count(p.ProductID) ProductsCount
from customers c 
join orders o on o.CustomerID = c.CustomerID
join [Order Details] od on od.OrderID = o.OrderID
JOIN Products p on od.ProductID = p.ProductID
GROUP BY c.ContactName
ORDER BY ProductsCount DESC

--22. Display the customer ids who bought more than 100 Products with count of products.
select distinct c.CustomerID, count(p.ProductID) ProductsCount
from customers c 
join orders o on o.CustomerID = c.CustomerID
join [Order Details] od on od.OrderID = o.OrderID
JOIN Products p on od.ProductID = p.ProductID
GROUP BY c.CustomerID
HAVING count(p.ProductID) > 100
ORDER BY ProductsCount DESC

-- .  List all of the possible ways that suppliers can ship their products. Display the results as below

 --   Supplier Company Name                Shipping Company Name

    ---------------------------------            ----------------------------------

select distinct s.CompanyName 'Suppliers Company Name' , sh.CompanyName 'Shipping Company Name'
from Suppliers s
join Products p on p.SupplierID = s.SupplierID
join [Order Details] od on od.ProductID = p.ProductID
join orders o on o.OrderID = od.OrderID
join Shippers sh on sh.ShipperID = o.ShipVia

--24. Display the products order each day. Show Order date and Product Name.

--25. Displays pairs of employees who have the same job title.
select e.Title, e.FirstName + ' ' + e.LastName as Employee1, em.FirstName + ' ' + em.LastName as Employee2
from Employees e 
inner join Employees em on e.Title = em.Title
where e.EmployeeID < em.EmployeeID

--26. Display all the Managers who have more than 2 employees reporting to them.
select m.EmployeeID, count(em.EmployeeID) 'Employees Reporting'
from Employees m
join Employees em on m.EmployeeID = em.ReportsTo
where m.EmployeeID > 2
GROUP BY m.EmployeeID
ORDER BY 'Employees Reporting' DESC
