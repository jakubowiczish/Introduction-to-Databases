-- GRUPA D

-- 1) Dla ka¿dego klienta znajd wartoæ wszystkich z³o¿onych zamówieñ (we pod uwagê koszt przesy³ki)
use Northwind
select CompanyName, sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) + sum(o.Freight) as 'wartosc zamowien'
from Customers as c
       left join Orders as o on o.CustomerID = c.CustomerID
       left join [Order Details] as od on od.OrderID = o.OrderID
group by CompanyName
order by [wartosc zamowien] desc

-- 2) Czy s¹ jacy klienci, którzy nie z³o¿yli ¿adnego zamówienia w 1997 roku? Jeli tak, wywietl ich dane adresowe. Wykonaj za pomoc¹ operatorów:
-- a)join b)in c)exist
-- JOIN
select c.CompanyName, c.Address, c.City
from Customers as c
     except
select c.CompanyName, c.Address, c.City
from Customers as c
       join Orders as o on o.CustomerID = c.CustomerID
where year(o.OrderDate) = 1997

select c.CompanyName, c.Address, c.City
from Customers as c
       left join Orders as o on o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997
where year(o.OrderDate) is null

--IN
select c.CompanyName, c.Address, c.City
from Customers as c
where c.CustomerID not in (select Orders.CustomerID from Orders where year(OrderDate) = 1997)

--EXISTS
select c.CompanyName, c.Address, c.City
from Customers as c
where not exists(select o.CustomerID from Orders as o where year(OrderDate) = 1997 and c.CustomerID = o.CustomerID)

-- 3) Dla ka¿dego dziecka zapisanego w bibliotece wywietl jego imiê i nazwisko,
-- adres zamieszkania, imiê i nazwisko rodzica (opiekuna) oraz liczbê wypo¿yczonych
-- ksi¹¿ek w grudniu 2001 roku przez dziecko i opiekuna.
-- *) Uwzglêdnij tylko te dzieci, dla których liczba wypo¿yczonych ksi¹¿ek jest wiêksza od 1
select ch.firstname,
       ch.lastname,
       a.state,
       a.city,
       a.street,
       par.firstname,
       par.lastname,
       (select count(*)
        from loanhist as lh
        where lh.member_no = par.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez opiekuna',
       (select count(*)
        from loanhist as lh
        where lh.member_no = ch.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez dziecko',
       (select count(*)
        from loanhist as lh
        where lh.member_no = par.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) +
       (select count(*)
        from loanhist as lh
        where lh.member_no = ch.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez dziecko i opiekuna w sumie'
from member as m
       join adult as a on m.member_no = a.member_no
       join member as par on a.member_no = par.member_no
       join juvenile as j on j.adult_member_no = a.member_no
       join member as ch on ch.member_no = j.member_no
group by ch.firstname, ch.lastname, a.state, a.city, a.street, par.firstname, par.lastname, m.member_no, par.member_no,
         ch.member_no

-- *)
select ch.firstname,
       ch.lastname,
       a.state,
       a.city,
       a.street,
       par.firstname,
       par.lastname,
       (select count(*)
        from loanhist as lh
        where lh.member_no = par.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez opiekuna',
       (select count(*)
        from loanhist as lh
        where lh.member_no = ch.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez dziecko',
       (select count(*)
        from loanhist as lh
        where lh.member_no = par.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) +
       (select count(*)
        from loanhist as lh
        where lh.member_no = ch.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) as 'liczba wypozyczonych ksiazek przez dziecko i opiekuna w sumie'
from member as m
       join adult as a on m.member_no = a.member_no
       join member as par on a.member_no = par.member_no
       join juvenile as j on j.adult_member_no = a.member_no
       join member as ch on ch.member_no = j.member_no
where (select count(*)
       from loanhist as lh
       where lh.member_no = ch.member_no
         and year(lh.out_date) = 2001
         and month(lh.out_date) = 12) > 1
group by ch.firstname, ch.lastname, a.state, a.city, a.street, par.firstname, par.lastname, m.member_no, par.member_no,
         ch.member_no


-- 4) Dla ka¿dej kategorii produktów wypisz po miesi¹cach wartoæ sprzedanych z niej produktów.
-- Interesuj¹ nas tylko lata 1996-1997
use Northwind
select c.CategoryName,
       month(o.OrderDate)                                  as month,
       year(o.OrderDate)                                   as year,
       sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as wartosc
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
       join [Order Details] as od on od.ProductID = p.ProductID
       join Orders as o on o.OrderID = od.OrderID
where year(o.OrderDate) = 1996
   or year(o.OrderDate) = 1997
group by c.CategoryName, year(o.OrderDate), month(o.OrderDate)
order by 3, 2


-- GRUPA A

-- 1
-- Dla ka¿dego produktu podaj nazwê jego kategorii, nazwê produktu, cenê, redni¹ cenê wszystkich
-- produktów danej kategorii, ró¿nicê miêdzy cen¹ produktu a redni¹ cen¹ wszystkich produktów
-- danej kategorii, dodatkowo dla ka¿dego produktu podaj wartoc jego sprzeda¿y w marcu 1997
use Northwind
select p.ProductName,
       c.CategoryName,
       p.UnitPrice,
       (select avg(p2.UnitPrice) from Products as p2 where p2.CategoryID = c.CategoryID) as 'srednia danej kategorii',
       (p.UnitPrice - (select (avg(p.UnitPrice))
                       from Products as p
                       where p.CategoryID = c.CategoryID))                               as 'roznica miedzy cena i srednia',
       (select sum(od.UnitPrice * od.Quantity * (1 - od.Discount))
        from [Order Details] as od
               join Orders as o on o.OrderID = od.OrderID
        where p.ProductID = od.ProductID
          and year(o.OrderDate) = 1997
          and month(o.OrderDate) = 3
       )                                                                                    'wartosc sprzedazy w marcu 97'
from Products as p
       join Categories as c on c.CategoryID = p.CategoryID
group by p.ProductName, c.CategoryName, p.UnitPrice, c.CategoryID, p.ProductID
order by c.CategoryName

-- 2
-- Dla ka¿dego pracownika (imie i nazwisko) podaj ³¹czn¹ wartoæ zamówieñ obs³u¿onych
-- przez tego pracownika (z cen¹ za przesy³kê). Uwzglêdnij tylko pracowników, którzy maj¹ podw³adnych.
select e.FirstName,
       e.LastName,
       e.EmployeeID,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
                 + sum(o.Freight)
        from [Order Details] as od
               join Orders as o on o.OrderID = od.OrderID
        where e.EmployeeID = o.EmployeeID
       ) as 'wartosc obsluzonych zamowien'
from Employees as e
       join Employees as e2 on e2.ReportsTo = e.EmployeeID
group by e.FirstName, e.LastName, e.EmployeeID

--3
-- Czy s¹ jacy klienci, którzy nie z³o¿yli ¿adnego zamówienia w 1997, jeli tak poka¿
--ich nazwy i dane adresowe (3 wersje - join, in, exists).
-- JOIN
select c.CompanyName, c.Address, c.City
from Customers as c
       left join Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
where year(o.OrderDate) is null
group by c.CompanyName, c.Address, c.City

-- IN
select c.CompanyName, c.Address, c.City
from Customers as c
where c.CustomerID not in (select c2.CustomerID
                           from Customers as c2
                                  join Orders as o on c2.CustomerID = o.CustomerID and year(o.OrderDate) = 1997)
group by c.CompanyName, c.Address, c.City

--EXISTS
select c.CompanyName, c.Address, c.City
from Customers as c
where not exists(select CustomerID from Orders as o where o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997)
group by c.CompanyName, c.Address, c.City

--4
-- Podaj listê cz³onków biblioteki (imiê, nazwisko) mieszkaj¹cych w Arizonie (AZ), którzy maj¹
-- wiêcej ni¿ dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkaj¹ w Kalifornii (CA)
-- i maj¹ wiêcej ni¿ troje dzieci zapisanych do bibliotek. Dla ka¿dej z tych osób podaj liczbê ksi¹¿ek
-- przeczytanych (oddanych) przez dan¹ osobê i jej dzieci w grudniu 2001 (u¿yj operatora union).
use library
select m.firstname,
       m.lastname,
       (select count(*)
        from juvenile as j
        where j.adult_member_no = a.member_no) as 'liczba dzieci zapisanych do biblioteki',
       (select count(*)
        from loanhist as lh
        where (lh.member_no = m.member_no or
               lh.member_no in (select j.member_no from juvenile as j where j.adult_member_no = a.member_no))
          and year(lh.in_date) = 2001
          and month(lh.in_date) = 12
       ),
       a.state
from member as m
       join adult as a on a.member_no = m.member_no and a.state = 'AZ'
where (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 2
union
select m.firstname,
       m.lastname,
       (select count(*)
        from juvenile as j
        where j.adult_member_no = a.member_no) as 'liczba dzieci zapisanych do biblioteki',
       (select count(*)
        from loanhist as lh
        where (lh.member_no = m.member_no or
               lh.member_no in (select j.member_no from juvenile as j where j.adult_member_no = a.member_no))
          and year(lh.in_date) = 2001
          and month(lh.in_date) = 12
       ),
       a.state
from member as m
       join adult as a on a.member_no = m.member_no and a.state = 'CA'
where (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 3


-- GRUPA B

-- 1
-- Napisz polecenie, które wywietla listê dzieci bêd¹cych cz³onkami biblioteki. Interesuje nas imiê, nazwisko,
-- data urodzenia dziecka, adres zamieszkania, imiê i nazwisko rodzica oraz liczba aktualnie wypo¿yczonych ksi¹¿ek.
use library
select ch.firstname  as 'child firstname',
       ch.lastname   as 'child lastname',
       j.birth_date  as 'child birth date',
       par.firstname as 'parent firstname',
       par.lastname  as 'parent lastname',
       a.state,
       a.city,
       a.street,
       (select count(l.isbn) from loan as l where l.member_no = m.member_no)
from member as m
       join juvenile as j on j.member_no = m.member_no
       join adult as a on a.member_no = j.adult_member_no
       join member as ch on ch.member_no = j.member_no
       join member as par on par.member_no = a.member_no
group by ch.firstname, ch.lastname, j.birth_date, par.firstname, par.lastname, a.state, a.city, a.street, m.member_no

--2)
-- Dla ka¿dego pracownika (imie i nazwisko) podaj ³¹czn¹ wartoæ zamówieñ obs³u¿onych
-- przez tego pracownika (z cen¹ za przesy³kê). * Uwzglêdnij tylko pracowników, którzy nie maj¹ podw³adnych.
use Northwind
select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
                 + sum(o.Freight)
        from [Order Details] as od
               join Orders as o on o.OrderID = od.OrderID
        where o.EmployeeID = e.EmployeeID
       ) as 'wartosc zamowien'
from Employees as e
       join Employees as e2 on e2.ReportsTo = e.EmployeeID
group by e.FirstName, e.LastName, e.EmployeeID


--3)
-- Czy s¹ jacy klienci, którzy nie z³o¿yli ¿adnego zamówienia w 1997, jeli tak poka¿
-- ich nazwy i dane adresowe (3 wersje - join, in, exists).
-- JOIN
select c.CompanyName, c.Address, c.City
from Customers as c
       left join Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
where year(o.OrderDate) is null
group by c.CompanyName, c.Address, c.City

-- IN
select c.CompanyName, c.Address, c.City
from Customers as c
where c.CustomerID not in (select c2.CustomerID
                           from Customers as c2
                                  join Orders as o on c2.CustomerID = o.CustomerID and year(o.OrderDate) = 1997)
group by c.CompanyName, c.Address, c.City

--EXISTS
select c.CompanyName, c.Address, c.City
from Customers as c
where not exists(select CustomerID from Orders as o where o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997)
group by c.CompanyName, c.Address, c.City

--4)
-- Podaj listê cz³ownków biblioteki (imiê, nazwisko) mieszkaj¹cych w Arizonie (AZ), którzy maj¹
-- wiêcej ni¿ dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkaj¹ w Kalifornii (CA)
-- i maj¹ wiêcej ni¿ troje dzieci zapisanych do bibliotek. Dla ka¿dej z tych osób podaj liczbê ksi¹¿ek
-- przeczytanych (oddanych) przez dan¹ osobê i jej dzieci w grudniu 2001 (bez u¿ycia union).
use library
select m.firstname,
       m.lastname,
       m.member_no,
       (select count(*)
        from loanhist as lh
        where lh.member_no = a.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12)                         as 'liczba przeczytanych przez opiekuna',
       (select count(*)
        from loanhist as lh
        where lh.member_no in (select j.member_no
                               from juvenile as j
                               where j.adult_member_no = a.member_no
                                 and year(lh.out_date) = 2001
                                 and month(lh.out_date) = 12)) as 'liczba przeczytanych przez dziecko',
       (select count(*)
        from loanhist as lh
        where lh.member_no = a.member_no
          and year(lh.out_date) = 2001
          and month(lh.out_date) = 12) +
       (select count(*)
        from loanhist as lh
        where lh.member_no in (select j.member_no
                               from juvenile as j
                               where j.adult_member_no = a.member_no
                                 and year(lh.out_date) = 2001
                                 and month(lh.out_date) = 12)) as 'liczba przeczytanych przez opiekuna i dziecko'
from member as m
       join adult as a on a.member_no = m.member_no
where (a.state = 'AZ' and (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 2)
   or (a.state = 'CA' and (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 3)
group by m.member_no, m.firstname, m.lastname, a.member_no