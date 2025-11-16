-- Create Database
CREATE DATABASE TY_B72;
USE TY_B72;

-- Create Tables
CREATE TABLE employee (
    employee_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE company (
    company_name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY(company_name, city)
);

CREATE TABLE works (
    employee_name VARCHAR(50) PRIMARY KEY,
    company_name VARCHAR(50),
    salary INT,
    join_date DATE
);

CREATE TABLE manages (
    employee_name VARCHAR(50) PRIMARY KEY,
    manager_name VARCHAR(50)
);
-- Insert Employee Data
INSERT INTO employee VALUES
('Rajesh Kumar', 'FC Road', 'Pune'),
('Priya Sharma', 'MG Road', 'Mumbai'),
('Ankit Desai', 'FC Road', 'Pune'),
('Sonia Singh', 'Marine Drive', 'Mumbai'),
('Vikram Rathod', 'Koregaon Park', 'Pune'),
('Meera Iyer', 'Indiranagar', 'Bangalore'),
('Arjun Mehta', 'Ramdaspeth', 'Nagpur'),
('Alok Verma', 'Wall Street', 'Mumbai');

-- Insert Company Data
INSERT INTO company VALUES
('First Bank Corporation', 'Mumbai'),
('Small Bank Corporation', 'Pune'),
('Small Bank Corporation', 'Nagpur'),
('Global Tech', 'Bangalore'),
('Apex Solutions', 'Pune');

-- Insert Works Data
INSERT INTO works VALUES
('Rajesh Kumar', 'Apex Solutions', 15000, '2022-05-10'),
('Priya Sharma', 'First Bank Corporation', 25000, '2021-11-20'),
('Ankit Desai', 'Apex Solutions', 12000, '2023-01-15'),
('Sonia Singh', 'First Bank Corporation', 11000, '2023-03-01'),
('Vikram Rathod', 'Small Bank Corporation', 8000, '2022-08-25'),
('Meera Iyer', 'Global Tech', 18000, '2021-09-05'),
('Arjun Mehta', 'Small Bank Corporation', 9000, '2023-02-18'),
('Alok Verma', 'First Bank Corporation', 30000, '2020-07-30');

-- Insert Manages Data
INSERT INTO manages VALUES
('Ankit Desai', 'Rajesh Kumar'),
('Sonia Singh', 'Priya Sharma'),
('Vikram Rathod', 'Rajesh Kumar'),
('Arjun Mehta', 'Rajesh Kumar'),
('Priya Sharma', 'Alok Verma'),
('Rajesh Kumar', 'Alok Verma');
-- 1. Find the names of all employees who work for First Bank Corporation
SELECT employee_name 
FROM works 
WHERE company_name = 'First Bank Corporation';

-- 2. Find the names and cities of residence of all employees who work for First Bank Corporation
SELECT e.employee_name, e.city
FROM employee e, works w
WHERE e.employee_name = w.employee_name
AND w.company_name = 'First Bank Corporation';

-- 3. Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than Rs.10,000
SELECT e.employee_name, e.street, e.city
FROM employee e, works w
WHERE e.employee_name = w.employee_name
AND w.company_name = 'First Bank Corporation' 
AND w.salary > 10000;

-- 4. Find all employees in the database who live in the same cities as the companies for which they work
SELECT e.employee_name
FROM employee e, works w, company c
WHERE e.employee_name = w.employee_name
AND w.company_name = c.company_name 
AND e.city = c.city;

-- 5. Find all employees who live in the same cities and on the same streets as their managers
SELECT e.employee_name
FROM employee e, employee m, manages mg
WHERE e.employee_name = mg.employee_name
AND m.employee_name = mg.manager_name
AND e.city = m.city 
AND e.street = m.street;

-- 6. Find all employees who do not work for First Bank Corporation
SELECT employee_name 
FROM works 
WHERE company_name <> 'First Bank Corporation';

-- 7. Find all employees who earn more than each employee of Small Bank Corporation
SELECT employee_name 
FROM works
WHERE salary > ALL (
    SELECT salary 
    FROM works 
    WHERE company_name = 'Small Bank Corporation'
);

-- 8. Find all companies located in every city in which Small Bank Corporation is located
SELECT company_name 
FROM company
WHERE city IN (
    SELECT city 
    FROM company 
    WHERE company_name = 'Small Bank Corporation'
)
GROUP BY company_name
HAVING COUNT(DISTINCT city) = (
    SELECT COUNT(DISTINCT city) 
    FROM company 
    WHERE company_name = 'Small Bank Corporation'
);

-- 9. Find all employees who earn more than the average salary of all employees of their company
SELECT w1.employee_name 
FROM works w1
WHERE w1.salary > (
    SELECT AVG(w2.salary) 
    FROM works w2 
    WHERE w2.company_name = w1.company_name
);

-- 10. Find the company that has the most employees
SELECT company_name 
FROM works
GROUP BY company_name 
ORDER BY COUNT(employee_name) DESC 
LIMIT 1;

-- 11. Find the company that has the smallest payroll
SELECT company_name 
FROM works
GROUP BY company_name 
ORDER BY SUM(salary) ASC 
LIMIT 1;

-- 12. Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation
SELECT company_name 
FROM works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary) 
    FROM works 
    WHERE company_name = 'First Bank Corporation'
);