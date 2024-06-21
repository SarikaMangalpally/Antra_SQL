-- 1.      List all cities that have both Employees and Customers.
SELECT distinct e.city
from Employees e 
inner join Customers c on e.City = c.City

-- 2.      List all cities that have Customers but no Employee.

-- a.      Use sub-query
SELECT distinct city
from customers s
where city not in (
    select distinct City
    from Employees
)

-- b.      Do not use sub-query

SELECT distinct c.City
FROM customers c
LEFT JOIN Employees e on c.City = e.City
where e.City is NULL

-- 3.      List all products and their total order quantities throughout all orders.
SELECT p.ProductID, p.ProductName, count(od.Quantity) 'Total Order Quantities'
from Products p
JOIN [Order Details] od on od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName

-- 4.      List all Customer Cities and total products ordered by that city.

SELECT c.City, p.ProductID, sum(od.Quantity) 
from Customers c
join Orders o on c.CustomerID = o.CustomerID 
join [Order Details] od on od.OrderID = o.OrderID
JOIN Products p on p.ProductID = od.ProductID
GROUP BY c.City, p.ProductID


-- 5.      List all Customer Cities that have at least two customers.

-- a.      Use union
-- select City, count(City) cityCount
-- from Customers 
-- GROUP BY City
-- HAVING count(City) > 2

select City
from customers 
GROUP BY City
HAVING count(*) >= 2
union
select city
from customers 
GROUP BY City
HAVING count(*) >= 2

-- b.      Use sub-query and no union
SELECT distinct City
FROM Customers
where City in (
    select City
    from customers 
    GROUP BY City
    having count(city) >= 2
)

-- 6.      List all Customer Cities that have ordered at least two different kinds of products.
SELECT distinct c.City
from Customers c
JOIN Orders o on o.CustomerID = c.CustomerID
JOIN [Order Details] od on od.OrderID = o.OrderID
JOIN Products p on p.ProductID = od.ProductID
GROUP BY c.City, o.OrderID
HAVING count(distinct p.ProductID) >= 2


-- 7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT distinct c.CustomerID, c.ContactName
from customers c 
JOIN Orders o on o.CustomerID = c.CustomerID
WHERE c.City <> o.ShipCity

-- 8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select TOP 5 p.ProductID,p.ProductName, AVG(od.UnitPrice), c.City, RANK() OVER(order by sum(od.quantity) desc) rank
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on o.OrderID = od.OrderID
JOIN Customers c on c.CustomerID = o.CustomerID
GROUP BY p.ProductID,p.ProductName, c.City
ORDER BY rank DESC

-- 9.      List all cities that have never ordered something but we have employees there.

-- a.      Use sub-query
SELECT distinct city
from Employees 
where City not IN (
    select distinct ShipCity 
    from Orders
)
-- b.      Do not use sub-query
SELECT e.City
from orders o
right JOIN Employees e on o.ShipCity = e.city
WHERE o.ShipCity is NULL

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
WITH MostOrdersEmployee AS(
select e.City, count(OrderID) 'Number of Orders'
from Employees e
join orders o on e.EmployeeID = o.EmployeeID
GROUP BY City
), 
ProductQuantity AS (
SELECT o.ShipCity, sum(od.Quantity) TotalQuantity
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
GROUP BY o.ShipCity

)
SELECT me.City
from MostOrdersEmployee me
join ProductQuantity pq on me.City = pq.ShipCity
order by me.City DESC, pq.TotalQuantity DESC

-- 11. How do you remove the duplicates record of a table?
   -- CTE and DELETE method
        -- Define a cte to assign a ROW_NUMBER() to each row partition by the columns to determine the duplicates
        -- Delete the rows where the row_number is greater than 1
   -- JOIN and DELETE method
       -- Self join the table to determine the duplicates
       -- Delete the duplicate records where the id of one record is less than the id of the duplicate record

