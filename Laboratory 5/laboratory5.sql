-- colectii: tablouri indexate, imbricate si vectori - versiuni locale

DECLARE
  type t_ind is table of employees.salary%TYPE index by binary_integer;
  type t_imb is table of employees.employee_id%type;
  t t_ind;
  t2 t_imb;
  contor number(4):=1;  
BEGIN

select employee_id, salary
bulk collect into t2, t
from employees;

loop 
DBMS_OUTPUT.PUT_LINE('Angajatul cu codul ' || t2(contor) || ' are salariul ' || t(contor));
contor:=contor+1;
exit when contor + 100 > 207;
end loop;

END;
/
DECLARE
	TYPE info IS RECORD (cod employees.employee_id%TYPE,
    				 salariu  employees.salary%TYPE );
	TYPE t_imb IS TABLE OF info;
	t t_imb;
	contor NUMBER(4):=1;


BEGIN
SELECT employee_id, salary
BULK COLLECT INTO t
FROM employees;
LOOP
	DBMS_OUTPUT.PUT('Angajatul cu codul '||t(contor).cod||' are salariul '||t(contor).salariu||' ' );
	contor:=contor+1;
EXIT WHEN contor+100>207;
DBMS_OUTPUT.NEW_LINE;
END LOOP;
END;
/


DECLARE
	TYPE info IS RECORD (cod employees.employee_id%TYPE,
    				 salariu  employees.salary%TYPE );
	TYPE t_vec IS VARRAY(200) OF info;
	t t_VEC;
	contor NUMBER(4):=1;


BEGIN
SELECT employee_id, salary
BULK COLLECT INTO t
FROM employees;
LOOP
	DBMS_OUTPUT.PUT('Angajatul cu codul '||t(contor).cod||' are salariul '||t(contor).salariu||' ');
	contor:=contor+1;
EXIT WHEN contor+100>207;
DBMS_OUTPUT.NEW_LINE;
END LOOP;
END;
/

DECLARE
	TYPE linie IS VARRAY(10) OF NUMBER(2);
	TYPE matrice IS VARRAY(10) of linie;
	v linie:=linie(1,2,3);
	m matrice:=matrice(v);
BEGIN
m.EXTEND;
m(2):=linie(4,5,6);
FOR i IN m.FIRST..m.LAST LOOP
	FOR j IN m(i).FIRST..m(i).LAST LOOP
		DBMS_OUTPUT.PUT_LINE(m(i)(j) || ' ');
	END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
END LOOP;
END;
/

-- tablouri imbricate si vectori in varianta stocata
create or replace type t_imb_ysp is table of varchar2(12);
/

create table clienti_ysp(cod number(4), nume varchar2(25), telefon t_imb_ysp)
nested table telefon store as tip_telefon_ysp;

insert into clienti_ysp values (1,'Nume1',t_imb_ysp('072313323230','072343355'));
insert into clienti_ysp values (2,'Nume2',t_imb_ysp('072313321230','072243355'));

select * from clienti_ysp;

select a.cod, a.nume, b.*
from clienti_ysp a, table(a.telefon) b;

update table(select telefon from clienti_ysp where cod=2) a
set value(a)='01231654'
where column_value = '072313321230';

/*
1. Men?ine?i într-o colec?ie codurile celor mai prost plãti?i 5 angaja?i care nu câ?tigã comision. Folosind aceastã
colec?ie mãri?i cu 5% salariul acestor angaja?i. Afi?a?i valoarea veche a salariului, respectiv valoarea nouã a
salariului. 
*/

DECLARE 
	type info is record(cod employees.employee_id%type, salariu employees.salary%type);
	type t_imb is table of info;
	t t_imb;
  contor number(4):=1;
BEGIN
select *
BULK COLLECT INTO t
from  (select employee_id , salary from employees order by salary) 
where rownum <=5;

while contor + 100 < 207 loop
  DBMS_OUTPUT.PUT_LINE(t(contor).cod || ' ' || t(contor).salariu);
  DBMS_OUTPUT.PUT_LINE(t(contor).salariu + t(contor).salariu * 0.05);
  DBMS_OUTPUT.PUT_LINE('contor: ' || contor);
  contor:=contor+1;
end loop;

END;
/

DECLARE 
	type info is record(cod employees.employee_id%type, salariu 
          		employees.salary%type);
	type t_imb is table of info;
	t t_imb;
	contor number(4) := 1;
BEGIN
select *
BULK COLLECT INTO t
from  (select employee_id , salary from employees where commission_pct is null order by salary) 
where rownum <=5 ;
WHILE contor <= 5 LOOP
	DBMS_OUTPUT.PUT_LINE(t(contor).cod || ' ' || t(contor).salariu || ' ' || (t(contor).salariu + t(contor).salariu*0.05) );
	contor := contor + 1;
END LOOP;
END;
/


create or replace type tip_orase_ysp is table of varchar2(255);
/

create table excursii_ysp
(
  cod_excursie number(4),
  denumire varchar2(20),
  orase tip_orase_ysp
)
nested table orase store as orase_excursii_ysp;
/

INSERT INTO excursii_ysp
VALUES(1, 'marte', tip_orase_ysp('musk', 'spacex', 'tesla'));
INSERT INTO excursii_ysp
VALUES(2, ‘marte’, tip_orase_ysp(‘PAYPAL’, ‘x-city’));
INSERT INTO excursii_ysp
VALUES(3, ‘pluto’, tip_orase_ysp(‘mickey’, ‘mouse’));
INSERT INTO excursii_ysp
VALUES(4, ‘B12’, tip_orase_ysp(‘new city’, ‘london-12’, ‘dubay-b-12’));
INSERT INTO excursii_ysp
VALUES(5, ‘california’, tip_orase_ysp(‘miami’, ‘san francisco’, ‘palo alto’));

