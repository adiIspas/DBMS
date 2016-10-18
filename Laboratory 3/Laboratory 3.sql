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

for contor in 0..10 loop -- REVERSE
DBMS_OUTPUT.PUT_LINE(contor);
end loop;

END;
/

<<bloc_1>>
declare
v1 number(10):=5;
begin
v1:=10;

<<bloc_2>>
declare
v1 varchar2(30);
begin
v1:='test';
DBMS_OUTPUT.PUT_LINE('Bloc 2 ' || v1 || ' ' || bloc_1.v1);
end;
DBMS_OUTPUT.PUT_LINE('Bloc 1 ' || v1 || ' ');
end;
/


------------- ||||||||||||||||||||| -------------


CREATE TABLE octombrie_isp(id number(10), data date);

DECLARE
v_nr number(10);
contor date := TO_DATE('01-10-2016','dd-mm-yyyy');
v_cod number(10);
BEGIN

loop
select count(*) 
into v_nr
from rental
where book_date like contor;

v_cod := contor - TO_DATE('01-10-2016','dd-mm-yyyy');

insert into octombrie_isp VALUES(v_cod, contor);
DBMS_OUTPUT.PUT_LINE('Data: ' || contor || ' Numar imprumuturi: ' || v_nr);
contor := contor + 1;
exit when contor > TO_DATE('31-10-2016','dd-mm-yyyy');
end loop;


END;
/

drop table octombrie_isp;