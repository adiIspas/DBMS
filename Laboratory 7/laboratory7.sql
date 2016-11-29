-- Ref cursor
-- Intro

DECLARE
TYPE refcursor IS REF CURSOR;
CURSOR v_dep IS SELECT department_name,
 CURSOR(SELECT last_name
 FROM employees e
WHERE e.department_id=d.department_id)
FROM departments d;
v_emp refcursor;
v_nume departments.department_name%type;
v_nume2 employees.last_name%TYPE;
BEGIN
OPEN v_dep;
LOOP
	FETCH v_dep INTO v_nume,v_emp;
EXIT WHEN v_dep%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_nume);
LOOP
	FETCH v_emp INTO v_nume2;
	EXIT WHEN v_emp%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE(v_nume2);
END LOOP;
DBMS_OUTPUT.PUT_LINE('-----');
END LOOP;
CLOSE v_dep;
END;
/


/*
1. Pentru fiecare job (titlu – care va fi afiºat o singurã datã) obþineþi lista angajaþilor (nume ºi
salariu) care lucreazã în prezent pe jobul respectiv. Trataþi cazul în care nu existã angajaþi care
sã lucreze în prezent pe un anumit job. Rezolvaþi problema folosind:
a. cursoare clasice
b. ciclu cursoare
c. ciclu cursoare cu subcereri
d. expresii cursor
*/

DECLARE
CURSOR v_job IS SELECT job_id, job_title
             FROM jobs;
             
CURSOR v_emp IS SELECT job_id, last_name, salary
             FROM employees;            

v_cod jobs.job_id%TYPE;
v_cod2 employees.job_id%TYPE;
v_titlu jobs.job_title%TYPE;
v_nume employees.last_name%TYPE;
v_salariu employees.salary%TYPE;

BEGIN

OPEN v_job;
--OPEN v_emp;
LOOP
  FETCH v_job INTO v_cod, v_titlu;
  EXIT WHEN v_job%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE(v_titlu);
  OPEN v_emp;
  LOOP 
    FETCH v_emp into v_cod2, v_nume, v_salariu;
    EXIT WHEN v_emp%NOTFOUND;
    IF v_cod = v_cod2 THEN
      DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_salariu || ' '  || v_emp%ROWCOUNT);
    END IF;
  END LOOP;
  CLOSE v_emp;
END LOOP;
CLOSE v_job;
END;
/


DECLARE 

TYPE refcursor IS REF CURSOR;

CURSOR v_job IS SELECT job_title,
			 CURSOR(SELECT last_name, salary
				   FROM employees e
				   WHERE e.job_id = j.job_id)
			 FROM jobs j;
v_emp refcursor;
v_titlu jobs.job_title%TYPE;
v_nume employees.last_name%TYPE;
v_salariu employees.salary%TYPE;
BEGIN


OPEN v_job;
LOOP


	FETCH v_job INTO v_titlu, v_emp;
	
	EXIT WHEN v_job%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE(v_titlu);


LOOP
		FETCH v_emp INTO  v_nume, v_salariu;
		EXIT WHEN v_emp%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_salariu || ' ' || v_emp%ROWCOUNT);
	END LOOP;
END LOOP;


CLOSE v_job;
END;
/




DECLARE 
TYPE refcursor IS REF CURSOR;

CURSOR v_job IS SELECT job_title,
			 CURSOR(SELECT last_name, salary, commission_pct
				   FROM employees e
				   WHERE e.job_id = j.job_id)
			 FROM jobs j;
v_emp refcursor;
v_titlu jobs.job_title%TYPE;
v_nume employees.last_name%TYPE;
v_salariu employees.salary%TYPE;
v_comision employees.commission_pct%TYPE;
v_nrTotalAngajati NUMBER(4):= 0;
v_venit NUMBER(10,2):= 0;
v_venitTotal NUMBER(11,2) := 0;
BEGIN

OPEN v_job;
LOOP

	FETCH v_job INTO v_titlu, v_emp;	
	EXIT WHEN v_job%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE(v_titlu);

LOOP
		FETCH v_emp INTO  v_nume, v_salariu, v_comision;
		EXIT WHEN v_emp%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_salariu || ' ' || v_emp%ROWCOUNT);
		v_nrTotalAngajati := v_nrTotalAngajati + 1;
		v_venit := v_venit + v_salariu * (1 + NVL(v_comision, 0));
	END LOOP;
	-- Am adaugat un if pentru a tratam cazul in care nu exista angajati pe jobul curent
	IF v_emp%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('nu are angajati');
	END IF;
	DBMS_OUTPUT.PUT_LINE('jobul ' || v_titlu || ' are ' || v_emp%ROWCOUNT || ' angajati');
	DBMS_OUTPUT.PUT_LINE('Suma totala a veniturilor pe jobul ' || v_titlu || ' este ' || v_venit || ' cu media ' || ROUND(v_venit / v_emp%ROWCOUNT,2));
	v_venitTotal := v_venitTotal + v_venit;
	v_venit := 0;
END LOOP;

CLOSE v_job;
DBMS_OUTPUT.PUT_LINE('Venitul total este ' || v_venitTotal || ' cu media ' || ROUND(v_venitTotal/v_nrTotalAngajati, 2));
END;
/