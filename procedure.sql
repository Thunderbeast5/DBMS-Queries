-- SQL script: tyb46 library assignment
-- Tables and procedures for Borrower and Fine
sudo -i -u postgres
psql

sudo -U postgres
psql

CREATE DATABASE library_db;

-- Connect to it
\c library_db;

-- create tables
CREATE TABLE Borrower(
    rollin INT PRIMARY KEY,
    name TEXT,
    dateOfIssue DATE,
    nameOfBook TEXT,
    status CHAR(1)
);

CREATE TABLE Fine(
    roll_no INT,
    date DATE,
    amt INT,
    FOREIGN KEY (roll_no) REFERENCES Borrower(rollin)
);

-- insert procedure
CREATE OR REPLACE PROCEDURE proc_insert_borrower(
    p_roll INT,
    p_name TEXT,
    p_issue_date DATE,
    p_book_name TEXT,
    p_status CHAR(1)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Borrower (rollin, name, dateOfIssue, nameOfBook, status)
    VALUES (p_roll, p_name, p_issue_date, p_book_name, p_status);
    RAISE NOTICE 'Borrower record inserted successfully!';
END;
$$;

-- fine calculation procedure
CREATE OR REPLACE PROCEDURE proc_calculate_fine(
    p_roll INT,
    p_return_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_issue_date DATE;
    v_days INT;
    v_fine INT := 0;
BEGIN
    SELECT dateOfIssue INTO v_issue_date FROM Borrower WHERE rollin = p_roll;

    IF v_issue_date IS NULL THEN
        RAISE NOTICE 'Roll number % not found.', p_roll;
        RETURN;
    END IF;

    v_days := p_return_date - v_issue_date;

    IF v_days BETWEEN 15 AND 30 THEN
        v_fine := v_days * 5;
    ELSIF v_days > 30 THEN
        v_fine := v_days * 50;
    ELSE
        v_fine := 0;
    END IF;

    UPDATE Borrower SET status = 'R' WHERE rollin = p_roll;

    IF v_fine > 0 THEN
        INSERT INTO Fine(roll_no, date, amt) VALUES (p_roll, p_return_date, v_fine);
        RAISE NOTICE 'Fine Applied for roll %: Rs %', p_roll, v_fine;
    ELSE
        RAISE NOTICE 'No Fine for roll %', p_roll;
    END IF;
END;
$$;

-- Example test calls (uncomment to run)
-- CALL proc_insert_borrower(101, 'Rahul', '2025-02-01', 'DBMS', 'I');
-- CALL proc_calculate_fine(101, '2025-02-21');

-- Minimal test cases
-- CALL proc_insert_borrower(201, 'Sneha', '2025-02-10', 'Java', 'I');
-- CALL proc_calculate_fine(201, '2025-02-20');  -- No fine

-- CALL proc_insert_borrower(202, 'Amit', '2025-02-01', 'Python', 'I');
-- CALL proc_calculate_fine(202, '2025-02-21');  -- Fine: 20*5 = 100

-- CALL proc_insert_borrower(203, 'Neha', '2025-02-01', 'C', 'I');
-- CALL proc_calculate_fine(203, '2025-03-15');  -- Fine: 42*50 = 2100

-- Check results
-- SELECT * FROM Borrower;
-- SELECT * FROM Fine;
