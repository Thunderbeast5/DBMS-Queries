CREATE TABLE Books (
    AccNo NUMBER PRIMARY KEY,
    Title VARCHAR2(100),
    Author VARCHAR2(100),
    Publisher VARCHAR2(100),
    Count NUMBER
);

CREATE TABLE Library_Audit (
    AccNo NUMBER,
    Title VARCHAR2(100),
    Author VARCHAR2(100),
    Publisher VARCHAR2(100),
    Count NUMBER,
    Action_Date DATE,
    Status VARCHAR2(10)
);


--before trigger
CREATE OR REPLACE TRIGGER trg_before_book_delete
BEFORE DELETE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit
    (AccNo, Title, Author, Publisher, Count, Action_Date, Status)
    VALUES
    (:OLD.AccNo, :OLD.Title, :OLD.Author, :OLD.Publisher, :OLD.Count,
     SYSDATE, 'deleted');
END;
/
--after trigger
CREATE OR REPLACE TRIGGER trg_after_book_update
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit
    (AccNo, Title, Author, Publisher, Count, Action_Date, Status)
    VALUES
    (:OLD.AccNo, :OLD.Title, :OLD.Author, :OLD.Publisher, :OLD.Count,
     SYSDATE, 'updated');
END;
/
-- Insert sample data into Books table
INSERT INTO Books VALUES(1, 'DBMS', 'Ramakrishnan', 'McGraw', 3);
INSERT INTO Books VALUES(2, 'OS', 'Galvin', 'Wiley', 5);
COMMIT;
UPDATE Books SET Count = 10 WHERE AccNo = 1;
COMMIT;
DELETE FROM Books WHERE AccNo = 2;
COMMIT;
SELECT * FROM Library_Audit;