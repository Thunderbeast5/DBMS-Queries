-- 1. Create and select the database
CREATE DATABASE ONE;
USE ONE;

-- 2. Create 'employee' table with name, street, and city
CREATE TABLE employee (
    employee_name VARCHAR(20),
    street VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (employee_name)
);

-- 3. Create 'company' table with name and city
CREATE TABLE company (
    company_name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (company_name)
);

-- 4. Create 'works' table to link employees with companies and salaries
CREATE TABLE works (
    employee_name VARCHAR(20),
    company_name VARCHAR(50),
    salary INT,
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

-- 5. Create 'manages' table to define employee-manager relationships
CREATE TABLE manages (
    employee_name VARCHAR(20),
    manager_name VARCHAR(20),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
    FOREIGN KEY (manager_name) REFERENCES employee(employee_name)
);

-- 6. Insert 10 sample employees
INSERT INTO employee VALUES 
('Amit Sharma', 'MG Road', 'Mumbai'),
('Neha Verma', 'Park Street', 'Kolkata'),
('Rahul Gupta', 'Brigade Road', 'Bangalore'),
('Pooja Iyer', 'Anna Salai', 'Chennai'),
('Vikram Joshi', 'Banjara Hills', 'Hyderabad'),
('Sneha Reddy', 'Marine Drive', 'Mumbai'),
('Rohan Mehta', 'Connaught Place', 'Delhi'),
('Anjali Nair', 'FC Road', 'Pune'),
('Karan Singh', 'Hazratganj', 'Lucknow'),
('Divya Kapoor', 'C.G. Road', 'Ahmedabad');

-- 7. Insert 5 companies
INSERT INTO company VALUES 
('First Bank Corporation', 'Mumbai'),
('Small Bank Corporation', 'Chennai'),
('Axis Financial Ltd', 'Bangalore'),
('HDFC Holdings', 'Delhi'),
('IDFC Services', 'Hyderabad');

-- 8. Insert employee work details including salary
INSERT INTO works VALUES
('Amit Sharma', 'First Bank Corporation', 12000),
('Neha Verma', 'First Bank Corporation', 14000),
('Rahul Gupta', 'Small Bank Corporation', 10000),
('Pooja Iyer', 'Small Bank Corporation', 15000),
('Vikram Joshi', 'Axis Financial Ltd', 13000),
('Sneha Reddy', 'HDFC Holdings', 16000),
('Rohan Mehta', 'HDFC Holdings', 10000),
('Anjali Nair', 'IDFC Services', 11000),
('Karan Singh', 'Axis Financial Ltd', 17000),
('Divya Kapoor', 'IDFC Services', 9000);

-- 9. Insert employee-manager relationships
INSERT INTO manages VALUES
('Amit Sharma', 'Neha Verma'),
('Rahul Gupta', 'Pooja Iyer'),
('Sneha Reddy', 'Rohan Mehta'),
('Anjali Nair', 'Divya Kapoor'),
('Vikram Joshi', 'Karan Singh');

-- ------------------------------------
-- 📌 QUERY SECTION
-- ------------------------------------

-- Q1. Get names of all employees working for 'First Bank Corporation'
SELECT employee_name
FROM works
WHERE company_name = 'First Bank Corporation';

-- Q2. Get names and cities of employees working for 'First Bank Corporation'
SELECT employee.employee_name, employee.city
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.company_name = 'First Bank Corporation';

-- Q3. Get names, streets, and cities of employees working at 'First Bank Corporation' with salary > 10000
SELECT employee.employee_name, employee.street, employee.city
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.company_name = 'First Bank Corporation'
  AND works.salary > 10000;

-- Q4. Get names of employees who live in the same city as the company they work for
SELECT employee.employee_name
FROM employee
JOIN works ON employee.employee_name = works.employee_name
JOIN company ON works.company_name = company.company_name
WHERE employee.city = company.city;

-- Q5. Get names of employees who live on the same street and city as their manager
SELECT employee.employee_name
FROM employee
JOIN manages ON employee.employee_name = manages.employee_name
JOIN employee AS manager ON manages.manager_name = manager.employee_name
WHERE employee.city = manager.city
  AND employee.street = manager.street;



-- Q6. Get names of employees who do NOT work for 'First Bank Corporation'
SELECT employee_name
FROM works
WHERE company_name != 'First Bank Corporation';

-- Q7. Get names of employees who earn more than ALL employees at 'Small Bank Corporation'
SELECT employee_name
FROM works
WHERE salary > ALL (
    SELECT salary
    FROM works
    WHERE company_name = 'Small Bank Corporation'
);

-- Q8. Get companies that are located in every city that 'Small Bank Corporation' is located in
SELECT DISTINCT company.company_name
FROM company
WHERE NOT EXISTS (
    SELECT city
    FROM company
    WHERE company_name = 'Small Bank Corporation'
    EXCEPT
    SELECT city
    FROM company AS c2
    WHERE c2.company_name = company.company_name
);

-- Q9. Get names of employees whose salary is above the average salary
SELECT employee_name
FROM works
WHERE salary > (
    SELECT AVG(salary)
    FROM works
);

-- Q10. Find the company that has the most employees
SELECT company_name
FROM works
GROUP BY company_name
ORDER BY COUNT(employee_name) DESC
LIMIT 1;

-- Q11. Find the company that pays the lowest total salary to employees
SELECT company_name
FROM works
GROUP BY company_name
ORDER BY SUM(salary) ASC
LIMIT 1;

-- Q12. Find companies where the average salary is higher than the average salary at 'First Bank Corporation'
SELECT company_name
FROM works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM works
    WHERE company_name = 'First Bank Corporation'
);





