CREATE OR REPLACE FUNCTION
  DETERMINA_NR_ANGAJATI_YSP
	(oras locations.city%TYPE)
  RETURN NUMBER IS
  v_nr NUMBER(4);
  v_nr2 NUMBER(2);
  v_nr3 NUMBER(3);
BEGIN


  SELECT COUNT(*)
  INTO v_nr
  FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
	JOIN job_history jh ON jh.employee_id = e.employee_id
  WHERE LOWER(l.city) LIKE LOWER(oras)
  AND
  (
	SELECT COUNT(*)
	FROM job_history
	WHERE employee_id = e.employee_id
  ) >= 2;
 
  SELECT COUNT(*)
  INTO v_nr2
  FROM locations
  WHERE  LOWER(city) LIKE LOWER(oras);
 
  SELECT COUNT(*)
  INTO v_nr3
  FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
  WHERE LOWER(l.city) LIKE LOWER(oras);
 
  IF v_nr2 = 0 THEN
	RAISE_APPLICATION_ERROR(-20000,
  	'Nu exista orasul');
  END IF;
  IF v_nr3 = 0 THEN
	RAISE_APPLICATION_ERROR(-20001,
  	'Nu lucreaza angajati in orasul respectiv');
  END IF;
 
  RETURN v_nr;


END;
/


DECLARE


v_user info_ysp.utilizator%type := user;
v_data info_ysp.data%type := SYSDATE;
v_cmd info_ysp.comanda%type;
v_nr info_ysp.nr_linii%type;
v_err info_ysp.eroare%type;
v_oras locations.city%type := '&p_oras';


BEGIN


SELECT text
BULK COLLECT INTO v_cmd
FROM user_source
WHERE UPPER(name) LIKE 'DETERMINA_NR_ANGAJATI_SPR';


v_nr := DETERMINA_NR_ANGAJATI_YSP(v_oras);


IF v_nr = -2 THEN
  v_err := 'Nu exista orasul';
ELSIF v_nr = -1 THEN
  v_err := 'Nu lucreaza angajati in orasul respectiv';
ELSE
  v_err := 'Nu avem eroare';
END IF;



INSERT INTO info_ysp
VALUES(v_user, v_data, v_cmd, v_nr, v_err);


COMMIT;


END;
/