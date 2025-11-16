CREATE TABLE Employee (
    Emp_ID    NUMBER PRIMARY KEY,
    Name      VARCHAR2(50),
    HireDate  DATE,
    Salary    NUMBER
);


INSERT INTO Employee VALUES (101, 'Vedant',    DATE '2021-02-10', 30000);
INSERT INTO Employee VALUES (102, 'Anita',     DATE '2024-02-05', 25000);
INSERT INTO Employee VALUES (103, 'Rahul',     DATE '2020-08-12', 45000);
INSERT INTO Employee VALUES (104, 'Sara',      DATE '2024-02-18', 40000);
INSERT INTO Employee VALUES (105, 'Karan',     DATE '2019-02-22', 38000);

COMMIT;


SET SERVEROUTPUT ON;

DECLARE
    CURSOR emp_cursor IS
        SELECT emp_id, name, hiredate
        FROM employee
        WHERE EXTRACT(MONTH FROM hiredate) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR FROM hiredate)  = EXTRACT(YEAR  FROM SYSDATE);

    v_id       employee.emp_id%TYPE;
    v_name     employee.name%TYPE;
    v_hiredate employee.hiredate%TYPE;
    v_exp      NUMBER;
    v_incentive NUMBER;

BEGIN
    OPEN emp_cursor;

    LOOP
        FETCH emp_cursor INTO v_id, v_name, v_hiredate;
        EXIT WHEN emp_cursor%NOTFOUND;

        -- Experience in years
        v_exp := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hiredate) / 12);

        -- Incentive logic (simple)
        IF v_exp > 5 THEN
            v_incentive := 5000;
        ELSIF v_exp > 2 THEN
            v_incentive := 3000;
        ELSE
            v_incentive := 1000;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_id ||
                             ', Name: ' || v_name ||
                             ', Hire Date: ' || TO_CHAR(v_hiredate,'DD-MON-YYYY') ||
                             ', Experience: ' || v_exp ||
                             ' yrs, Incentive: Rs.' || v_incentive);
    END LOOP;

    CLOSE emp_cursor;
END;
/
