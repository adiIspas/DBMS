-- Laboratorul 2
-- Partea 1

-- Exercitiul 2
CREATE TABLE emp_ysp AS (SELECT * FROM employees);

DECLARE
  TYPE emp_record IS RECORD
    (cod_angajat employees.employee_id%TYPE,
     salariu employees.salary%TYPE,
     cod_job employees.job_id%TYPE
    );
  
  cod_cautare employees.employee_id%TYPE := &cod_c;
  cod_stergere employees.employee_id%TYPE := &cod_s;
  angajat emp_record;
BEGIN
  SELECT employee_id, salary, job_id 
  INTO angajat.cod_angajat, angajat.salariu, angajat.cod_job 
  FROM employees 
  WHERE employee_id = cod_cautare;
  
  DBMS_OUTPUT.PUT_LINE(angajat.cod_angajat || ' ' || angajat.salariu || ' ' || angajat.cod_job);
  
  DELETE FROM emp_ysp
  WHERE employee_id = cod_stergere
  RETURNING employee_id, salary, job_id INTO angajat;
  DBMS_OUTPUT.PUT_LINE(angajat.cod_angajat || ' ' || angajat.salariu || ' ' || angajat.cod_job);
  
  ROLLBACK;
END;
/

-- Exercitiul 3
DECLARE
  angajat_1 emp_ysp%ROWTYPE;
  angajat_2 emp_ysp%ROWTYPE;
  
  cod_angajat_1 emp_ysp.employee_id%TYPE := &cod_1;
  cod_angajat_2 emp_ysp.employee_id%TYPE := &cod_2;
BEGIN 
  DELETE FROM emp_ysp
  WHERE employee_id = cod_angajat_1
  RETURNING employee_id, first_name, last_name, email, phone_number,
      hire_date, job_id, salary, commission_pct, manager_id, department_id
  INTO angajat_1;
  DBMS_OUTPUT.PUT_LINE(angajat_1.first_name || ' ' || angajat_1.last_name);
  
  DELETE FROM emp_ysp
  WHERE employee_id = cod_angajat_2
  RETURNING employee_id, first_name, last_name, email, phone_number,
      hire_date, job_id, salary, commission_pct, manager_id, department_id
  INTO angajat_2;
  DBMS_OUTPUT.PUT_LINE(angajat_2.first_name || ' ' || angajat_2.last_name);
  ROLLBACK;
END;
/

-- Exercitiul 4

DECLARE 
  TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  tablou tablou_indexat;
BEGIN 
  FOR i in 1 .. 10 LOOP
    tablou(i):=i;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Tabelul are '|| tablou.COUNT || ' elemente');
  FOR i in tablou.FIRST .. tablou.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Elementul ' || i || ' este ' || tablou(i));
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  
  FOR i in tablou.FIRST .. tablou.LAST LOOP
    IF i MOD 2 = 0 THEN
      tablou(i) := NULL;
    END IF;
  END LOOP;
  
  
  DBMS_OUTPUT.PUT_LINE('Tabelul are '|| tablou.COUNT || ' elemente');
  FOR i in tablou.FIRST .. tablou.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Elementul ' || i || ' este ' || tablou(i));
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  
  tablou.DELETE(tablou.FIRST);
  tablou.DELETE(5,7);
  tablou.DELETE(tablou.LAST);
  
  DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || tablou.FIRST || 
    ' si valoarea ' || NVL(tablou.FIRST,0));
  
  DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || tablou.LAST || 
    ' si valoarea ' || NVL(tablou.LAST,0));
  
  DBMS_OUTPUT.PUT_LINE('Tabelul are '|| tablou.COUNT || ' elemente');
  FOR i in tablou.FIRST .. tablou.LAST LOOP
    --DBMS_OUTPUT.PUT_LINE('Elementul ' || i || ' este ' || tablou(i));
    IF tablou.EXISTS(i) THEN DBMS_OUTPUT.PUT(nvl(tablou(i), 0)|| ' '); END IF;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  
  tablou.DELETE;
  DBMS_OUTPUT.PUT_LINE('Tabelul are '|| tablou.COUNT || ' elemente');
END;
/

SELECT * FROM emp_ysp WHERE employee_id = 101;
