-- Laboratorul 3

-- Exercitiul 1
DECLARE
  v_nr NUMBER(4);
  v_nume departments.department_name%TYPE;
  CURSOR my_cursor IS
    SELECT d.department_name Nume, COUNT(e.employee_id) Angajati
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    GROUP BY d.department_name;
BEGIN
  OPEN my_cursor;
  
  LOOP 
    FETCH my_cursor INTO v_nume, v_nr;
    EXIT WHEN my_cursor%NOTFOUND;
    
    IF v_nr = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista angajati in departamentul ' || v_nume);
    ELSIF v_nr > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Exista ' || v_nr || ' angajati in departamentul ' || v_nume);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exista un angajat in departamentul ' || v_nume);
    END IF;
  END LOOP;
  
  CLOSE my_cursor;
END;
/

-- Exercitiul 2
DECLARE
  TYPE numar IS TABLE OF NUMBER(4);
  TYPE nume IS TABLE OF departments.department_name%TYPE;
  v_nume nume := nume();
  v_nr numar := numar();
  
  CURSOR my_cursor IS
    SELECT d.department_name Nume, COUNT(e.employee_id) Angajati
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    GROUP BY d.department_name;
BEGIN
  OPEN my_cursor;
  
  FETCH my_cursor BULK COLLECT INTO v_nume, v_nr;
    
  FOR i IN v_nume.FIRST .. v_nume.LAST LOOP
    IF v_nr(i) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista angajati in departamentul ' || v_nume(i));
    ELSIF v_nr(i) > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Exista ' || v_nr(i) || ' angajati in departamentul ' || v_nume(i));
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exista un angajat in departamentul ' || v_nume(i));
    END IF;
  END LOOP;
  
  CLOSE my_cursor;
END;
/

-- Exercitiul 3
DECLARE
  CURSOR my_cursor IS
    SELECT d.department_name Nume, COUNT(e.employee_id) Angajati
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    GROUP BY d.department_name;
BEGIN  
  FOR i IN my_cursor LOOP
    IF i.Angajati = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista angajati in departamentul ' || i.Nume);
    ELSIF i.Angajati > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Exista ' || i.Angajati || ' angajati in departamentul ' || i.Nume);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exista un angajat in departamentul ' || i.Nume);
    END IF;
  END LOOP;
END;
/

-- Exercitiul 5
DECLARE

  v_cod employees.employee_id%TYPE;
  v_nume employees.last_name%TYPE;
  v_nr NUMBER(4);
  CURSOR my_cursor IS
    SELECT e_1.employee_id, MAX(e_1.last_name), COUNT(*)
    FROM employees e_1 JOIN employees e_2 ON (e_2.manager_id = e_1.employee_id)
    GROUP BY e_1.employee_id
    ORDER BY 3 DESC;
BEGIN
  OPEN my_cursor;
  
  LOOP 
    FETCH my_cursor INTO v_cod, v_nume, v_nr;
    EXIT WHEN my_cursor%NOTFOUND OR my_cursor%ROWCOUNT > 3;
    
    DBMS_OUTPUT.PUT_LINE(v_nume || ' are ' || v_nr || ' angajati ');
  END LOOP;
  
  CLOSE my_cursor;
END;
/

-- Exercitul 8
DECLARE
 v_x NUMBER(4) := &p_x;
  v_nr NUMBER(4);
  v_nume departments.department_name%TYPE;
  CURSOR my_cursor(parametru NUMBER) IS
    SELECT d.department_name Nume, COUNT(e.employee_id) Angajati
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    GROUP BY d.department_name
    HAVING COUNT(*) > parametru;
BEGIN
  OPEN my_cursor(v_x);
  
  LOOP 
    FETCH my_cursor INTO v_nume, v_nr;
    EXIT WHEN my_cursor%NOTFOUND;
    
    IF v_nr = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista angajati in departamentul ' || v_nume);
    ELSIF v_nr > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Exista ' || v_nr || ' angajati in departamentul ' || v_nume);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exista un angajat in departamentul ' || v_nume);
    END IF;
  END LOOP;
  
  CLOSE my_cursor;
END;
/
    
-- Exercitiul 9
DECLARE 
  CURSOR my_cursor IS
    SELECT employee_id
    FROM emp_ysp
    WHERE to_char(hire_date,'YYYY') = '2000'
    FOR UPDATE OF salary NOWAIT;
BEGIN
  FOR i IN my_cursor LOOP
    UPDATE emp_ysp
    SET salary = salary + 1000
    WHERE CURRENT OF my_cursor;
  END LOOP;
END;
/

SELECT salary 
FROM emp_ysp
WHERE to_char(hire_date,'YYYY') = '2000';

ROLLBACK;

-- Exercitiul 10
SELECT e.last_name, department_name 
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE e.department_id IN (10,20,30,40);

-- Exercitiul 11
DECLARE
  TYPE emp_tip IS REF CURSOR;
  v_emp emp_tip;
  v_optiune NUMBER(4):=&p_optiune;
  v_rand employees%ROWTYPE;
BEGIN
  IF v_optiune = 1 THEN
    OPEN v_emp FOR SELECT * FROM employees;
  END IF;
  
  LOOP
    FETCH v_emp INTO v_rand; 
    EXIT WHEN v_emp%NOTFOUND; 
    DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
  END LOOP;
END;
/

-- Exercitiul 12
DECLARE 
  TYPE empref IS REF CURSOR; 
  v_emp empref; 
  v_nr INTEGER := &n; 
  v_rand employees%ROWTYPE;
BEGIN 
  OPEN v_emp FOR 'SELECT employee_id, salary, commission_pct ' || 'FROM employees WHERE salary > :bind_var' USING v_nr;
  
  LOOP
    FETCH v_emp INTO v_rand; 
    EXIT WHEN v_emp%NOTFOUND; 
    DBMS_OUTPUT.PUT_LINE(v_rand.employee_id);
  END LOOP;
END; 
/