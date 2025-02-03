CREATE DATABASE Academy

USE Academy

CREATE TABLE Departments
(
    [Id] int identity(1,1) PRIMARY KEY NOT NULL,
    [Financing] money NOT NULL DEFAULT 0 CHECK([Financing] > 0),
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Faculties
(
    [Id] int identity(1,1) PRIMARY KEY NOT NULL,
    [Dean] nvarchar(max) NOT NULL CHECK (LEN(Dean) > 0),
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Groups
(
    [Id] int identity(1,1) PRIMARY KEY NOT NULL,
    [Name] nvarchar(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    [Rating] int not null check([Rating] BETWEEN 1 AND 5),
    [Year] int not null check([Year] BETWEEN 1 AND 5)
);

CREATE TABLE Teachers
(
    [Id] int identity(1,1) PRIMARY KEY NOT NULL,
    [EmploymentDate] date NOT NULL,
    [IsAssistant] bit NOT NULL DEFAULT 0,
    [IsProfessor] bit NOT NULL DEFAULT 0,
    [Name] nvarchar(max) NOT NULL CHECK (LEN(Name) > 0),
    [Position] nvarchar(max) NOT NULL CHECK (LEN(Position) > 0),
    [Premium] money not null check([Premium] > 0) default 0,
    [Salary] money not null check([Salary] >= 0),
    [Surname] nvarchar(max) not null CHECK (LEN(Surname) > 0)
);


INSERT INTO Teachers(EmploymentDate, IsAssistant, IsProfessor, Name, Position, Premium, Salary, Surname)
VALUES('2000-01-01', 0, 1, N'Yan', N'ChillGuy', 10000, 20000, N'Bitner')
INSERT INTO Teachers (EmploymentDate, IsAssistant, IsProfessor, Name, Position, Premium, Salary, Surname) VALUES
('1998-05-15', 0, 1, N'Alexander', N'Professor of Computer Science', 15000, 30000, N'Petrov'),
('2005-09-01', 1, 0, N'Elena', N'Assistant in Mathematics', 5000, 15000, N'Ivanova'),
('2010-07-20', 0, 1, N'Victor', N'Physics Lecturer', 12000, 25000, N'Smirnov'),
('2015-03-11', 1, 0, N'Anna', N'Literature Instructor', 7000, 18000, N'Kuznetsova'),
('2020-06-30', 0, 0, N'Dmitry', N'History Researcher', 4000, 12000, N'Sokolov');

UPDATE Teachers  
SET [Salary] = 1000  
WHERE [Salary] = 30000;

UPDATE Teachers  
SET [Salary] = 1500  
WHERE [Salary] = 15000;


INSERT INTO Faculties (Dean, Name) VALUES
(N'John Smith', N'Faculty of Engineering'),
(N'Lisa Brown', N'Faculty of Arts'),
(N'Michael Johnson', N'Faculty of Science'),
(N'Emily Davis', N'Faculty of Business'),
(N'Robert Wilson', N'Faculty of Medicine');

UPDATE Faculties  
SET [Name] = N'Computer Science'  
WHERE [Name] = N'Faculty of Engineering';

INSERT INTO Departments (Financing, Name) VALUES
(500000, N'Computer Science'),
(300000, N'Mathematics'),
(400000, N'Physics'),
(200000, N'Literature'),
(350000, N'History');

UPDATE Departments  
SET [Financing] = 9000  
WHERE [Financing] = 300000;

INSERT INTO Groups (Name, Rating, Year) VALUES
(N'CS101', 5, 1),
(N'MTH202', 4, 2),
(N'PHY303', 3, 3),
(N'LIT404', 2, 4),
(N'HIS505', 1, 5);


SELECT * FROM Teachers
SELECT * FROM Groups
SELECT * FROM Departments
SELECT * FROM Faculties


--Задача 1
SELECT [Name], [Financing], [Id] 
FROM Departments;

--Задача 2
SELECT [Name] AS "Group Name", [Rating] AS "Group Rating" 
FROM Groups;

--Задача 3
SELECT  
    [Surname],  
    ([Premium] * 100 / ([Salary] + [Premium])) AS "Premium Percentage",  
    ([Salary] * 100 / ([Salary] + [Premium])) AS "Salary Percentage"  
FROM Teachers;

--Задача 4
SELECT 'The dean of faculty ' + [Name] + ' is ' + [Dean] + '.' AS "Faculty Info"  
FROM Faculties;

--Задача 5
SELECT [Surname], [Salary] FROM Teachers  
WHERE [IsProfessor] = 1 AND [Salary] > 1050;

--Задача 6
SELECT [Name], [Financing] FROM Departments
WHERE [Financing] > 11000 

--Задача 7
SELECT [Name] FROM Faculties  
WHERE [Name] <> N'Computer Science';

--Задача 8
SELECT [Surname], [Position] FROM Teachers  
WHERE [IsProfessor] = 0;

--Задача 9
SELECT [Surname], [Position], [Salary], [Premium] FROM Teachers
WHERE [IsAssistant] = 1 AND [Premium] BETWEEN 160 AND 550;

--Задача 10
SELECT [Name], ([Premium] * 100 / ([Salary] + [Premium])) AS "Premium Percentage" FROM Teachers
WHERE [IsAssistant] = 1;

--Задача 11
SELECT [Surname], [Position] FROM Teachers
WHERE [EmploymentDate]  < '2000-01-01'

--Задача 13
SELECT [Surname] FROM Teachers  
WHERE [IsAssistant] = 1 AND [Salary] + [Premium] < 1200;

--Задача 14
SELECT [Name] FROM Groups  
WHERE [Year] = 5 AND [Rating] BETWEEN 2 AND 4;

--Задача 15
SELECT [Surname] FROM Teachers  
WHERE [IsAssistant] = 1 AND [Salary] < 550 AND [Premium] < 200;
