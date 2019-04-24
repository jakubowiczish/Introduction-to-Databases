-- Dla każdego zamówienia podaj łączną liczbę zamówionych
-- jednostek towaru oraz nazwę klienta.
select o.OrderID, sum(od.Quantity) as 'laczna liczba zamowionych jednostek', c.ContactName
from [Order Details] as od
       join Orders as o on o.OrderID = od.OrderID
       join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.ContactName
order by o.OrderID

-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
-- dla których łączna liczbę zamówionych jednostek jest większa niż
-- 250
select o.OrderID, sum(od.Quantity) as 'liczba zamowionych jednostek', c.ContactName
from [Order Details] as od
       join Orders as o on o.OrderID = od.OrderID
       join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.ContactName
having sum(od.Quantity) > 250
order by o.OrderID

-- Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz
-- nazwę klienta.
select o.OrderID, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), c.CustomerID
from Orders as o
       join [Order Details] as od on od.OrderID = o.OrderID
       join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.CustomerID
order by o.OrderID

-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
-- dla których łączna liczba jednostek jest większa niż 250.
select o.OrderID, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), c.CustomerID
from Orders as o
       join [Order Details] as od on od.OrderID = o.OrderID
       join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.CustomerID
having sum(od.Quantity) > 250
order by o.OrderID

-- Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i
-- nazwisko pracownika obsługującego zamówienie
select o.OrderID, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), c.CustomerID, e.FirstName, e.LastName
from Orders as o
       join [Order Details] as od on od.OrderID = o.OrderID
       join Customers as c on c.CustomerID = o.CustomerID
       join Employees as e on e.EmployeeID = o.EmployeeID
group by o.OrderID, c.CustomerID, e.FirstName, e.LastName
having sum(od.Quantity) > 250
order by o.OrderID


-- Dla każdej kategorii produktu (nazwa), podaj łączną liczbę
-- zamówionych przez klientów jednostek towarów z tek kategorii.
select c.CategoryName, sum(od.Quantity)
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
       join [Order Details] as od on od.ProductID = p.ProductID
group by c.CategoryName

-- Dla każdej kategorii produktu (nazwa), podaj łączną wartość
-- zamówionych przez klientów jednostek towarów z tej kategorii.
select c.CategoryName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
       join [Order Details] as od on od.ProductID = p.ProductID
group by c.CategoryName

-- Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
select c.CategoryName, sum(od.Quantity)
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
       join [Order Details] as od on od.ProductID = p.ProductID
group by c.CategoryName
order by sum(od.Quantity)

select c.CategoryName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
       join [Order Details] as od on od.ProductID = p.ProductID
group by c.CategoryName
order by sum(od.Quantity * od.UnitPrice * (1 - od.Discount))

-- Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za
-- przesyłkę

select o.OrderID,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from [Order Details] as od
        where o.OrderID = od.OrderID) + o.Freight as 'wartosc zamowienia'
from Orders as o
order by o.OrderID

-- Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które
-- przewieźli w 1997r
select s.CompanyName, count(OrderDate)
from Shippers as s
       join Orders as o on o.ShipVia = s.ShipperID
where year(o.OrderDate) = 1997
group by s.CompanyName

-- Który z przewoźników był najaktywniejszy (przewiózł największą
-- liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika
select top 1 s.CompanyName, count(OrderDate)
from Shippers as s
       join Orders as o on o.ShipVia = s.ShipperID
where year(o.OrderDate) = 1997
group by s.CompanyName
order by 2 desc

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
-- zamówień obsłużonych przez tego pracownika
select e.FirstName, e.LastName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as 'laczna wartosc zamowien'
from Employees as e
       join Orders as o on o.EmployeeID = e.EmployeeID
       join [Order Details] as od on o.OrderID = od.OrderID
group by FirstName, LastName

-- Który z pracowników obsłużył największą liczbę zamówień w 1997r,
-- podaj imię i nazwisko takiego pracownika
select top 1 e.FirstName, e.LastName, count(o.OrderID)
from Employees as e
       join Orders as o on o.EmployeeID = e.EmployeeID
where year(o.OrderDate) = 1997
group by e.FirstName, e.LastName
order by count(o.OrderID) desc

-- Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia
-- o największej wartości) w 1997r, podaj imię i nazwisko takiego
-- pracownika
select top 1 e.FirstName, e.LastName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
from Employees as e
       join Orders as o on e.EmployeeID = o.EmployeeID
       join [Order Details] as od on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997
group by e.FirstName, e.LastName
order by sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) desc

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
-- zamówień obsłużonych przez tego pracownika
-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych
-- a)
select e.FirstName, e.LastName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
from Employees as e
       join Orders as o on o.EmployeeID = e.EmployeeID
       join [Order Details] as od on od.OrderID = o.OrderID
where e.ReportsTo is not null
group by e.FirstName, e.LastName

-- b)
select e.FirstName, e.LastName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
from Employees as e
       join Orders as o on o.EmployeeID = e.EmployeeID
       join [Order Details] as od on od.OrderID = o.OrderID
where e.ReportsTo is null
group by e.FirstName, e.LastName















































