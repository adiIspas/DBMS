-- Laboratorul 6

-- Exericitiul 1
CREATE OR REPLACE TRIGGER trig_1_ysp  
  BEFORE INSERT OR UPDATE OR DELETE ON emp_ysp
  BEGIN
    IF TO_CHAR(SYSDATE,'D') = 7 
      OR TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20 THEN
      RAISE_APPLICATION_ERROR(-20001,'Tabelul nu poate fi actualizat');
    END IF;
END;

UPDATE emp_ysp
SET department_id = 50
WHERE employee_id = 198;

SELECT * 
FROM emp_ysp;

DROP TRIGGER trig_1_ysp;

-- Exercitiul 2
CREATE OR REPLACE TRIGGER trig_2_ysp
  BEFORE UPDATE OF salary ON emp_ysp FOR EACH ROW
  BEGIN
    IF :NEW.salary < :OLD.salary THEN 
      RAISE_APPLICATION_ERROR(-20001,'Nu poti scadea salariul');
    END IF;
END;

UPDATE emp_ysp
SET salary = salary - 1;

DROP TRIGGER trig_2_ysp;

-- Exercitiul 3
CREATE TABLE job_grades_ysp AS (SELECT * FROM job_grades);

CREATE OR REPLACE FUNCTION getMinSal RETURN NUMBER IS
  salariu employees.salary%TYPE;
  BEGIN
    SELECT MIN(salary)
    INTO salariu
    FROM employees;
  RETURN salariu;
END;

CREATE OR REPLACE FUNCTION getMaxSal RETURN NUMBER IS
  salariu employees.salary%TYPE;
  BEGIN
    SELECT MAX(salary)
    INTO salariu
    FROM employees;
  RETURN salariu;
END;

CREATE OR REPLACE TRIGGER trig_3_ysp
  BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_ysp FOR EACH ROW
  DECLARE
    min_sal employees.salary%TYPE := getMinSal;
    max_sal employees.salary%TYPE := getMaxSal;
  BEGIN
    IF :OLD.grade_level = 1 AND (min_sal < :NEW.lowest_sal OR max_sal > :NEW.highest_sal) THEN
      RAISE_APPLICATION_ERROR(-20001,'Nu se poate modifica');
    ELSIF :OLD.grade_level = 7 AND (min_sal < :NEW.lowest_sal OR max_sal > :NEW.highest_sal) THEN
      RAISE_APPLICATION_ERROR(-20001,'Nu se poate modifica');
    END IF;
END;

UPDATE job_grades_ysp
SET lowest_sal = 3000 
WHERE grade_level = 1; 

UPDATE job_grades_ysp 
SET highest_sal = 20000 
WHERE grade_level = 7;

DROP TRIGGER trig_3_ysp;

-- Exercitiul 4
CREATE TABLE info_dept_ysp (
  id NUMBER(4) PRIMARY KEY,
  nume_dept VARCHAR2(30),
  plati NUMBER(10)
  );

CREATE OR REPLACE FUNCTION getTotalSalary(cod_departament employees.department_id%TYPE) RETURN NUMBER IS
  salariuTotal NUMBER(10);
  BEGIN
    SELECT SUM(salary)
    INTO salariuTotal
    FROM employees
    WHERE department_id = cod_departament;
  RETURN salariuTotal;
END;

CREATE OR REPLACE PROCEDURE adaugaInformatii(id_deptr employees.department_id%TYPE, 
  nume_deptr departments.department_name%TYPE) IS
  BEGIN
    INSERT INTO info_dept_ysp VALUES (id_deptr, nume_deptr, getTotalSalary(id_deptr));
END;

DECLARE
  TYPE id_dept IS TABLE OF employees.department_id%TYPE; 
  TYPE nume_dept IS TABLE OF departments.department_name%TYPE;
  
  v_id_dept id_dept := id_dept();
  v_nume_dept nume_dept := nume_dept();
  
  CURSOR my_cursor IS
    SELECT DISTINCT e.department_id, d.department_name 
    FROM employees e JOIN departments d ON (e.department_id = d.department_id);
BEGIN
  DBMS_OUTPUT.PUT_LINE(getTotalSalary(20));
  
  OPEN my_cursor;
    FETCH my_cursor BULK COLLECT INTO v_id_dept, v_nume_dept;
  CLOSE my_cursor;
  
  FOR idx IN v_id_dept.FIRST .. v_id_dept.LAST LOOP
    adaugaInformatii(v_id_dept(idx),v_nume_dept(idx));
  END LOOP;
END;
/

CREATE OR REPLACE TRIGGER trig_4_ysp
  BEFORE INSERT OR UPDATE OR DELETE OF salary ON emp_ysp FOR EACH ROW
  BEGIN  
    IF INSERTING THEN
      UPDATE info_dept_ysp
      SET plati = plati + :NEW.salary;
    ELSIF UPDATING THEN
      UPDATE info_dept_ysp
      SET plati = plati - :OLD.salary + :NEW.salary;
    ELSE
      UPDATE info_dept_ysp
      SET plati = plati - :OLD.salary;
    END IF;
END;

SELECT * FROM info_dept_ysp ORDER BY 1;

INSERT 
  INTO emp_ysp (employee_id, last_name, email, hire_date, job_id, salary, department_id) 
  VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 10);

UPDATE emp_ysp 
  SET salary = salary + 1000 
  WHERE employee_id = 200;

DELETE FROM emp_ysp 
  WHERE employee_id = 207;

DROP TRIGGER trig_4_ysp;

-- Exercitiul 6
CREATE OR REPLACE TRIGGER trig_6_ysp
  BEFORE DELETE ON emp_ysp
  BEGIN
    IF USER = UPPER('grupa43') THEN
      RAISE_APPLICATION_ERROR(-20001,'Nu poti sterge');
    END IF;
END;

DROP TRIGGER trig_6_ysp;