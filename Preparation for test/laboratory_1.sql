-- Partea I --

-- Exercitiul 3
SET SERVEROUTPUT ON;
 
BEGIN
  DBMS_OUTPUT.PUT_LINE('Invata');
END;
/

-- Exercitiul 4
DECLARE
  nume_departament departments.department_name%TYPE;
BEGIN

  SELECT department_name 
  INTO nume_departament 
  FROM employees e join departments d on (e.department_id=d.department_id )
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                     FROM employees 
                     GROUP BY department_id); 
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| nume_departament);

END;
/

-- Exercitiul 5
VARIABLE rezultat VARCHAR(50);
BEGIN

  SELECT department_name 
  INTO :rezultat 
  FROM employees e join departments d on (e.department_id=d.department_id )
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                     FROM employees 
                     GROUP BY department_id); 
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat);

END;
/
PRINT rezultat;

-- Exercitiul 6
VARIABLE rezultat VARCHAR(50);
VARIABLE numar_angajati NUMBER(10);
BEGIN

  SELECT department_name, COUNT (employee_id) 
  INTO :rezultat, :numar_angajati 
  FROM employees e join departments d on (e.department_id=d.department_id )
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                     FROM employees 
                     GROUP BY department_id); 
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat || ' are ' || :numar_angajati || ' angajati.');

END;
/
PRINT rezultat;
PRINT numar_angajati;

-- Exercitiul 7
DECLARE
  cod_angajat employees.employee_id%TYPE := &cod_input;
  salariu_anual employees.salary%TYPE;
  bonus NUMBER(10);
BEGIN
  SELECT salary
  INTO salariu_anual
  FROM employees
  WHERE employee_id = cod_angajat;
  
  IF salariu_anual >= 20001 THEN
    bonus := 2000;
  ELSIF salariu_anual BETWEEN 10001 AND 20000 THEN
    bonus := 1000;
  ELSE
    bonus := 500;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Pentru angajatul cu salariu ' || salariu_anual || ' bonusul este de ' || bonus);
END;
/

-- Exercitiul 8
DECLARE
  cod_angajat employees.employee_id%TYPE := &cod_input_angajat;
  salariu_anual employees.salary%TYPE;
  bonus NUMBER(10);
BEGIN
  SELECT salary
  INTO salariu_anual
  FROM employees
  WHERE employee_id = cod_angajat;
  
  CASE
    WHEN salariu_anual >= 20001 THEN bonus := 2000;
    WHEN salariu_anual BETWEEN 10001 AND 20000 THEN bonus := 1000;
    ELSE bonus := 500;
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE('Pentru angajatul cu salariu ' || salariu_anual || ' bonusul este de ' || bonus);
END;
/

-- Exercitiul 9
CREATE TABLE emp_ysp AS (SELECT * FROM employees);

DEFINE cod_input_angajat = 100
DEFINE cod_input_departament = 90
DEFINE procent_input_marire = 50

DECLARE
  cod_angajat employees.employee_id%TYPE := &cod_input_angajat;
  cod_departament employees.department_id%TYPE := &cod_input_departament;
  procent_marire NUMBER(10) := &procent_input_marire;
BEGIN
  UPDATE emp_ysp
  SET department_id = cod_departament, salary = salary + (salary * procent_marire/100)
  WHERE employee_id = cod_angajat;
  
  IF SQL%ROWCOUNT = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod'); 
  ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata'); 
  END IF;
END;
/

select salary from employees where employee_id = 100;
select salary from emp_ysp where employee_id = 100;

ROLLBACK;

-- Exercitiul 10
CREATE TABLE zile_ysp (
  id NUMBER(4) PRIMARY KEY,
  timp DATE DEFAULT (SYSDATE),
  nume_zi VARCHAR(10)
  );

DECLARE 
  contor NUMBER(4) := 1; 
  timp DATE; 
  zi_maxima NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
  LOOP
    timp := sysdate+contor; 
    INSERT INTO zile_ysp VALUES (contor,timp,to_char(timp,'Day')); 
    contor := contor + 1; 
    EXIT WHEN contor > zi_maxima; 
  END LOOP; 
END;
/

SELECT * FROM zile_ysp;

-- Exercitiul 11
DECLARE 
  contor NUMBER(4) := 1; 
  timp DATE; 
  zi_maxima NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
  WHILE contor <= zi_maxima LOOP
    timp := sysdate+contor; 
    INSERT INTO zile_ysp VALUES (contor,timp,to_char(timp,'Day')); 
    contor := contor + 1;  
  END LOOP; 
END;
/

-- Exercitiul 12
DECLARE 
  contor NUMBER(4) := 1; 
  timp DATE; 
  zi_maxima NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
  FOR idx IN 1..zi_maxima LOOP
    contor := idx;
    timp := sysdate+contor; 
    INSERT INTO zile_ysp VALUES (contor,timp,to_char(timp,'Day')); 
    contor := contor + 1;  
  END LOOP; 
END;
/

DROP TABLE zile_ysp;

-- 
-- Partea II --


