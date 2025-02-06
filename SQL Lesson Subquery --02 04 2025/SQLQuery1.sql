CREATE DATABASE Academy

USE Academy

CREATE TABLE Curators 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

CREATE TABLE Faculties 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Departments 
(
    Id INT IDENTITY PRIMARY KEY,
    Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Groups 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE GroupsCurators 
(
    Id INT IDENTITY PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

CREATE TABLE Students 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0),
    Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5)
);

CREATE TABLE GroupsStudents 
(
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    StudentId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);



CREATE TABLE Subjects 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Teachers 
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0),
    IsProfessor BIT NOT NULL DEFAULT 0,
    Salary MONEY NOT NULL CHECK (Salary > 0)
);

CREATE TABLE Lectures (
    Id INT IDENTITY PRIMARY KEY,
    Date DATE NOT NULL CHECK (Date <= GETDATE()),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures (
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);


-- Добавление данных в таблицу Faculties
INSERT INTO Faculties (Name) VALUES 
('Computer Science'),
('Software Engineering'),
('Data Science'),
('Cybersecurity');

-- Добавление данных в таблицу Departments
INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES 
(1, 120000, 'Software Development', 1),
(2, 80000, 'Artificial Intelligence', 1),
(3, 50000, 'Network Security', 4),
(4, 200000, 'Data Engineering', 3);

-- Добавление данных в таблицу Curators
INSERT INTO Curators (Name, Surname) VALUES 
('John', 'Doe'),
('Alice', 'Smith'),
('Robert', 'Brown'),
('Emma', 'Johnson');

-- Добавление данных в таблицу Groups
INSERT INTO Groups (Name, Year, DepartmentId) VALUES 
('D221', 5, 1),
('D222', 5, 1),
('AI101', 3, 2),
('NS303', 4, 3);

-- Добавление данных в таблицу GroupsCurators
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 3);

-- Добавление данных в таблицу Students
INSERT INTO Students (Name, Surname, Rating) VALUES 
('Mike', 'Wilson', 4),
('Sophia', 'Davis', 3),
('Daniel', 'White', 5),
('Olivia', 'Miller', 2);

-- Добавление данных в таблицу GroupsStudents
INSERT INTO GroupsStudents (GroupId, StudentId) VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 4);

-- Добавление данных в таблицу Teachers
INSERT INTO Teachers (IsProfessor, Name, Surname, Salary) VALUES 
(1, 'Dr. Alan', 'Turing', 90000),
(1, 'Dr. Ada', 'Lovelace', 95000),
(0, 'Grace', 'Hopper', 60000),
(0, 'Linus', 'Torvalds', 70000);

-- Добавление данных в таблицу Subjects
INSERT INTO Subjects (Name) VALUES 
('Algorithms'),
('Machine Learning'),
('Cybersecurity'),
('Software Engineering');

-- Добавление данных в таблицу Lectures
INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES 
('2024-02-01', 1, 1),
('2024-02-02', 2, 2),
('2024-02-03', 3, 3),
('2024-02-04', 4, 4);

-- Добавление данных в таблицу GroupsLectures
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4);


--Задача 1
SELECT Building FROM Departments 
GROUP BY Building 
HAVING SUM(Financing) > 100000;

--Задача 2
--не смог

--Задача 3
--не смог

--Задача 4
SELECT Name, Surname FROM Teachers 
WHERE Salary > (
    SELECT AVG(Salary) 
    FROM Teachers 
    WHERE IsProfessor = 1
);

--Задача 5
SELECT Groups.Name FROM Groups 
JOIN GroupsCurators ON Groups.Id = GroupsCurators.GroupId
GROUP BY Groups.Id, Groups.Name
HAVING COUNT(GroupsCurators.CuratorId) > 1;

--Задача 6 
--не смог

--Задача 7
SELECT Faculties.Name FROM Faculties
JOIN Departments ON Faculties.Id = Departments.FacultyId
GROUP BY Faculties.Id, Faculties.Name
HAVING SUM(Departments.Financing) > (
    SELECT SUM(Departments.Financing)
    FROM Departments 
    JOIN Faculties ON Departments.FacultyId = Faculties.Id
    WHERE Faculties.Name = 'Computer Science'
);

--Задача 8
SELECT Subjects.Name, Teachers.Name + ' ' + Teachers.Surname FROM Subjects
JOIN Lectures ON Subjects.Id = Lectures.SubjectId
JOIN Teachers ON Lectures.TeacherId = Teachers.Id;

--Задача 9
SELECT TOP 1 Subjects.Name AS Subject FROM Subjects 
JOIN Lectures ON Subjects.Id = Lectures.SubjectId
GROUP BY Subjects.Id, Subjects.Name
ORDER BY COUNT(Lectures.Id) ASC;

--Задача 10
SELECT 
    COUNT(GroupsStudents.StudentId), 
    COUNT(Lectures.SubjectId) 
FROM Departments
JOIN Groups ON Departments.Id = Groups.DepartmentId
JOIN GroupsStudents ON Groups.Id = GroupsStudents.GroupId
JOIN GroupsLectures ON Groups.Id = GroupsLectures.GroupId
JOIN Lectures ON GroupsLectures.LectureId = Lectures.Id
WHERE 
    Departments.Name = 'Software Development';



