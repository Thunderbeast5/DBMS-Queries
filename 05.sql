-- Create the database
sudo -i -u postgres
psql

sudo -U postgres
psql


CREATE DATABASE library_db;

-- Connect to it
\c library_db;

-- Create the Borrower table
CREATE TABLE Borrower (
    Rollin INT PRIMARY KEY,
    Name TEXT,
    DateOfIssue DATE,
    NameOfBook TEXT,
    Status CHAR(1)
);

-- Create the Fine table
CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt NUMERIC(10,2)
);

--PL/SQL Block to Accept Input for Borrower Table
DO $$
DECLARE
    v_rollin INT := 72;                   -- sample input
    v_name TEXT := 'Vedant Purkar';       -- sample name
    v_dateofissue DATE := CURRENT_DATE - 20;  -- book issued 20 days ago
    v_book TEXT := 'Database Systems';    -- sample book name
    v_status CHAR(1) := 'I';              -- I = Issued
BEGIN
    INSERT INTO Borrower (Rollin, Name, DateOfIssue, NameOfBook, Status)
    VALUES (v_rollin, v_name, v_dateofissue, v_book, v_status);

    RAISE NOTICE 'Record inserted successfully for borrower %', v_name;
END $$;

--PL/SQL Block to Calculate Fine and Update Records
DO $$
DECLARE
    v_rollin INT := 72;           -- borrower roll number
    v_days INT;                   -- to store number of days since issue
    v_fine NUMERIC(10,2);         -- fine amount
    v_issue DATE;                 -- date of issue
BEGIN
    -- Get the issue date for the borrower
    SELECT DateOfIssue INTO v_issue
    FROM Borrower
    WHERE Rollin = v_rollin AND Status = 'I';

    -- If no record found
    IF NOT FOUND THEN
        RAISE NOTICE 'No active record found for roll number %', v_rollin;
        RETURN;
    END IF;

    -- Calculate days between issue and current date
    v_days := CURRENT_DATE - v_issue;

    -- Fine calculation based on days
    IF v_days > 30 THEN
        v_fine := v_days * 50;
    ELSIF v_days >= 15 AND v_days <= 30 THEN
        v_fine := v_days * 5;
    ELSE
        v_fine := 0;
    END IF;

    -- Update borrower status to Returned (R)
    UPDATE Borrower SET Status = 'R' WHERE Rollin = v_rollin;

    -- Insert into Fine table if fine exists
    IF v_fine > 0 THEN
        INSERT INTO Fine (Roll_no, Date, Amt)
        VALUES (v_rollin, CURRENT_DATE, v_fine);
        RAISE NOTICE 'Fine of Rs.% levied for roll number %', v_fine, v_rollin;
    ELSE
        RAISE NOTICE 'No fine for roll number %', v_rollin;
    END IF;
END $$;

--Select to verify the inserted and updated records
-- Check Borrower table
SELECT * FROM Borrower;

-- Check Fine table
SELECT * FROM Fine;
