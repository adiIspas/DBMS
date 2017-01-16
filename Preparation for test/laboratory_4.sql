-- Laboratorul 4

-- Exercitiul 1
DECLARE
  v_nume employees.last_name%TYPE := '&p_nume';
  
  FUNCTION f_1 RETURN NUMBER IS
    salariu employees.salary%TYPE;
    BEGIN
      SELECT salary
      INTO salariu
      FROM employees
      WHERE LOWER(last_name) = LOWER(v_nume);
      RETURN salariu;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista date');
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe inregistrari');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare');
    END f_1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(f_1);
END;
/

-- Exercitiul 2
CREATE OR REPLACE FUNCTION f_2_ysp(v_nume employees.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER IS 
  salariu employees.salary%TYPE;
    BEGIN
      SELECT salary
      INTO salariu
      FROM employees
      WHERE LOWER(last_name) = LOWER(v_nume);
      RETURN salariu;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista date');
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe inregistrari');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare');
END f_2_ysp;

DECLARE
  v_nume employees.last_name%TYPE := '&p_nume';
BEGIN
  DBMS_OUTPUT.PUT_LINE(f_2_ysp(v_nume));
END;
/

-- Exercitiul 3
DECLARE
  v_nume employees.last_name%TYPE := '&p_nume';
  PROCEDURE p_1 IS 
    salariu employees.salary%TYPE;
    BEGIN
      SELECT salary
      INTO salariu
      FROM employees
      WHERE LOWER(last_name) = LOWER(v_nume);
      DBMS_OUTPUT.PUT_LINE('Salariul este ' || salariu);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista date');
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe valori');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
  END p_1;
BEGIN 
  p_1;
END;
/

-- Exercitiul 4
CREATE OR REPLACE PROCEDURE p_1_ysp(v_nume employees.last_name%TYPE DEFAULT 'Bell') IS
  salariu employees.salary%TYPE;
  BEGIN
    SELECT salary
    INTO salariu
    FROM employees
    WHERE LOWER(last_name) = LOWER(v_nume);
    DBMS_OUTPUT.PUT_LINE('Salariul este ' || salariu);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista date');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Exista mai multe valori');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Alta eroare');
END p_1_ysp;

DECLARE
  v_nume employees.last_name%TYPE := '&p_nume';
BEGIN
  p_1_ysp(v_nume);
END;
/

-- Exercitiul 5
CREATE OR REPLACE PROCEDURE p_5_ysp(nr IN OUT NUMBER) IS
BEGIN  
  SELECT manager_id 
  INTO nr
  FROM employees
  WHERE employee_id = nr;
END p_5_ysp;

DECLARE
  v_cod NUMBER(4):=&p_cod;
BEGIN
  p_5_ysp(v_cod);
  DBMS_OUTPUT.PUT_LINE(v_cod);
END;
/

-- Exercitiul 6
DECLARE
  v_nume employees.last_name%TYPE;
  
  PROCEDURE p_6_ysp(rezultat OUT employees.last_name%TYPE, 
    v_commission employees.commission_pct%TYPE := NULL, 
    v_cod employees.employee_id%TYPE := NULL) IS
  BEGIN
    IF v_commission IS NOT NULL THEN 
      SELECT last_name
      INTO rezultat
      FROM employees
      WHERE commission_pct = v_commission;
    ELSE
      SELECT last_name
      INTO rezultat
      FROM employees
      WHERE employee_id = v_cod;
    END IF;
  END p_6_ysp;
BEGIN
  p_6_ysp(v_nume,0.4);
  DBMS_OUTPUT.PUT_LINE(v_nume);
  
  p_6_ysp(v_nume, NULL, 100);
  DBMS_OUTPUT.PUT_LINE(v_nume);
END;
/

-- Exercitiul 7
DECLARE
  salariu employees.salary%TYPE;
  FUNCTION f_7_ysp(v_cod employees.department_id%TYPE) RETURN NUMBER IS
    BEGIN
      SELECT AVG(salary)
      INTO salariu
      FROM employees
      WHERE department_id = v_cod;
    RETURN salariu;
  END f_7_ysp;
  
  FUNCTION f_7_ysp(v_cod employees.department_id%TYPE, v_job employees.job_id%TYPE) RETURN NUMBER IS
    BEGIN
      SELECT AVG(salary)
      INTO salariu
      FROM employees
      WHERE department_id = v_cod AND job_id = v_job;
    RETURN salariu;
  END f_7_ysp;
BEGIN
  DBMS_OUTPUT.PUT_LINE(f_7_ysp(30));
  DBMS_OUTPUT.PUT_LINE(f_7_ysp(30,'PU_CLERK'));
END;
/

-- Exercitiul 9
CREATE OR REPLACE FUNCTION p_9_ysp RETURN NUMBER IS
  salariu employees.salary%TYPE;
  BEGIN
    SELECT AVG(salary)
    INTO salariu
    FROM employees;
  RETURN salariu;
END p_9_ysp;

SELECT *
FROM employees
WHERE salary >= p_9_ysp;