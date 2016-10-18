SET SERVEROUTPUT ON
SET SERVEROUTPUT OFF

--UNDEFINE p_test

DECLARE
--v_test NUMBER(5) := &p_test;
--v_test2 VARCHAR(40) := '&p_test2';
v_cod departments.department_id%TYPE := &p_cod;
v_location_id departments.location_id%TYPE;
BEGIN 
--v_test := v_test + 25;
DBMS_OUTPUT.PUT_LINE('Test' || ' ' || v_test || ' ' || v_test2);

SELECT location_id
INTO v_location_id
FROM departments
WHERE department_id = v_cod;

DBMS_OUTPUT.PUT_LINE('Departamenul cu codu: ' || v_cod || ' are locatia ' || v_location_id);
END;
/

--- ||| ---

DECLARE
v_salariu employees.salary%type;
v_cod employees.employee_id%type := &p_cod2;
v_bonus number(10);

BEGIN
select salary
into v_salariu
from employees
where employee_id = v_cod;

if v_salariu > 10000 then v_bonus := 2000;
elsif v_salariu between 5000 and 10000 then v_bonus := 1000;
else v_bonus := 500;
end if;
DBMS_OUTPUT.PUT_LINE('Salariatul cu codul ' || v_cod || ' v-a primi un bonus de ' || v_bonus);
END;
/

--- ||| ---

DECLARE
v_salariu employees.salary%type;
v_cod employees.employee_id%type := &p_cod2;
v_bonus v_salariu%type;

BEGIN
select salary
into v_salariu
from employees
where employee_id = v_cod;

case
 when v_salariu > 10000 then v_bonus := 2000;
 when v_salariu between 5000 and 10000 then v_bonus := 1000;
 else v_bonus := 500;
end case;

--v_salariu := v_salariu + bonus;
DBMS_OUTPUT.PUT_LINE('Salariatul cu codul ' || v_cod || ' v-a primi un bonus de ' || v_bonus);
END;
/

--- ||| ---

DECLARE
v_salariu employees.salary%type;
v_cod employees.employee_id%type := &p_cod2;
v_bonus2 v_salariu%type;

BEGIN
select salary
into v_salariu
from employees
where employee_id = v_cod;

v_bonus2 := case
             when v_salariu > 10000 then 2000
             when v_salariu between 5000 and 10000 then 1000
             else 500
             end;
DBMS_OUTPUT.PUT_LINE('Salariatul cu codul ' || v_cod || ' v-a primi un bonus de ' || v_bonus2);
END;
/

 --- ||| ---
 
DECLARE
contor NUMBER:=10;
BEGIN
LOOP
contor := contor - 1;
DBMS_OUTPUT.PUT_LINE(contor);
exit when contor <= 0;
END LOOP;
END;
/


 --- ||| ---
 
DECLARE
contor NUMBER:=10;
BEGIN
while contor > 0 loop
contor := contor - 2;
DBMS_OUTPUT.PUT_LINE(contor);
END LOOP;
END;
/

 --- ||| ---
 
BEGIN

for contor in 0..10 loop
DBMS_OUTPUT.PUT_LINE(contor);
end loop;

END;
/