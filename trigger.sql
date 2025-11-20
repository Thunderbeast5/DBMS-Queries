CREATE TABLE books(
    accno       INT PRIMARY KEY,
    title       VARCHAR(100),
    author      VARCHAR(100),
    publisher   VARCHAR(100),
    count       INT
);

CREATE TABLE library_audit(
    accno       INT,
    title       VARCHAR(100),
    author      VARCHAR(100),
    publisher   VARCHAR(100),
    count       INT,
    changed_on  TIMESTAMP,
    status      VARCHAR(20)
);
--function
CREATE OR REPLACE FUNCTION audit_books_delete()
RETURNS TRIGGER 
AS $$
BEGIN
    INSERT INTO library_audit
    (accno, title, author, publisher, count, changed_on, status)
    VALUES
    (OLD.accno, OLD.title, OLD.author, OLD.publisher, OLD.count,
     NOW(), 'DELETED');

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

--trigger
CREATE TRIGGER trg_books_delete
BEFORE DELETE ON books
FOR EACH ROW
EXECUTE FUNCTION audit_books_delete();

--function
CREATE OR REPLACE FUNCTION audit_books_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO library_audit
    (accno, title, author, publisher, count, changed_on, status)
    VALUES
    (NEW.accno, NEW.title, NEW.author, NEW.publisher, NEW.count,
     NOW(), 'UPDATED');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--trigger
CREATE TRIGGER trg_books_update
AFTER UPDATE ON books
FOR EACH ROW
EXECUTE FUNCTION audit_books_update();
--test inserts
INSERT INTO books VALUES (101, 'DBMS', 'Raghu', 'Tata', 5);

UPDATE books SET count = 10 WHERE accno = 101;

DELETE FROM books WHERE accno = 101;

SELECT * FROM library_audit;

