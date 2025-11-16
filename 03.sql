-- Create Database
CREATE DATABASE TY_B72;
USE TY_B72;

-- Create Instructor Table
CREATE TABLE Instructor (
    instructorid INT PRIMARY KEY,
    Instructorname VARCHAR(50),
    instructorcity VARCHAR(50),
    specialization VARCHAR(50)
);

-- Create Student Table
CREATE TABLE Student (
    studentid INT PRIMARY KEY,
    studentname VARCHAR(50),
    instructorid INT,
    studentcity VARCHAR(50),
    FOREIGN KEY (instructorid) REFERENCES Instructor(instructorid)
);
-- Insert Instructor Data
INSERT INTO Instructor VALUES
(101, 'Prof. Sharma', 'Pune', 'Computer'),
(102, 'Prof. Gupta', 'Mumbai', 'Physics'),
(103, 'Prof. Verma', 'Pune', 'Maths'),
(104, 'Prof. Singh', 'Delhi', 'Chemistry');

-- Insert Student Data
INSERT INTO Student VALUES
(1, 'Anjali', 101, 'Pune'),
(2, 'Rohan', 102, 'Mumbai'),
(3, 'Priya', 101, 'Nagpur'),
(4, 'Suresh', 103, 'Pune'),
(5, 'Kavita', NULL, 'Delhi'),
(6, 'Vikram', 103, 'Mumbai');

-- 1. Find the instructor of each student (INNER JOIN)
SELECT s.studentname, i.Instructorname
FROM Student s
INNER JOIN Instructor i ON s.instructorid = i.instructorid;

-- 2. Find the student who is not having any instructor (LEFT JOIN)
SELECT s.studentname
FROM Student s
LEFT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorid IS NULL;

-- 3. Find the student who is not having any instructor as well as instructor who is not having student (FULL OUTER JOIN using UNION)
SELECT s.studentname, i.Instructorname
FROM Student s
LEFT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorid IS NULL
UNION
SELECT s.studentname, i.Instructorname
FROM Student s
RIGHT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE s.studentid IS NULL;

-- 4. Find the students whose instructor's specialization is computer (INNER JOIN with WHERE)
SELECT s.studentname
FROM Student s
JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.specialization = 'Computer';

-- 5. Create a view containing the total number of students whose instructor belongs to "Pune"
CREATE VIEW PuneStudentsCount AS
SELECT COUNT(s.studentid) AS total_students_from_pune_instructor
FROM Student s
JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorcity = 'Pune';

-- Query the view
SELECT * FROM PuneStudentsCount;