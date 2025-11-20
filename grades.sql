CREATE TABLE Stud_Marks(
    roll INT PRIMARY KEY,
    name TEXT,
    total_marks INT
);

CREATE TABLE Result(
    roll INT,
    name TEXT,
    class TEXT
);

CREATE TABLE Analysis(
    class TEXT,
    count INT
);

CREATE OR REPLACE PROCEDURE proc_grade()
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    v_class TEXT;
BEGIN
    -- Clear old result (optional)
    DELETE FROM Result;

    FOR r IN SELECT * FROM Stud_Marks LOOP
        
        IF r.total_marks BETWEEN 990 AND 1500 THEN
            v_class := 'Distinction';

        ELSIF r.total_marks BETWEEN 900 AND 989 THEN
            v_class := 'First Class';

        ELSIF r.total_marks BETWEEN 825 AND 899 THEN
            v_class := 'Higher Second Class';

        ELSIF r.total_marks BETWEEN 601 AND 824 THEN
            v_class := 'Pass Class';

        ELSE
            v_class := 'Fail';
        END IF;

        INSERT INTO Result (roll, name, class)
        VALUES (r.roll, r.name, v_class);

    END LOOP;

    RAISE NOTICE 'Result table updated successfully!';
END;
$$;

CREATE OR REPLACE PROCEDURE proc_analysis()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Clear previous analysis
    DELETE FROM Analysis;

    INSERT INTO Analysis(class, count)
    SELECT class, COUNT(*)
    FROM Result
    GROUP BY class;

    RAISE NOTICE 'Analysis table updated!';
END;
$$;

INSERT INTO Stud_Marks VALUES
(1, 'Rahul', 1200),
(2, 'Sneha', 950),
(3, 'Amit', 860),
(4, 'Neha', 700),
(5, 'John', 500);

CALL proc_grade();
CALL proc_analysis();

SELECT * FROM Result;
SELECT * FROM Analysis;