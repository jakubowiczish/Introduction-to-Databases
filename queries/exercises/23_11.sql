use Northwind

select Products.ProductName, Products.UnitPrice, Suppliers.Address
from Products
       left outer join Suppliers on Products.SupplierID = Suppliers.SupplierID
       left outer join Categories on Categories.CategoryID = Products.CategoryID
where Categories.CategoryName = 'Meat/Poultry'
  and Products.UnitPrice between 20.00 and 30.00


select Products.ProductName, Products.UnitPrice, Products.SupplierID
from Products
       left outer join Categories on Products.CategoryID = Categories.CategoryID
       left outer join Suppliers on Products.SupplierID = Suppliers.SupplierID
where CategoryName = 'Confections'


select Customers.ContactName, Customers.Phone
from Customers
       left outer join Orders on Orders.CustomerID = Customers.CustomerID
       left outer join Shippers on Shippers.ShipperID = Orders.ShipVia
where Shippers.CompanyName = 'United Package'
  and year(Orders.OrderDate) = 1997

select Customers.CompanyName, Customers.Phone
from Customers
       left outer join Orders on Orders.CustomerID = Customers.CustomerID
       left outer join [Order Details] on [Order Details].OrderID = Orders.OrderID
       left outer join Products on Products.ProductID = [Order Details].ProductID
       left outer join Categories on Categories.CategoryID = Products.CategoryID
where Categories.CategoryName = 'Confections'










