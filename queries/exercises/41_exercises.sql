use Northwind

--Wybierz nazwy i numery telefonów klientów , którym w 1997 roku
-- przesyłki dostarczała firma United Package
select c.ContactName, c.Phone
from Customers as c
       join Orders as o on o.CustomerID = c.CustomerID
       join Shippers as s on s.ShipperID = o.ShipVia
where s.CompanyName = 'United Package'
  and year(o.OrderDate) = 1997
group by c.ContactName, c.Phone

select c.ContactName, c.Phone
from Customers as c
where exists
  (select *
   from Orders as o
   where o.CustomerID = c.CustomerID
     and year(o.ShippedDate) = 1997
     and exists(select * from Shippers as s where s.ShipperID = o.ShipVia and s.CompanyName = 'United Package'))

-- Wybierz nazwy i numery telefonów klientów, którzy kupowali
-- produkty z kategorii Confections
select c.ContactName, c.CustomerID, c.Phone
from Customers as c
       join Orders as o on o.CustomerID = c.CustomerID
       join [Order Details] as od on od.OrderID = o.OrderID
       join Products as p on p.ProductID = od.ProductID
       join Categories as ca on ca.CategoryID = p.CategoryID
where ca.CategoryName = 'Confections'
group by c.CustomerID, ContactName, Phone

select ContactName, Phone
from Customers as c
       join Orders as o on c.CustomerID = o.CustomerID
       join [Order Details] as od on od.OrderID = o.OrderID
       join Products as p on p.ProductID = od.ProductID
       join Categories as ca on ca.CategoryName = 'Confections' and ca.CategoryID = p.CategoryID
group by ContactName, Phone

-- Wybierz nazwy i numery telefonów klientów, którzy nie kupowali
-- produktów z kategorii Confections

select ContactName, Phone
from Customers as c
     except
select ContactName, Phone
from Customers as c
       join Orders as o on c.CustomerID = o.CustomerID
       join [Order Details] as od on od.OrderID = o.OrderID
       join Products as p on p.ProductID = od.ProductID
       join Categories as ca on ca.CategoryName = 'Confections' and ca.CategoryID = p.CategoryID
group by ContactName, Phone

-- Dla każdego produktu podaj maksymalną liczbę zamówionych
-- jednostek
select ProductName,
       (
         select max(Quantity) as maxQ
         from [Order Details]
                as od
         where p.ProductID = od.ProductID
       )
from Products as p

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia
-- cena produktu
select ProductName
from Products as p
where p.UnitPrice < (select avg(UnitPrice) from Products)

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia
-- cena produktu danej kategorii
select ProductName
from Products as p
where p.UnitPrice < (select avg(UnitPrice) from Products as p2 where p2.CategoryID = p.CategoryID
)

-- Dla każdego produktu podaj jego nazwę, cenę, średnią cenę
-- wszystkich produktów oraz różnicę między ceną produktu a
-- średnią ceną wszystkich produktów
select p.ProductName,
       p.UnitPrice,
       (select avg(p2.UnitPrice) from Products as p2)                 as 'srednia cena',
       (p.UnitPrice - (select avg(p2.UnitPrice) from Products as p2)) as 'roznica'
from Products as p
group by ProductName, UnitPrice

-- napisz polecenie ktore wyswietla pracownikow ktorzy nie maja podwladnych
select FirstName, LastName, EmployeeID
from Employees as e
where e.ReportsTo is null

select FirstName, LastName, EmployeeID
from Employees as e
where e.EmployeeID not in
      (select ReportsTo from Employees where e.ReportsTo is not null)

-- Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu,
-- cenę, średnią cenę wszystkich produktów danej kategorii oraz
-- różnicę między ceną produktu a średnią ceną wszystkich
-- produktów danej kategorii
select CategoryName,
       ProductName,
       UnitPrice,
       (select avg(UnitPrice) from Products as p2 where p2.CategoryID = p.CategoryID)                    as 'srednia cena',
       (p.UnitPrice - (select avg(p2.UnitPrice) from Products as p2 where p2.CategoryID = p.CategoryID)) as 'roznica'
from Products as p
       join Categories as c on c.CategoryID = p.CategoryID
group by c.CategoryName, p.ProductName, p.CategoryID, p.UnitPrice

-- Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij
-- cenę za przesyłkę)
select o.OrderID,
       ((select sum(UnitPrice * Quantity * (1 - Discount))
         from [Order Details] as od
         where od.OrderID = o.OrderID) + o.Freight) as 'wartosc zamowienia'
from Orders as o
where OrderID = 10250

-- Podaj łączną wartość zamówień każdego zamówienia (uwzględnij
-- cenę za przesyłkę
select o.OrderID,
       ((select sum(UnitPrice * Quantity * (1 - Discount))
         from [Order Details] as od
         where od.OrderID = o.OrderID) + o.Freight) as 'wartosc zamowienia'
from Orders as o

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997
-- roku, jeśli tak to pokaż ich dane adresowe
select c.CustomerID, c.Address
from Customers as c
     except
select c.CustomerID, c.Address
from Customers as c
       join Orders as o on c.CustomerID = o.CustomerID
where year(OrderDate) = 1997

select *
from Customers as c
where not exists(
    select *
    from Orders as o
    where o.CustomerID = c.CustomerID
      and year(o.OrderDate) = 1997
  )

select *
from Customers as c
       left outer join Orders as o on o.CustomerID = c.CustomerID
  and year(OrderDate) = 1997
where OrderID is null

-- Podaj produkty kupowane przez więcej niż jednego klienta
select p.ProductName,
       (select count(distinct c.CustomerID)
        from Customers as c
               join Orders as o on o.CustomerID = c.CustomerID
               join [Order Details] as od on od.OrderID = o.OrderID
        where od.ProductID = p.ProductID) as 'unikalni klienci'
from Products as p
where (select count(distinct c.CustomerID)
       from Customers as c
              join Orders as o on o.CustomerID = c.CustomerID
              join [Order Details] as od on od.OrderID = o.OrderID
       where od.ProductID = p.ProductID) > 1
order by p.ProductName


select p.ProductName
from Products as p
       join [Order Details] as od on od.ProductID = p.ProductID
       join Orders as o on o.OrderID = od.OrderID
group by p.ProductName
having count(o.CustomerID) > 1
order by p.ProductName

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
-- zamówień obsłużonych przez tego pracownika (przy obliczaniu
-- wartości zamówień uwzględnij cenę za przesyłkę_
select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from [Order Details] as od
               join Orders as o on o.EmployeeID = e.EmployeeID) +
       (select sum(o2.Freight) from Orders as o2 where o2.EmployeeID = e.EmployeeID)
from Employees as e

-- Który z pracowników obsłużył najaktywniejszy (obsłużył
-- zamówienia o największej wartości) w 1997r, podaj imię i nazwisko
-- takiego pracownika
select top 1 e.FirstName,
             e.LastName,
             (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
              from Orders as o
                     join [Order Details] as od on od.OrderID = o.OrderID
              where o.EmployeeID = e.EmployeeID
                and year(o.OrderDate) = 1997
             )
from Employees as e
order by 3 desc

-- do powyzszego
-- Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych
select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from Orders as o
               join [Order Details] as od on od.OrderID = o.OrderID
        where o.EmployeeID = e.EmployeeID
          and year(o.OrderDate) = 1997
       )
from Employees as e
where exists(select * from Employees as e2 where e.EmployeeID = e2.ReportsTo)

select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from Orders as o
               join [Order Details] as od on od.OrderID = o.OrderID
        where o.EmployeeID = e.EmployeeID
          and year(o.OrderDate) = 1997
       )
from Employees as e
where not exists(select * from Employees as e2 where e.EmployeeID = e2.ReportsTo)

-- Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać
-- jeszcze datę ostatnio obsłużonego zamówienia
select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from Orders as o
               join [Order Details] as od on od.OrderID = o.OrderID
        where o.EmployeeID = e.EmployeeID
          and year(o.OrderDate) = 1997
       ),
       (select top 1 o2.OrderDate from Orders as o2 where o2.EmployeeID = e.EmployeeID order by 1 desc)
from Employees as e
where exists(select * from Employees as e2 where e.EmployeeID = e2.ReportsTo)

select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from Orders as o
               join [Order Details] as od on od.OrderID = o.OrderID
        where o.EmployeeID = e.EmployeeID
          and year(o.OrderDate) = 1997
       ),
       (select top 1 o2.OrderDate from Orders as o2 where o2.EmployeeID = e.EmployeeID order by 1 desc)
from Employees as e
where not exists(select * from Employees as e2 where e.EmployeeID = e2.ReportsTo)






























