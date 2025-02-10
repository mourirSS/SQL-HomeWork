CREATE DATABASE Academy

USE Academy

-- Создание таблицы групп
CREATE TABLE Groups (
    GroupId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    StudentsCount INT DEFAULT 0
);

-- Создание таблицы студентов
CREATE TABLE Students (
    StudentId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    GroupId INT,
    AvgGrade DECIMAL(4,2) DEFAULT 0,
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId)
);

-- Создание таблицы курсов
CREATE TABLE Courses (
    CourseId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    TeacherId INT
);

-- Создание таблицы регистрации студентов на курсы
CREATE TABLE StudentCourses (
    StudentId INT,
    CourseId INT,
    PRIMARY KEY (StudentId, CourseId),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

-- Создание таблицы оценок
CREATE TABLE Grade (
    GradeId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    CourseId INT,
    Value INT,
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

-- Создание таблицы предупреждений
CREATE TABLE Warnings (
    WarningId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    Reason NVARCHAR(255),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);

-- Создание таблицы преподавателей
CREATE TABLE Teachers (
    TeacherId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL
);

-- Создание таблицы платежей
CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    Amount DECIMAL(10,2),
    Paid BIT DEFAULT 0,
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);

-- Создание таблицы истории оценок
CREATE TABLE GradeHistory (
    HistoryId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    CourseId INT,
    OldValue INT,
    NewValue INT,
    ChangeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

-- Создание таблицы посещаемости
CREATE TABLE Attendance (
    AttendanceId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    CourseId INT,
    Date DATE,
    Attended BIT,
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

-- Создание таблицы пересдачи
CREATE TABLE RetakeList (
    RetakeId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    Reason NVARCHAR(255),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);

-- Вставка данных в группы
INSERT INTO Groups (Name, StudentsCount) VALUES ('Группа A', 5), ('Группа B', 3);

-- Вставка данных в студентов
INSERT INTO Students (Name, GroupId) VALUES ('Иван Иванов', 1), ('Петр Петров', 1), ('Сергей Сергеев', 2);

-- Вставка данных в курсы
INSERT INTO Courses (Name, TeacherId) VALUES ('Введение в программирование', 1);

-- Вставка данных в преподавателей
INSERT INTO Teachers (Name) VALUES ('Алексей Алексеев');

-- Вставка данных в оценки
INSERT INTO Grade (StudentId, CourseId, Value) VALUES (1, 1, 5), (2, 1, 2);

-- Вставка данных в платежи
INSERT INTO Payments (StudentId, Amount, Paid) VALUES (1, 50000, 1), (2, 30000, 0);



--Задача 1
CREATE TRIGGER trg_LimitStudents ON Students
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Groups g
        WHERE g.GroupId IN (SELECT GroupId FROM inserted)
        AND (SELECT COUNT(*) FROM Students WHERE GroupId = g.GroupId) > 30
    )
    BEGIN
        RAISERROR ('Нельзя добавить больше 30 студентов в группу', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--Задача 2
-- Триггер: Обновление количества студентов в группе
CREATE TRIGGER UpdateStudentCount ON Students
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE Groups
    SET StudentsCount = (SELECT COUNT(*) FROM Students WHERE GroupId = Groups.GroupId);
END;

--Задача 3
-- Триггер: Автоматическая регистрация студента на общий курс
CREATE TRIGGER AutoRegisterCourse ON Students
AFTER INSERT
AS
BEGIN
    INSERT INTO StudentCourses (StudentId, CourseId)
    SELECT inserted.StudentId, c.CourseId
    FROM inserted
    JOIN Courses c ON c.Name = 'Введение в программирование';
END;

--Задача 4
-- Триггер: Предупреждение о низкой оценке
CREATE TRIGGER LowGradeWarning ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO Warnings (StudentId, Reason, Date)
    SELECT StudentId, 'Низкая оценка', GETDATE()
    FROM inserted
    WHERE Value < 3;
END;

--Задача 5
-- Триггер: Запрет удаления преподавателей с активными курсами
CREATE TRIGGER PreventTeacherDeletion ON Teachers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Courses WHERE TeacherId IN (SELECT TeacherId FROM deleted))
    BEGIN
        RAISERROR ('Нельзя удалить преподавателя с активными курсами', 16, 1);
        RETURN;
    END
    DELETE FROM Teachers WHERE TeacherId IN (SELECT TeacherId FROM deleted);
END;

--Задача 6
-- Триггер: История изменений оценок
CREATE TRIGGER GradeHistory1 ON Grade
AFTER UPDATE
AS
BEGIN
    INSERT INTO GradeHistory (StudentId, CourseId, OldValue, NewValue, ChangeDate)
    SELECT d.StudentId, d.CourseId, d.Value, i.Value, GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.GradeId = i.GradeId;
END;

--Задача 7
-- Триггер: Контроль пропусков занятий
CREATE TRIGGER CheckAttendance ON Attendance
AFTER INSERT
AS
BEGIN
    INSERT INTO RetakeList (StudentId, Reason)
    SELECT StudentId, 'Более 5 пропусков подряд'
    FROM (
        SELECT StudentId, COUNT(*) AS MissedClasses
        FROM Attendance
        WHERE Attended = 0
        GROUP BY StudentId
        HAVING COUNT(*) > 5
    ) AS Missed;
END;

--Задача 8
-- Триггер: Запрет удаления студентов с долгами
CREATE TRIGGER PreventStudentDeletion ON Students
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Payments WHERE StudentId IN (SELECT StudentId FROM deleted) AND Paid = 0
    ) OR EXISTS (
        SELECT 1 FROM Grade WHERE StudentId IN (SELECT StudentId FROM deleted) AND Value < 3
    )
    BEGIN
        RAISERROR ('Нельзя удалить студента с задолженностями', 16, 1);
        RETURN;
    END
    DELETE FROM Students WHERE StudentId IN (SELECT StudentId FROM deleted);
END;

--Задача 9
-- Триггер: Обновление среднего балла студента
CREATE TRIGGER UpdateAvgGrade ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Students
    SET AvgGrade = (
        SELECT AVG(CAST(Value AS DECIMAL(4,2)))
        FROM Grade
        WHERE StudentId = Students.StudentId
    );
END;
