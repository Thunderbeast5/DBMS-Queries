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
CREATE SEQUENCE emp_seq
START WITH 11
INCREMENT BY 1
MINVALUE 1
MAXVALUE 9999
CYCLE;

-- Using sequence to insert new employee
INSERT INTO employee VALUES
(NEXT VALUE FOR emp_seq, 'New Employee', 'Position', 'City', 30000, '000000', 'County');

-- Alternative: Using AUTO_INCREMENT (MySQL specific)
-- Modify table to use AUTO_INCREMENT
ALTER TABLE employee MODIFY empno INT AUTO_INCREMENT;

-- Insert without specifying empno
INSERT INTO employee (empname, designation, city, salary, zipcode, county) VALUES
('Auto Employee', 'Developer', 'Mumbai', 35000, '400006', 'Maharashtra');
-- Create Index on county column
CREATE INDEX idx_county ON employee(county);

-- Create Index with specific name
CREATE INDEX county_index ON employee(county);

-- Show indexes on the table
SHOW INDEX FROM employee;

-- Note: The question asks for "country" but table has "county"
-- Assuming it means county

-- First, create index on zipcode for better performance
CREATE INDEX idx_zipcode ON employee(zipcode);

-- Query to find county with zipcode = '071'
SELECT county, empname, city
FROM employee
WHERE zipcode = '071';

-- Check if index is used - Use EXPLAIN
EXPLAIN SELECT county, empname, city
FROM employee
WHERE zipcode = '071';

-- Alternative: Find county with zipcode starting with 071
SELECT county, empname, city
FROM employee
WHERE zipcode LIKE '071%';

-- Check execution plan
EXPLAIN SELECT county, empname, city
FROM employee
WHERE zipcode LIKE '071%';

-- Create View for Mumbai employees with salary < 50000
CREATE VIEW mumbai_employees_low_salary AS
SELECT empno, empname, designation, city, salary, zipcode, county
FROM employee
WHERE salary < 50000 AND city = 'Mumbai';

-- Query the view
SELECT * FROM mumbai_employees_low_salary;


-- Count employees in Mumbai using the view
SELECT COUNT(*) AS mumbai_employee_count
FROM mumbai_employees_low_salary;

-- Alternative: Direct count from main table
SELECT COUNT(*) AS total_mumbai_employees
FROM employee
WHERE city = 'Mumbai';

-- Count from view with salary filter
SELECT COUNT(*) AS count_mumbai_low_salary
FROM mumbai_employees_low_salary;

-- Average salary from the view
SELECT AVG(salary) AS average_salary
FROM mumbai_employees_low_salary;

-- With formatting
SELECT ROUND(AVG(salary), 2) AS average_salary
FROM mumbai_employees_low_salary;

-- Detailed statistics from view
SELECT 
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM mumbai_employees_low_salary;

-- Note: The table doesn't have a 'street' column
-- Assuming you want employees from same city or zipcode

-- Option 1: Employees from same city as those in view
SELECT DISTINCT e.empname, e.city, e.zipcode
FROM employee e
WHERE e.city IN (SELECT DISTINCT city FROM mumbai_employees_low_salary);

-- Option 2: Employees with same zipcode as employees in view
SELECT e.empname, e.zipcode, e.city
FROM employee e
WHERE e.zipcode IN (SELECT DISTINCT zipcode FROM mumbai_employees_low_salary);

-- Option 3: If table had 'street' column, query would be:
-- SELECT e.empname, e.street
-- FROM employee e
-- WHERE e.street IN (SELECT DISTINCT street FROM mumbai_employees_low_salary);

-- Option 4: Show employees from view grouped by zipcode (similar area)
SELECT empname, city, zipcode
FROM mumbai_employees_low_salary
ORDER BY zipcode;