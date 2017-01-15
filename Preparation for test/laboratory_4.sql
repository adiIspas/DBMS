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