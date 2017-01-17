-- ISPAS ADRIAN, GRUPA 343
-- Exercitiul 1
-- A - B - C) 
/*Creati o procedura stocata care primeste ca parametru numarul matricol al unui student si
afiseaza datele(numaul matricol, nume, prenume) si situatia examenelor (denumire materie, data
examenului, nota). In cazul in care nu exista nici un student cu numarul matricol dat se va
genera exceptia ”Numarul matricol este incorect”
*/
CREATE OR REPLACE PROCEDURE p1_a(nr_mat student.nr_matricol%TYPE) IS
  contine_date NUMBER(1):=0;
  
  nr_mat_student student.nr_matricol%TYPE;
  --v_nr_mat_student nr_mat_student  := nr_mat_student();
  
  nume_student student.nume%TYPE;
  --v_nume_student nume_student := nume_student();
  
  prenume_student student.prenume%TYPE;
  --v_prenume prenume_student := prenume_student();
  
  materie_student materie.denumire%TYPE;
  --v_materie_student materie_student := materie_student();
  
  data_examen_student examen.data_examen%TYPE;
  --v_data_examen_student data_examen_student := data_examen_student();
  
  nota_student nota.nota%TYPE;
  --v_nota_student nota_student := nota_student();
  
  exceptie EXCEPTION;
  
  CURSOR getDetailsStudent IS
  SELECT nr_matricol, nume, prenume, denumire, data_examen, nota
  --INTO v_nr_mat_student, v_nume_student, v_prenume, v_materie_student, v_data_examen_student, v_nota_student
  FROM
    (SELECT nr_matricol, nume, prenume 
      FROM student
      WHERE nr_matricol = nr_mat) tab_1 JOIN nota nt ON (tab_1.nr_matricol = nt.cod_student)
      JOIN examen exm ON (nt.cod_examen = exm.id_examen)
      JOIN materie mat ON (exm.cod_materie = mat.id_materie);
  
  BEGIN
    OPEN getDetailsStudent;
    
    LOOP
      FETCH getDetailsStudent INTO nr_mat_student, nume_student, prenume_student, 
        materie_student, data_examen_student, nota_student;
      
      IF getDetailsStudent%FOUND THEN
        IF contine_date = 0 THEN
          contine_date := 1;
        END IF;
      ELSE
        IF contine_date = 0 THEN
          RAISE exceptie;
        END IF;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE(nr_mat_student || ' ' || nume_student 
        || ' ' || prenume_student || ' ' || materie_student 
        || ' ' || data_examen_student || ' ' || nota_student);
      EXIT WHEN getDetailsStudent%NOTFOUND;
    END LOOP;
    CLOSE getDetailsStudent;
    
    EXCEPTION
      WHEN exceptie THEN
        RAISE_APPLICATION_ERROR(-20001,'Numar matricol este incorect');
    
    DBMS_OUTPUT.PUT_LINE('Done');
END;
/

SET SERVEROUTPUT ON;

DECLARE
  nr_mat student.nr_matricol%TYPE := &nr_cod;
BEGIN
  p1_a(nr_mat);
END;
/

-- Exercitiul 2
-- A)
CREATE OR REPLACE TRIGGER trg_2
  BEFORE INSERT ON examen FOR EACH ROW
  
  DECLARE
    credite_materie materie.credite%TYPE;
    exceptie EXCEPTION;
  
  BEGIN
    SELECT credite 
    INTO credite_materie
    FROM materie
    WHERE id_materie = :NEW.cod_materie;
    
    IF credite_materie >= 5 AND (TO_CHAR(:NEW.data_examen,'HH24') < 8 AND TO_CHAR(:NEW.data_examen,'HH24') > 12) THEN
      RAISE exceptie;
    ELSIF credite_materie < 5 AND (TO_CHAR(:NEW.data_examen,'HH24') < 14 AND TO_CHAR(:NEW.data_examen,'HH24') > 18) THEN
      RAISE exceptie;
    END IF;

    EXCEPTION
      WHEN exceptie THEN
        RAISE_APPLICATION_ERROR(-20002,'Examenul nu poate fi dat in intervalul mentionat');
END;
/

-- B)
INSERT INTO examen VALUES (9,1,SYSDATE,1); -- 1 CREDITE
INSERT INTO examen VALUES (10,2,SYSDATE,1); -- 6 CREDITE