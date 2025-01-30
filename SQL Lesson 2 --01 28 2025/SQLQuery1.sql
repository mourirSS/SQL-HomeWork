CREATE DATABASE Academy

USE Academy

CREATE Table Groups
(
	[Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[Name] nvarchar(10) NOT NULL UNIQUE CHECK (LEN([Name]) > 0),
	[Rating] INT NOT NULL CHECK ([Rating] BETWEEN 0 AND 5),
	[Year] int NOT NULL CHECK ([Year] BETWEEN 1 AND 5)
);


CREATE Table Departments
(
	[Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[Financing] money NOT NULL DEFAULT 0 CHECK ([Financing] >= 0),
	[Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);


CREATE Table Faculties
(
	[Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);


CREATE Table Teachers
(
	[Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[EmploymentDate] date NOT NULL CHECK ([EmploymentDate] >= '1990-01-01'),
	[Name] nvarchar(max) NOT NULL CHECK (LEN([Name]) > 0),
	[Premium] money NOT NULL DEFAULT 0 CHECK ([Premium] >= 0),
	[Salary] money NOT NULL CHECK ([Salary] > 0),
	[Surname] nvarchar(max) NOT NULL CHECK (LEN([Surname]) > 0)
);