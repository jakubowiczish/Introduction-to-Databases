-- 1) Dla ka¿dego pracownika, który ma podwladnego
-- podaj wartosc obsluzonych przez niego przesylek w grudniu 1997.
-- Uwzglednij rabat i oplatê za przesylke.
use Northwind
select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount))
        from Orders as o
               join [Order Details] as od on od.OrderID = o.OrderID
        where year(o.OrderDate) = 1997
          and month(o.OrderDate) = 12
          and o.EmployeeID = e.EmployeeID
       ) + (select sum(o.Freight)
            from Orders as o
                   join [Order Details] as od on od.OrderID = o.OrderID
            where year(o.OrderDate) = 1997
              and month(o.OrderDate) = 12
              and o.EmployeeID = e.EmployeeID
       )
from Employees as e
where exists(select e2.EmployeeID from Employees as e2 where e2.ReportsTo = e.EmployeeID)


-- -- 2) Podaj listê wszystkich doros³ych, którzy mieszkaj¹ w Arizonie i maj¹ dwójkê dzieci zapisanych do biblioteki
-- oraz
-- listê doros³ych, mieszkaj¹cych w Kalifornii i maj¹ 3 dzieci.
-- Dla ka¿dej z tych osób podaj liczbê ksi¹¿ek przeczytanych w grudniu 2001 przez tê osobê i jej dzieci.
-- (Arizona - 'AZ', Kalifornia - 'CA'
use library
select a.member_no,
       count(j.adult_member_no),
       (select count(*)
        from loanhist
        where loanhist.member_no = a.member_no
          and year(in_date) = 2001
          and month(in_date) = 12) +
       (select count(*)
        from loanhist
        where
            loanhist.member_no in (select juvenile.member_no from juvenile where juvenile.adult_member_no = a.member_no)
          and year(in_date) = 2001
          and month(in_date) = 12)
from adult as a
       join juvenile as j on j.adult_member_no = a.member_no
where a.state = 'AZ'
group by a.member_no
having count(j.adult_member_no) = 2
union
select a.member_no,
       count(j.adult_member_no),
       (select count(*)
        from loanhist
        where loanhist.member_no = a.member_no
          and year(in_date) = 2001
          and month(in_date) = 12) +
       (select count(*)
        from loanhist
        where
            loanhist.member_no in (select juvenile.member_no from juvenile where juvenile.adult_member_no = a.member_no)
          and year(in_date) = 2001
          and month(in_date) = 12)
from adult as a
       join juvenile as j on j.adult_member_no = a.member_no
where a.state = 'CA'
group by a.member_no
having count(j.adult_member_no) = 3


--3) Podaj klientów, którzy nie z³o¿yli zamówieñ w 1997. 3 wersje: join, in, exists.
-- JOIN
use Northwind
select *
from Customers as c
       left outer join Orders as o on o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997
where o.OrderDate is null
-- IN
select *
from Customers as c
where c.CustomerID not in
      (select o.CustomerID from Orders as o where o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997)
-- EXISTS
select *
from Customers as c
where not exists(
    select CustomerID from Orders as o where o.CustomerID = c.CustomerID and year(o.OrderDate) = 1997
  )

-- 4) Podaj nazwy produktów, które nie by³y sprzedawane w marcu 1997.
select ProductName
from Products as p
     except
select ProductName
from Products as p
       left outer join [Order Details] as od on od.ProductID = p.ProductID
       left outer join Orders as o on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997
  and month(o.OrderDate) = 3

select ProductName
from Products as p
where p.ProductID not in (select ProductID
                          from [Order Details] as od
                                 join Orders as o on o.OrderID = od.OrderID
                          where year(o.OrderDate) = 1997
                            and month(o.OrderDate) = 3
)






























