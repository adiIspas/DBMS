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

-- Exercitiul 5
DECLARE
  TYPE tablou_indexat IS TABLE OF emp_ysp%ROWTYPE INDEX BY BINARY_INTEGER;
  t tablou_indexat;
BEGIN
  DELETE FROM emp_ysp
  WHERE ROWNUM <= 2
  RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  BULK COLLECT INTO t;
  
  DBMS_OUTPUT.PUT_LINE(t(1).employee_id);
  DBMS_OUTPUT.PUT_LINE(t(2).employee_id);
  
  INSERT INTO emp_ysp VALUES t(1);
  INSERT INTO emp_ysp VALUES t(2);

  ROLLBACK;
  
END;
/

-- Exercitiul 6
DECLARE 
  TYPE tablou_imbricat IS TABLE OF NUMBER;
  tablou tablou_imbricat := tablou_imbricat();
BEGIN 
  FOR i in 1 .. 10 LOOP
     tablou.EXTEND; 
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

-- Exercitiul 7
DECLARE
  TYPE tablou_imbricat IS TABLE OF CHAR(1);
  tablou tablou_imbricat := tablou_imbricat('m','i','n','i','m');
  i INTEGER;
BEGIN 
    i := tablou.FIRST;
    WHILE i <= tablou.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(tablou(i));
      i := tablou.NEXT(i);
    END LOOP;
    
    DBMS_OUTPUT.NEW_LINE;
    
    i := tablou.LAST();
    WHILE i >= tablou.FIRST LOOP
      DBMS_OUTPUT.PUT_LINE(tablou(i));
      i := tablou.PRIOR(i);
    END LOOP;
    
    tablou.DELETE(2);
    tablou.DELETE(4);
    
    DBMS_OUTPUT.NEW_LINE;
    
    i := tablou.FIRST;
    WHILE i <= tablou.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(tablou(i));
      i := tablou.NEXT(i);
    END LOOP;
    
    DBMS_OUTPUT.NEW_LINE;
    
    i := tablou.LAST();
    WHILE i >= tablou.FIRST LOOP
      DBMS_OUTPUT.PUT_LINE(tablou(i));
      i := tablou.PRIOR(i);
    END LOOP;
END;
/

-- Exercitiul 8
DECLARE
  TYPE vector IS VARRAY(10) OF NUMBER;
  tablou vector := vector();
BEGIN
  FOR i in 1 .. 10 LOOP
     tablou.EXTEND; 
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
  
  --tablou.DELETE(tablou.FIRST);
  --tablou.DELETE(5,7);
  --tablou.DELETE(tablou.LAST);
  
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
  
  --tablou.DELETE;
  DBMS_OUTPUT.PUT_LINE('Tabelul are '|| tablou.COUNT || ' elemente');
END;
/

-- Exercitiul 9
  CREATE OR REPLACE TYPE subordonati_ysp IS VARRAY(10) OF NUMBER;
  
  CREATE TABLE manageri_ysp (
    cod_mgr NUMBER(10) PRIMARY KEY,
    nume VARCHAR2(20),
    lista subordonati_ysp
  );

DECLARE
  v_sub subordonati_ysp := subordonati_ysp(100,200,300);
  v_lista manageri_ysp.lista%TYPE;
BEGIN
  INSERT INTO manageri_ysp
  VALUES (1,'mgr 1',v_sub);
  
  SELECT lista
  INTO v_lista
  FROM manageri_ysp;  
  
  FOR i IN v_lista.FIRST .. v_lista.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(v_lista(i));
  END LOOP;
END;
/

-- Exercitiul 10
CREATE TABLE emp_test_ysp AS (SELECT employee_id, last_name FROM employees);

CREATE OR REPLACE TYPE tip_telefon_ysp_2 IS TABLE OF VARCHAR2(12);

ALTER TABLE emp_test_ysp
ADD (telefon tip_telefon_ysp_2)
NESTED TABLE telefon STORE AS tabel_telefon_ysp;

INSERT INTO emp_test_ysp VALUES (1,'TEST',tip_telefon_ysp_2('076','075'));

UPDATE emp_test_ysp
SET telefon = tip_telefon_ysp_2('077','078','0789')
WHERE employee_id = 1;

SELECT * FROM emp_test_ysp;

SELECT a.employee_id, b.*
FROM emp_test_ysp a, TABLE (a.telefon) b;











