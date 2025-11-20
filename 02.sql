-- Create Database
CREATE DATABASE TY_B72;
USE TY_B72;

-- Create Employee Table
CREATE TABLE employee (
    empno INT PRIMARY KEY,
    empname VARCHAR(50),
    designation VARCHAR(50),
    city VARCHAR(50),
    salary DECIMAL(10,2),
    zipcode VARCHAR(10),
    county VARCHAR(50)
);
-- Insert Sample Employee Data
CREATE SEQUENCE emp_seq
START WITH 11
INCREMENT BY 1;


INSERT INTO employee VALUES
(1, 'Rajesh Kumar', 'Manager', 'Mumbai', 45000, '400001', 'Maharashtra'),
(2, 'Priya Sharma', 'Developer', 'Mumbai', 38000, '400002', 'Maharashtra'),
(3, 'Amit Patel', 'Analyst', 'Pune', 42000, '411001', 'Maharashtra'),
(4, 'Sneha Desai', 'HR', 'Mumbai', 35000, '400003', 'Maharashtra'),
(5, 'Vikram Singh', 'Team Lead', 'Delhi', 55000, '110001', 'Delhi'),
(6, 'Neha Gupta', 'Developer', 'Bangalore', 48000, '560001', 'Karnataka'),
(7, 'Rahul Verma', 'Designer', 'Mumbai', 40000, '400004', 'Maharashtra'),
(8, 'Kavita Joshi', 'Tester', 'Pune', 32000, '411002', 'Maharashtra'),
(9, 'Arjun Mehta', 'Manager', 'Chennai', 52000, '600001', 'Tamil Nadu'),
(10, 'Pooja Iyer', 'Analyst', 'Mumbai', 44000, '400005', 'Maharashtra');
-- Create Sequence for Employee Number

INSERT INTO employee(empno, empname, designation, city, salary, zipcode, county)
VALUES(emp_seq.NEXTVAL, 'Raj', 'Manager', 'Mumbai', 45000, '071', 'India');


CREATE INDEX idx_county ON employee(county);

SELECT county
FROM employee
WHERE zipcode = '071';


CREATE VIEW emp_mumbai_lowpay AS
SELECT empno, empname, city, salary
FROM employee
WHERE salary < 50000
  AND city = 'Mumbai';


SELECT COUNT(*)
FROM employee
WHERE city = 'Mumbai';


SELECT AVG(salary)
FROM emp_mumbai_lowpay;


SELECT empname
FROM emp_mumbai_lowpay
WHERE street IN (
    SELECT street FROM emp_mumbai_lowpay
    GROUP BY street
    HAVING COUNT(*) > 1
);

