select c.CategoryName,
       p.ProductName,
       p.UnitPrice,
       (select avg(p2.UnitPrice) from Products as p2 where p2.CategoryID = c.CategoryID),
       (p.UnitPrice - (select avg(p2.UnitPrice) from Products as p2 where p2.CategoryID = c.CategoryID)),
       (select sum(od.UnitPrice * od.Quantity * (1 - od.Discount))
        from [Order Details] as od
               join Products as p on p.ProductID = od.ProductID
               join Orders as o on o.OrderID = od.OrderID
        where year(o.OrderDate) = 1997
          and month(o.OrderDate) = 3
       )
from Categories as c
       join Products as p on p.CategoryID = c.CategoryID
group by c.CategoryName, p.ProductName, p.UnitPrice, c.CategoryID


select e.FirstName,
       e.LastName,
       (select sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight)
        from [Order Details] as od
               join Orders as o on o.OrderID = od.OrderID
        where o.EmployeeID = e.EmployeeID)
from Employees as e
       join Employees as e2 on e2.ReportsTo = e.EmployeeID
group by e.FirstName, e.LastName, e.EmployeeID



  select c.ContactName,(select count(*) from Orders as o where o.CustomerID = c.CustomerID)
from Customers as c
       left outer join Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
where year(o.OrderDate) is null

select c.ContactName, (select count(*) from Orders as o where o.CustomerID = c.CustomerID)
  from Customers as c
  where c.CustomerID not in (select o.CustomerID from Orders as o where year(o.OrderDate) = 1997)


select m.firstname,
       m.lastname,
       (select count(*) from loanhist as lh where lh.member_no = a.member_no and year(lh.in_date) = 2001) +
       (select count(*)
        from loanhist as lh
        where lh.member_no in (select j.member_no
                               from juvenile as j
                               where j.adult_member_no = a.member_no and year(lh.in_date) = 2001)) as 'liczba ksiazek przeczytana przez osobe i dzieci'
from member as m
       join adult as a on a.member_no = m.member_no
where (a.state = 'AZ' and (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 2)
or (a.state = 'CA' and (select count(*) from juvenile as j where j.adult_member_no = a.member_no) > 3)



