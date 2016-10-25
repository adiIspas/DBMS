DECLARE
v_nume member.last_name%type:='&p_nume';
v_nr number(4):=0;
v_nr2 v_nr%type;

BEGIN
select count(member_id)
into v_nr
from member
where upper(last_name) like upper(v_nume);

if v_nr2 = 0 then
  DBMS_OUTPUT.PUT_LINE('Nu exista membru cu numele introdus');
elsif v_nr2 = 1 then
  select count(distinct title_id)
  into v_nr
  from member m join rental r on(r.member_id=m.member_id)
  where upper(last_name) like upper(v_nume);
  DBMS_OUTPUT.PUT_LINE('Membrul cu numele '||v_nume||' a imprumutat '|| v_nr||'filme');
  else
  DBMS_OUTPUT.PUT_LINE('Nu a imprumutat');
  END IF;
END;
/


DECLARE
v_nume member.last_name%type:='&p_nume';
v_nr number(4):=0;
v_discount member_isp.discount%type;
v_total number(4);

BEGIN
select count(member_id)
into v_nr
from member
where upper(last_name) like upper(v_nume);

if v_nr2 = 0 then
  DBMS_OUTPUT.PUT_LINE('Nu exista membru cu numele introdus');
elsif v_nr2 = 1 then
  select count(distinct title_id)
  into v_nr
  from member m join rental r on(r.member_id=m.member_id)
  where upper(last_name) like upper(v_nume);
  END IF;
  select count(*)
  into v_total
  from title;
  v_discount :=
  CASE
    when v_nr > 0.7*v_total then 0.1
    when v_nr > 0.5*v_total then 0.05
    when v_nr > 0.25*v_total then 0.03
    else 0
  END;
END;
/

CREATE TABLE member_isp
AS SELECT * FROM member;

alter table member_isp
add Discount number(3,2);

update member_dmu
set Discount = v_discount
where lower(last_name) like lower(v_nume);

set echo off;


declare 
type rec is record(cod employees.employee_id%type, nume employees.last_name%type, salariu employees.salary%type);
v1 rec;
begin
select employee_id, last_name, salary
into v1
from employees
where last_name = '&p_nume';
DBMS_OUTPUT.PUT_LINE(v1.cod||' '||v1.nume||' '||v1.salariu);
end;
/

declare 
v1 employees%rowtype;
begin
select *
into v1
from employees
where last_name = '&p_nume';
DBMS_OUTPUT.PUT_LINE(v1.employee_id||' '||v1.last_name||' '||v1.salary);
end;
/

declare
type tablou_indexat is table of number(5) index by binary_integer;
t tablou_indexat;
contor number(3):=1;
begin
loop

t(contor):=contor;
contor:=contor+1;
exit when contor > 10;

end loop;

for contor in t.first..t.last loop
DBMS_OUTPUT.PUT_LINE(t(contor));
end loop;
end;
/