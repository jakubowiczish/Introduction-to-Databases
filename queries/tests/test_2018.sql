-- wszyscy klienci co nie zamawiali w 1997 z kategorii confections
select ContactName
from Customers as c
  except
select ContactName
from Customers as c
       join Orders as o on o.CustomerID = c.CustomerID
       join [Order Details] as od on od.OrderID = o.OrderID
       join Products as p on p.ProductID = od.ProductID
       join Categories as ca on ca.CategoryID = p.CategoryID
where ca.CategoryName = 'Confections' and year(o.OrderDate) = 1997




















