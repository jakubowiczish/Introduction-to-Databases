-- Podaj liczbę produktów o cenach mniejszych niż 10$ lub
-- większych niż 20$

select ProductName, UnitPrice
from Products
where UnitPrice < 10
   or UnitPrice > 20
order by UnitPrice

-- Podaj maksymalną cenę produktu dla produktów o cenach
-- poniżej 20$

select max(UnitPrice)
from Products
where UnitPrice < 20

-- Podaj maksymalną i minimalną i średnią cenę produktu dla
-- produktów o produktach sprzedawanych w butelkach
-- (‘bottle’)
select max(UnitPrice) as max, min(UnitPrice) as min, avg(UnitPrice) as average
from Products
where QuantityPerUnit like '%bottle%'

-- Wypisz informację o wszystkich produktach o cenie powyżej
-- średniej
select *, (select avg(UnitPrice) from Products as average)
from Products
where UnitPrice > (select avg(UnitPrice) from Products)

select sum(UnitPrice * Quantity * (1 - Discount)) as sum
from [Order Details]
where OrderID = 10250

-- Podaj maksymalną cenę zamawianego produktu dla każdego
-- zamówienia
select max(UnitPrice * Quantity * (1 - Discount)), OrderID
from [Order Details]
group by OrderID

-- Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, max(UnitPrice) as 'max unit price'
from [Order Details]
group by OrderID
order by [max unit price]

-- Podaj maksymalną i minimalną cenę zamawianego produktu dla
-- każdego zamówienia
select OrderID, max(UnitPrice) as 'max unit price', min(UnitPrice) as 'min unit price'
from [Order Details]
group by OrderID

-- Podaj liczbę zamówień dostarczanych przez poszczególnych
-- spedytorów (przewoźników)
select ShipVia, sum(ShipVia)
from Orders
group by ShipVia

-- Który z spedytorów był najaktywniejszy w 1997 roku
select top 1 with ties ShipVia, count(ShipVia) as sum
from Orders
where ShippedDate is not null
  and year(ShippedDate) = 1997
group by ShipVia
order by ShipVia desc

-- Wyświetl zamówienia dla których liczba pozycji zamówienia jest
-- większa niż 5
select OrderID
from [Order Details]
group by OrderID
having count(*) > 5

-- Wyświetl klientów dla których w 1998 roku zrealizowano więcej
-- niż 8 zamówień (wyniki posortuj malejąco wg łącznej kwoty za
-- dostarczenie zamówień dla każdego z klientów)
select CustomerID, count(OrderID)
from Orders
where ShippedDate is not null
  and year(ShippedDate) = 1998
group by CustomerID
having count(OrderID) > 8
order by sum(Freight) desc



