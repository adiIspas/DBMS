insert into excursii_ysp values (1,'Europa',tip_orase_ysp('Roma','Paris','Madrid'));

insert into excursii_ysp values (2,'Asia',tip_orase_ysp('Tokyo','Seul'));

insert into excursii_ysp values (3,'America',tip_orase_ysp('New York', 'San Francisco','Boston','Los Angeles'));

insert into excursii_ysp values (4,'Insule exotice',tip_orase_ysp('Maldive','Hawaii','Madeira'));

insert into excursii_ysp values (5,'Romania',tip_orase_ysp('Brasov','Baia Mare'));

commit;


alter table excursii_ysp add status number(1);

update excursii_ysp
set status=1
where cod_excursie=3;

UPDATE TABLE(SELECT orase FROM excursii_ysp WHERE cod_excursie=&p_cod)e
SET VALUE(e)='Bucuresti'
WHERE COLUMN_VALUE='Sighisoara';

select e.*
from excursii_ysp a, table(SELECT orase FROM excursii_ysp WHERE cod_excursie=&p_cod)e
where cod_excursie =&p_cod;

update excursii_ysp
set orase=tip_orase_ysp('Bucuresti','Constanta','Brasov')
where cod_excursie = 5;



DECLARE
v_orase excursii_ysp.orase%TYPE;
v_nr NUMBER(3);
v_cod excursii_ysp.cod_excursie%TYPE;
i NUMBER(2):=1;
j NUMBER(2):=1;
BEGIN
SELECT COUNT(*)
INTO v_nr
FROM excursii_ysp;
LOOP
SELECT orase
INTO v_orase
FROM excursii_ysp
WHERE cod_excursie=j;
DBMS_OUTPUT.PUT(j||' '||v_orase.COUNT||' ');
i:=1;
LOOP
DBMS_OUTPUT.PUT(v_orase(i)||' ');
i:=i+1;
EXIT WHEN i>v_orase.LAST;
END LOOP;
DBMS_OUTPUT.NEW_LINE;
j:=j+1;
EXIT WHEN j>v_nr;
END LOOP;
END;
/



declare 

cursor d is select department_id, department_name
from departments;
cursor e is select department_id, last_name
from employees;

type t_imb is table of departments.department_name%type;
type t_imb2 is table of employees.last_name%type;
type t_imb3 is table of employees.department_id%type;
t t_imb;
t2 t_imb2;
t3 t_imb3;
t4 t_imb3;
i number(3):=1;
j number(3):=1;

begin

open d;
fetch d bulk collect into t3, t;

loop 
open e;
fetch e bulk collect into t4,t2;
j:=1;
DBMS_OUTPUT.PUT_LINE(t(i));
loop
if t3(i)=t4(j) then DBMS_OUTPUT.PUT_LINE(t2(j));
j:=j+1;
end if;
exit when e%notfound;
end loop;
close e;
i:=i+1;
exit when d%notfound;
end loop;

close d;


end;
/












