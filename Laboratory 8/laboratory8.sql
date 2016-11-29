-- Subprograme stocate

CREATE OR REPLACE PROCEDURE afiseaza_salariu_ysp(nume employees.last_name%TYPE)
IS
v_salariu employees.salary%TYPE;
BEGIN
SELECT salary
INTO v_salariu
FROM employees
WHERE last_name=nume;
DBMS_OUTPUT.PUT_LINE('Salariatul '||nume||' are salariul '||v_salariu);

EXCEPTION
WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20000,'nu exista angajat'); 
--DBMS_OUTPUT.PUT_LINE('nu exista angajat');
WHEN TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR(-20001,'mai multi cu acelasi nume');
--DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acelasi nume');
WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002,'alta eroare');
--DBMS_OUTPUT.PUT_LINE('Alta eroare!');

END afiseaza_salariu_ysp;
/

-- modalitate apel
BEGIN
--afiseaza_salariu_ysp;
afiseaza_salariu_ysp('&p_nume');
END;
/

-- modalitate 2 apel
EXECUTE afiseaza_salariu_ysp('&p_nume');
EXECUTE afiseaza_salariu_ysp;

----

CREATE OR REPLACE FUNCTION afiseaza_salariu_ysp_f(nume employees.last_name%TYPE DEFAULT 'Bell') RETURN NUMBER
IS
v_salariu employees.salary%TYPE;
BEGIN
SELECT salary
INTO v_salariu
FROM employees
WHERE last_name=nume;
--DBMS_OUTPUT.PUT_LINE('Salariatul '||nume||' are salariul '||v_salariu);
RETURN v_salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN -20000; 
--RAISE_APPLICATION_ERROR(-20000,'nu exista angajat');
--DBMS_OUTPUT.PUT_LINE('nu exista angajat');
WHEN TOO_MANY_ROWS THEN 
RETURN -20001;
--RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu acelasi nume');
--DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acelasi nume');
WHEN OTHERS THEN 
RETURN -20002;

--RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
--DBMS_OUTPUT.PUT_LINE('Alta eroare!');
END afiseaza_salariu_ysp_f;
/


--modalitate apel
BEGIN
DBMS_OUTPUT.PUT_LINE(afiseaza_salariu_ysp_f);
DBMS_OUTPUT.PUT_LINE(afiseaza_salariu_ysp_f('&p_nume'));
END;
/

--modalitate2 apel
VARIABLE g_sal NUMBER;
EXECUTE :g_sal:=afiseaza_salariu_ysp_f('&p_nume');
EXECUTE :g_sal:=afiseaza_salariu_ysp_f;
PRINT g_sal;

--modalitate3 apel
SELECT afiseaza_salariu_ysp_f
FROM dual;


--modalitate4 apel folosind metoda CALL
VARIABLE g_sal2 NUMBER;
CALL afiseaza_salariu_ysp_f('&p_nume') INTO :g_sal2;
PRINT g_sal2


--- procedura locala
DECLARE

v_nume employees.last_name%TYPE:='&p_nume';


PROCEDURE afiseaza_salariu_ysp(nume employees.last_name%TYPE DEFAULT 'Bell')
IS
v_salariu employees.salary%TYPE;
BEGIN
SELECT salary
INTO v_salariu
FROM employees
WHERE last_name=nume;
DBMS_OUTPUT.PUT_LINE('Salariatul '||nume||' are salariul '||v_salariu);
EXCEPTION
WHEN NO_DATA_FOUND THEN 
RAISE_APPLICATION_ERROR(-20000,'nu exista angajat');
--DBMS_OUTPUT.PUT_LINE('nu exista angajat');
WHEN TOO_MANY_ROWS THEN 
RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu acelasi nume');
--DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acelasi nume');
WHEN OTHERS THEN 
RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
--DBMS_OUTPUT.PUT_LINE('Alta eroare!');
END afiseaza_salariu_ysp;


BEGIN
afiseaza_salariu_ysp(v_nume);
END;
/


--------


DECLARE
v_nume employees.last_name%TYPE:='&p_nume';
v_salariu employees.salary%TYPE;
PROCEDURE afiseaza_salariu_ysp(salariu OUT employees.salary%TYPE, nume employees.last_name%TYPE DEFAULT 'Bell')
IS
BEGIN
SELECT salary
INTO salariu
FROM employees
WHERE last_name=nume;
DBMS_OUTPUT.PUT_LINE('Salariatul '||nume||' are salariul '||salariu);
EXCEPTION
WHEN NO_DATA_FOUND THEN 
RAISE_APPLICATION_ERROR(-20000,'nu exista angajat');
--DBMS_OUTPUT.PUT_LINE('nu exista angajat');
WHEN TOO_MANY_ROWS THEN 
RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu acelasi nume');
--DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acelasi nume');
WHEN OTHERS THEN 
RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
--DBMS_OUTPUT.PUT_LINE('Alta eroare!');
END afiseaza_salariu_ysp;
BEGIN
afiseaza_salariu_ysp(v_salariu,v_nume);
END;
/


--modalitate apel
DECLARE
v_salariu employees.salary%TYPE;
BEGIN
afiseaza_salariu_ysp;
afiseaza_salariu_ysp(v_salariu,'&p_nume');
END;
/


--modalitate2 apel
VARIABLE g_sal2 NUMBER
EXECUTE afiseaza_salariu_ysp('&p_nume');
EXECUTE afiseaza_salariu_ysp;



----------------


CREATE OR REPLACE PROCEDURE afiseaza_salariu_ysp(salariu OUT employees.salary%TYPE, nume employees.last_name%TYPE DEFAULT 'Bell')
IS
BEGIN
SELECT salary
INTO salariu
FROM employees
WHERE last_name=nume;
DBMS_OUTPUT.PUT_LINE('Salariatul '||nume||' are salariul '||salariu);
EXCEPTION
WHEN NO_DATA_FOUND THEN 
RAISE_APPLICATION_ERROR(-20000,'nu exista angajat');
--DBMS_OUTPUT.PUT_LINE('nu exista angajat');
WHEN TOO_MANY_ROWS THEN 
RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu acelasi nume');
--DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acelasi nume');
WHEN OTHERS THEN 
RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
--DBMS_OUTPUT.PUT_LINE('Alta eroare!');
END afiseaza_salariu_ysp;
/

--modalitate apel
DECLARE
v_salariu employees.salary%TYPE;
BEGIN
afiseaza_salariu_ysp(v_salariu);
afiseaza_salariu_ysp(v_salariu,'&p_nume');
END;
/

--modalitate2 apel
VARIABLE g_sal2 NUMBER
EXECUTE afiseaza_salariu_ysp(:g_sal2,'&p_nume');
PRINT g_sal2


CREATE OR REPLACE PROCEDURE afiseaza_manager_ysp(cod IN OUT employees.employee_id%TYPE)
IS
BEGIN
SELECT manager_id INTO cod FROM employees WHERE employee_id = cod;
END;
/

DECLARE
v_cod employees.employee_id%TYPE := 105;
BEGIN
afiseaza_manager_ysp(v_cod);
DBMS_OUTPUT.PUT_LINE(v_cod);
END;
/

--- exercitii propuse
SELECT *
FROM USER_SOURCE
WHERE UPPER(NAME)='AFISEAZA_MANAGER_YSP';

CREATE OR REPLACE TYPE v_tab IS VARRAY(500) OF VARCHAR2(500);
/

CREATE TABLE info_ysp(utilizator varchar2(50), data DATE, comanda)

show errors