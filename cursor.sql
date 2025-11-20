CREATE OR REPLACE PROCEDURE proc_employee_incentive_report()
LANGUAGE plpgsql
AS $$
DECLARE
    -- Explicit cursor selecting employees who joined THIS MONTH
    CURSOR emp_cur IS
        SELECT emp_id, emp_name, hire_date
        FROM Employee
        WHERE TO_CHAR(hire_date, 'MM') = TO_CHAR(CURRENT_DATE, 'MM')
          AND TO_CHAR(hire_date, 'YYYY') = TO_CHAR(CURRENT_DATE, 'YYYY');

    v_id INT;
    v_name TEXT;
    v_hire_date DATE;
    v_days INT;
    v_years INT;
    v_incentive INT;
BEGIN
    RAISE NOTICE '--- EMPLOYEE INCENTIVE REPORT ---';

    OPEN emp_cur;

    LOOP
        FETCH emp_cur INTO v_id, v_name, v_hire_date;
        EXIT WHEN NOT FOUND;

        -- Number of days worked
        v_days := CURRENT_DATE - v_hire_date;

        -- Convert days to years (easy)
        v_years := v_days / 365;

        -- Incentive = years * 1000
        v_incentive := v_years * 1000;

        RAISE NOTICE 'ID: %, Name: %, Hire Date: %, Experience: % years, Incentive: %',
                     v_id, v_name, v_hire_date, v_years, v_incentive;
    END LOOP;

    CLOSE emp_cur;
END;
$$;

INSERT INTO Employee VALUES
(1, 'Amit', CURRENT_DATE - 10),       -- same month
(2, 'Riya', CURRENT_DATE - 400),      -- same month, previous year
(3, 'Suresh', CURRENT_DATE - 2000);   -- same month, 5 years ago

CALL proc_employee_incentive_report();