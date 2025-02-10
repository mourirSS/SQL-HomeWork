CREATE DATABASE Store

USE Store

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


--Задание 5
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES 
    (1, 'Andrew', 'Kuznetsov', 'andrew.kuznetsov@example.com'),
    (2, 'Olga', 'Novikova', 'olga.novikova@example.com'),
    (3, 'Dmitry', 'Fedorov', 'dmitry.fedorov@example.com'),
    (4, 'Natalia', 'Volkova', 'natalia.volkova@example.com'),
    (5, 'Ivan', 'Petrov', 'ivan.petrov@example.com');


--Задание 1
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (6, 'Yan', 'Bitner', 'yan.bitner@example.com');

--Задание 2
UPDATE Customers
SET Email = 'new.email@example.com'
WHERE CustomerID = 1;

--Задание 3
DELETE FROM Customers
WHERE CustomerID = 5;

--Задание 4
SELECT * FROM Customers
ORDER BY LastName;



--Добавляем данные в таблицу Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES 
    (2, 2, '2024-01-15', 180.50),  
    (3, 3, '2023-06-20', 250.00),  
    (4, 4, '2023-12-05', 300.00),  
    (5, 1, '2023-08-10', 120.75);  

--Задание 6
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (1, 1, '2024-02-10', 150.00);

--Задание 7
UPDATE Orders
SET TotalAmount = 200.00
WHERE OrderID = 2;

--Задание 8
DELETE FROM Orders
WHERE OrderID = 3;

--Задание 9
SELECT * FROM Orders
WHERE CustomerID = 1;

--Задание 10
SELECT * FROM Orders
WHERE YEAR(OrderDate) = 2023;


--Добавляем данные в таблицу Products
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
    (2, 'Smartphone', 300.00),  
    (3, 'Tablet', 150.00),  
    (4, 'USB Cable', 15.00),  
    (5, 'Headphones', 45.00),  
    (6, 'Mouse', 25.00);  

--Задание 11
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (1, 'Laptop', 1200.00);

--Задание 12
UPDATE Products
SET Price = 250.00
WHERE ProductID = 2;

--Задание 13
DELETE FROM Products
WHERE ProductID = 4;

--Задание 14
SELECT * FROM Products
WHERE Price > 100;

--Задание 15
SELECT * FROM Products
WHERE Price <= 50;


--Добавляем данные в таблицу OrderDetails
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price)
VALUES 
    (2, 2, 2, 1, 300.00),  
    (3, 4, 3, 2, 150.00),  
    (4, 1, 1, 5, 15.00),  
    (5, 5, 5, 3, 45.00);

--Задание 16
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price)
VALUES (1, 1, 1, 2, 1200.00);

--Задание 17
UPDATE OrderDetails
SET Quantity = 3
WHERE OrderDetailID = 1;

--Задание 18
DELETE FROM OrderDetails
WHERE OrderDetailID = 2;

--Задание 19
SELECT * FROM OrderDetails
WHERE OrderID = 1;

--Задание 20
SELECT OrderID FROM OrderDetails
WHERE ProductID = 2;

--Задание 21
SELECT 
    Orders.OrderID, 
    Customers.FirstName + ' ' + Customers.LastName AS FullName, 
    Orders.OrderDate, Orders.TotalAmount FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--Задание 22
SELECT 
    Products.ProductName, 
    Customers.FirstName + ' ' + Customers.LastName AS FullName, 
    OrderDetails.Quantity
FROM OrderDetails
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 23
SELECT 
    Orders.OrderID, 
    Customers.FirstName + ' ' + Customers.LastName AS FullName, 
    Orders.OrderDate, 
    Orders.TotalAmount
FROM Orders
LEFT JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--Задание 24
SELECT 
    Orders.OrderID, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price
FROM OrderDetails
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 25
SELECT 
    Customers.CustomerID, 
    Customers.FirstName + ' ' + Customers.LastName AS FullName, 
    Orders.OrderID, 
    Orders.OrderDate, 
    Orders.TotalAmount
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

--Задание 26
SELECT 
    Products.ProductID, 
    Products.ProductName, 
    OrderDetails.OrderID, 
    OrderDetails.Quantity, 
    OrderDetails.Price
FROM Products
RIGHT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID;

--Задание 27
SELECT 
    Orders.OrderID, 
    Orders.OrderDate, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 28
SELECT 
    Customers.FirstName + ' ' + Customers.LastName AS FullName, 
    Orders.OrderID, 
    Orders.OrderDate, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price, 
    (OrderDetails.Quantity * OrderDetails.Price) AS TotalItemPrice
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;


--Задание 29
SELECT FirstName, LastName 
FROM Customers 
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    WHERE TotalAmount > 500
);

--Задание 30
SELECT * FROM Products 
WHERE ProductID IN (
    SELECT ProductID 
    FROM OrderDetails 
    GROUP BY ProductID 
    HAVING SUM(Quantity) > 10
);

--Задание 31
SELECT CustomerID, FirstName, LastName, 
    (SELECT SUM(TotalAmount) FROM Orders 
     WHERE Orders.CustomerID = Customers.CustomerID) AS TotalSpent
FROM Customers;

--Задание 32
SELECT * FROM Products 
WHERE Price > (
    SELECT AVG(Price) 
    FROM Products
);

--Задание 33
SELECT 
    Orders.OrderID, 
    Orders.OrderDate, 
    Customers.FirstName, 
    Customers.LastName, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 34
SELECT 
    Customers.CustomerID, 
    Customers.FirstName, 
    Customers.LastName, 
    Orders.OrderID, 
    Orders.OrderDate, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 35
SELECT 
    Customers.CustomerID, 
    Customers.FirstName, 
    Customers.LastName, 
    Orders.OrderID, 
    Orders.OrderDate, 
    Products.ProductName, 
    OrderDetails.Quantity, 
    OrderDetails.Price, 
    (OrderDetails.Quantity * OrderDetails.Price) AS TotalItemPrice
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID;

--Задание 36
SELECT 
    Orders.OrderID, 
    Orders.OrderDate, 
    SUM(OrderDetails.Quantity * OrderDetails.Price) AS TotalAmount
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID, Orders.OrderDate
HAVING SUM(OrderDetails.Quantity * OrderDetails.Price) > 1000;

--Задание 37
SELECT Customers.CustomerID, Customers.FirstName, Customers.LastName
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);
