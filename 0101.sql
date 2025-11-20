-- ============================================
-- 1. DATABASE CREATION
-- ============================================
CREATE DATABASE TYB53;
USE TYB53;

-- ============================================
-- 2. TABLE CREATION
-- ============================================

-- Create 'employee' table
CREATE TABLE employee (
    employee_name VARCHAR(50) NOT NULL,
    street VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (employee_name)
);

-- Create 'company' table
CREATE TABLE company (
    company_name VARCHAR(50) NOT NULL,
    city VARCHAR(30),
    PRIMARY KEY (company_name)
);

-- Create 'works' table
CREATE TABLE works (
    employee_name VARCHAR(50),
    company_name VARCHAR(50),
    salary FLOAT,
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

-- Create 'manages' table
CREATE TABLE manages (
    employee_name VARCHAR(30),
    manager VARCHAR(30),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

-- ============================================
-- 3. INSERT DATA INTO TABLES
-- ============================================

-- Insert employees
INSERT INTO employee (employee_name, street, city) VALUES
('Raj', 'MG Road', 'Mumbai'),
('Sim', 'Park Lane', 'Delhi'),
('Avi', 'Church St', 'Bangalore'),
('Jai', 'Residency Rd', 'Pune'),
('Dev', 'MG Road', 'Hyderabad'),
('Neel', 'Brigade Rd', 'Bangalore'),
('Veer', 'Park Ave', 'Chennai'),
('Arjun', 'MG Road', 'Kolkata'),
('Aman', 'MG Road', 'Delhi'),
('Ria', 'Link Rd', 'Jaipur');

-- Insert companies
INSERT INTO company (company_name, city) VALUES
('Tata', 'Mumbai'),
('Infosys', 'Bangalore'),
('Reliance', 'Mumbai'),
('Wipro', 'Bangalore'),
('HCL', 'Noida'),
('L&T', 'Mumbai'),
('Mahindra', 'Pune'),
('Bajaj', 'Pune'),
('Maruti', 'Delhi'),
('Godrej', 'Mumbai');

-- Insert work relationships
INSERT INTO works (employee_name, company_name, salary) VALUES
('Raj', 'Tata', 75000),
('Sim', 'Infosys', 68000),
('Avi', 'Wipro', 70000),
('Jai', 'Reliance', 72000),
('Dev', 'HCL', 65000),
('Neel', 'Infosys', 69000),
('Veer', 'Wipro', 71000),
('Arjun', 'Tata', 74000),
('Aman', 'Maruti', 60000),
('Ria', 'Godrej', 62000);

-- Insert manager relationships
INSERT INTO manages (employee_name, manager) VALUES
('Raj', NULL),
('Sim', 'Raj'),
('Avi', 'Raj'),
('Jai', 'Sim'),
('Dev', 'Sim'),
('Neel', 'Avi'),
('Veer', 'Avi'),
('Arjun', 'Jai'),
('Aman', 'Jai'),
('Ria', 'Dev');

-- ============================================
-- 4. VERIFY DATA
-- ============================================
SELECT * FROM employee;
SELECT * FROM company;
SELECT * FROM works;
SELECT * FROM manages;

-- 1. Display all employees
SELECT * FROM employee;

-- 2. Display all companies
SELECT * FROM company;

-- 3. Display all work relationships
SELECT * FROM works;

-- 4. Display all manager relationships
SELECT * FROM manages;

-- 5. Find employees working for a specific company
SELECT * FROM works WHERE company_name = 'Tata';

-- 6. Find employees NOT working for Tata
SELECT employee_name FROM works WHERE company_name != 'Tata';

-- 7. Find names and cities of employees working for Tata
SELECT E.employee_name, E.city
FROM employee AS E, works AS W
WHERE E.employee_name = W.employee_name 
  AND W.company_name = 'Tata';

-- 8. Find employees working for Tata with salary > 74000
SELECT E.employee_name, E.street, E.city
FROM employee AS E, works AS W
WHERE E.employee_name = W.employee_name 
  AND W.company_name = 'Tata' 
  AND W.salary > 74000;

-- 9. Find employees living in the same city as their company
SELECT DISTINCT E.employee_name
FROM employee AS E, works AS W, company AS C
WHERE E.employee_name = W.employee_name 
  AND W.company_name = C.company_name
  AND E.city = C.city;

-- 10. Find employees living in same city AND working for companies there
SELECT DISTINCT E.employee_name
FROM employee AS E, works AS W, company AS C
WHERE E.employee_name = W.employee_name 
  AND E.city = C.city 
  AND W.company_name = C.company_name;

-- 11. Find employees earning more than ALL Tata employees
SELECT employee_name
FROM works
WHERE salary > ALL(
    SELECT salary 
    FROM works 
    WHERE company_name = 'Tata'
);

-- 12. Find employees earning more than ALL Infosys employees
SELECT employee_name
FROM works
WHERE salary > ALL(
    SELECT salary 
    FROM works 
    WHERE company_name = 'Infosys'
);

-- 13. Find employees earning above average salary in their company
SELECT employee_name
FROM works AS W
WHERE salary > (
    SELECT AVG(salary)
    FROM works W1
    WHERE W.company_name = W1.company_name
);

-- 14. Find companies in the same city as Tata
SELECT D.company_name
FROM company AS C, company AS D
WHERE C.company_name = 'Tata' 
  AND C.city = D.city;

-- 15. Count total employees in works table
SELECT COUNT(employee_name) FROM works;

-- 16. Find maximum company name (alphabetically)
SELECT MAX(company_name) FROM works;

-- 17. Count employees per company
SELECT company_name, COUNT(employee_name) AS employee_count
FROM works
GROUP BY company_name;

-- 18. Order companies by number of employees
SELECT company_name, COUNT(employee_name) AS employee_count
FROM works
GROUP BY company_name
ORDER BY COUNT(employee_name);

-- 19. Find average salary per company
SELECT company_name, AVG(salary) AS avg_salary
FROM works
GROUP BY company_name;

-- 20. Find total salary expenditure per company
SELECT company_name, SUM(salary) AS total_salary
FROM works
GROUP BY company_name
ORDER BY SUM(salary) DESC;

-- 21. Find companies with more than 1 employee
SELECT company_name, COUNT(employee_name) AS employee_count
FROM works
GROUP BY company_name
HAVING COUNT(employee_name) > 1;


-- 22. Find highest paid employee
SELECT employee_name, salary
FROM works
ORDER BY salary DESC
LIMIT 1;

-- 23. Find employees earning between 65000 and 72000
SELECT employee_name, salary
FROM works
WHERE salary BETWEEN 65000 AND 72000;

-- 24. Find total salary paid by all companies
SELECT SUM(salary) AS total_payroll FROM works;

-- 25. Find companies paying above average salary
SELECT DISTINCT company_name
FROM works
WHERE salary > (SELECT AVG(salary) FROM works);

-- 26. Find all employees and their managers
SELECT E.employee_name, M.manager
FROM employee AS E
LEFT JOIN manages AS M ON E.employee_name = M.employee_name;

-- 27. Find employees managed by 'Raj'
SELECT employee_name
FROM manages
WHERE manager = 'Raj';

-- 28. Find employees without managers (top-level)
SELECT employee_name
FROM manages
WHERE manager IS NULL;


-- 29. Find all employees in Mumbai
SELECT * FROM employee WHERE city = 'Mumbai';

-- 30. Find companies in Bangalore
SELECT * FROM company WHERE city = 'Bangalore';

-- 31. Count employees per city
SELECT city, COUNT(employee_name) AS employee_count
FROM employee
GROUP BY city;

-- 32. Find cities with multiple companies
SELECT city, COUNT(company_name) AS company_count
FROM company
GROUP BY city
HAVING COUNT(company_name) > 1;


-- 33. Find employee details with company and salary info
SELECT E.employee_name, E.city, W.company_name, W.salary
FROM employee AS E
JOIN works AS W ON E.employee_name = W.employee_name;

-- 34. Find companies with no employees (if any exist)
SELECT company_name
FROM company
WHERE company_name NOT IN (SELECT company_name FROM works);

-- 35. Find the second highest salary
SELECT MAX(salary) AS second_highest
FROM works
WHERE salary < (SELECT MAX(salary) FROM works);