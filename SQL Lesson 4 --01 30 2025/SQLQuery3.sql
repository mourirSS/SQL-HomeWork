CREATE DATABASE Academy1

USE Academy1

CREATE TABLE Curators 
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Name] nvarchar(max) NOT NULL CHECK (LEN([Name]) > 0),
    [Surname] nvarchar(max) NOT NULL CHECK (LEN([Surname]) > 0)
);

CREATE TABLE Faculties
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Financing] money NOT NULL CHECK ([Financing] >= 0) default 0,
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);

CREATE TABLE Departments
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Financing] money NOT NULL CHECK ([Financing] >= 0) default 0,
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0),
    [FacultyId] int NOT NULL,
    foreign key ([FacultyId]) references Faculties([Id])
);

CREATE TABLE Groups
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Name] nvarchar(10) NOT NULL UNIQUE CHECK (LEN([Name]) > 0),
    [Year] int NOT NULL CHECK ([Year] BETWEEN 1 AND 5),
    [DepartmentId] int NOT NULL,
    foreign key ([DepartmentId]) references Departments([Id])
);

CREATE TABLE GroupsCurators
(
    [Id] int identity(1,1) PRIMARY KEY,
    [CuratorId] int NOT NULL,
    [GroupId] int NOT NULL,
    foreign key ([CuratorId]) references Curators([Id]),
    foreign key ([GroupId]) references Groups([Id])
);

CREATE TABLE Subjects
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);

CREATE TABLE Teachers
(
    [Id] int identity(1,1) PRIMARY KEY,
    [Name] nvarchar(max) NOT NULL CHECK (LEN([Name]) > 0),
    [Surname] nvarchar(max) NOT NULL CHECK (LEN([Surname]) > 0),
    [Salary] money NOT NULL CHECK ([Salary] > 0)
);

CREATE TABLE Lectures 
(
    [Id] int identity(1,1) PRIMARY KEY,
    [LectureRoom] nvarchar(max) NOT NULL CHECK (LEN([LectureRoom]) > 0),
    [SubjectId] int NOT NULL,
    [TeacherId] int NOT NULL,
    foreign key ([SubjectId]) references Subjects([Id]),
    foreign key ([TeacherId]) references Teachers([Id])
);

CREATE TABLE GroupsLectures 
(
    [Id] int identity(1,1) PRIMARY KEY,
    [GroupId] int NOT NULL,
    [LectureId] int NOT NULL,
    foreign key ([GroupId]) references Groups([Id]),
    foreign key ([LectureId]) references Lectures([Id])
);


INSERT INTO Faculties (Name, Financing) 
VALUES 
('Computer Science', 100000), 
('Mathematics', 80000), 
('Physics', 90000);

INSERT INTO Departments (Name, Financing, FacultyId) 
VALUES 
('Software Engineering', 120000, 1), 
('Applied Math', 70000, 2), 
('Quantum Mechanics', 95000, 3);

INSERT INTO Groups (Name, Year, DepartmentId) 
VALUES 
('P107', 2, 1),
('M204', 3, 2), 
('Q301', 5, 3),
('P208', 4, 1);

INSERT INTO Curators (Name, Surname)
VALUES
('John', 'Doe'), 
('Alice', 'Smith'), 
('Michael', 'Johnson');

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES 
(1, 1), 
(2, 2), 
(3, 3);

INSERT INTO Subjects (Name)
VALUES
('Database Theory'), 
('Calculus'),
('Quantum Physics');

INSERT INTO Teachers (Name, Surname, Salary) 
VALUES
('Samantha', 'Adams', 5000), 
('Robert', 'Brown', 5500),
('Emily', 'Clark', 6000);

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) 
VALUES 
('B103', 1, 1), 
('C202', 2, 2), 
('B103', 3, 3);

INSERT INTO GroupsLectures (GroupId, LectureId) 
VALUES
(1, 1), 
(2, 2),
(3, 3), 
(1, 3);


--?????? 1
SELECT * FROM Teachers 
INNER JOIN Lectures L ON Teachers.Id = L.TeacherId;

--?????? 2
SELECT F.Name, F.Financing FROM Faculties F
INNER JOIN Departments D ON f.Id = D.FacultyId
GROUP BY F.Id, F.Name, F.Financing
HAVING SUM(D.Financing) > F.Financing;

--?????? 3
SELECT C.Surname, G.Name FROM Curators C
INNER JOIN GroupsCurators GC ON C.Id = GC.CuratorId
INNER JOIN Groups G ON GC.GroupId = G.Id;

--?????? 4
SELECT T.Name, T.Surname FROM Teachers T
INNER JOIN Lectures L ON T.Id = L.TeacherId
INNER JOIN GroupsLectures GL ON L.Id = GL.LectureId
INNER JOIN Groups G ON GL.GroupId = G.Id
WHERE G.Name = 'P107';

--?????? 5
SELECT T.Surname, F.Name FROM Teachers T
INNER JOIN Lectures L ON T.Id = L.TeacherId
INNER JOIN GroupsLectures GL ON L.Id = GL.LectureId
INNER JOIN Groups G ON GL.GroupId = G.Id
INNER JOIN Departments D ON G.DepartmentId = D.Id
INNER JOIN Faculties F ON D.FacultyId = F.Id;

--?????? 6
SELECT D.Name, G.Name FROM Departments D
INNER JOIN Groups G ON D.Id = G.DepartmentId;

--?????? 7
SELECT S.Name FROM Subjects S
INNER JOIN Lectures L ON S.Id = L.SubjectId
INNER JOIN Teachers T ON L.TeacherId = T.Id
WHERE T.Name = 'Samantha' AND T.Surname = 'Adams';

--?????? 8
SELECT D.Name FROM Departments D
INNER JOIN Groups G ON D.Id = G.DepartmentId
INNER JOIN GroupsLectures GL ON G.Id = GL.GroupId
INNER JOIN Lectures L ON GL.LectureId = L.Id
INNER JOIN Subjects S ON L.SubjectId = S.Id
WHERE S.Name = 'Database Theory';

--?????? 9
SELECT G.Name FROM Groups G
INNER JOIN Departments D ON G.DepartmentId = D.Id
INNER JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'Computer Science';

--?????? 10
SELECT G.Name, F.Name FROM Groups G
INNER JOIN Departments D ON G.DepartmentId = D.Id
INNER JOIN Faculties F ON D.FacultyId = F.Id
WHERE G.Year = 5;

--?????? 11
SELECT T.Name + ' ' + T.Surname AS FullName, S.Name AS SubjectName, G.Name AS GroupName
FROM Teachers T
INNER JOIN Lectures L ON T.Id = L.TeacherId
INNER JOIN Subjects S ON L.SubjectId = S.Id
INNER JOIN GroupsLectures GL ON L.Id = GL.LectureId
INNER JOIN Groups G ON GL.GroupId = G.Id
WHERE L.LectureRoom = 'B103';











