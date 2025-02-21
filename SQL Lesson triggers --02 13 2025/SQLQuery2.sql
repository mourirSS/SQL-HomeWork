CREATE DATABASE CarDealership;
GO
USE CarDealership;
GO

-- Таблица клиентов
CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20) NOT NULL
);

-- Таблица автомобилей
CREATE TABLE Cars (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Brand NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Year INT CHECK (Year >= 2000),
    Price DECIMAL(10,2) CHECK (Price > 0)
);

-- Таблица заказов
CREATE TABLE Orders (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT FOREIGN KEY REFERENCES Customers(Id) ON DELETE CASCADE,
    CarId INT FOREIGN KEY REFERENCES Cars(Id) ON DELETE CASCADE,
    OrderDate DATETIME DEFAULT GETDATE()
);

-- Таблица истории цен автомобилей
CREATE TABLE CarPriceHistory (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CarId INT FOREIGN KEY REFERENCES Cars(Id) ON DELETE CASCADE,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- Таблица логов удалённых заказов
CREATE TABLE DeletedOrdersLog (
    Id INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT,
    CustomerId INT,
    CarId INT,
    OrderDate DATETIME,
    DeletedAt DATETIME DEFAULT GETDATE()
);

INSERT INTO Customers (Name, Email, Phone) VALUES
('Иван Петров', 'ivan.petrov@email.com', '123-456-789'),
('Мария Сидорова', 'maria.sidorova@email.com', '987-654-321'),
('Алексей Смирнов', 'alex.smirnov@email.com', '555-666-777');

INSERT INTO Cars (Brand, Model, Year, Price) VALUES
('Toyota', 'Camry', 2022, 30000),
('BMW', 'X5', 2023, 60000),
('Mercedes', 'C-Class', 2021, 50000);

INSERT INTO Orders (CustomerId, CarId) VALUES
(1, 1),
(2, 2),
(3, 3);


-- задание 1
CREATE TRIGGER trg_CarPriceChange
ON Cars
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO CarPriceHistory (CarId, OldPrice, NewPrice, ChangeDate)
        SELECT d.Id, d.Price, i.Price, GETDATE()
        FROM deleted d
        JOIN inserted i ON d.Id = i.Id;
    END
END;
GO

-- задание 2
CREATE TRIGGER trg_PreventCustomerDeletion
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Orders WHERE CustomerId IN (SELECT Id FROM deleted))
    BEGIN
        RAISERROR ('Невозможно удалить клиента с активными заказами', 16, 1);
        RETURN;
    END
    DELETE FROM Customers WHERE Id IN (SELECT Id FROM deleted);
END;
GO

-- задание 3 
CREATE TRIGGER trg_LogDeletedOrders
ON Orders
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedOrdersLog (OrderId, CustomerId, CarId, OrderDate, DeletedAt)
    SELECT Id, CustomerId, CarId, OrderDate, GETDATE() FROM deleted;
END;
GO

-- задание 4
CREATE TRIGGER trg_UpdatePriceOnYearChange
ON Cars
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Year)
    BEGIN
        UPDATE Cars
        SET Price = c.Price * 0.95
        FROM Cars c
        JOIN inserted i ON c.Id = i.Id;
    END
END;
GO

-- задание 5
CREATE TRIGGER trg_PreventDuplicateOrders
ON Orders
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Orders
        WHERE CustomerId IN (SELECT CustomerId FROM inserted)
        AND CarId IN (SELECT CarId FROM inserted)
        GROUP BY CustomerId, CarId
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR ('Клиент не может заказать один и тот же автомобиль дважды', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- тест 1
UPDATE Cars SET Price = 32000 WHERE Id = 1;
SELECT * FROM CarPriceHistory; 

-- тест 2
DELETE FROM Customers WHERE Id = 1;

-- тест 3
DELETE FROM Orders WHERE Id = 1;
SELECT * FROM DeletedOrdersLog; 

-- тест 4
UPDATE Cars SET Year = 2025 WHERE Id = 2;
SELECT * FROM Cars WHERE Id = 2; 

-- тест 5
INSERT INTO Orders (CustomerId, CarId) VALUES (2, 2); -- Должно вызвать ошибку
