-- Model test laborator 1

-- Exercitiul 1
CREATE OR REPLACE PROCEDURE p_1_a(cat IN produs_agricol_ysp.categorie%TYPE) IS
  v_nume produs_agricol_ysp.nume_produs%TYPE;
  
  CURSOR my_cursor IS
    SELECT nume_produs
    FROM
      (SELECT id_produs, COUNT(cod_parcela) nr
        FROM
        (SELECT id_produs, cod_parcela, data_cultura 
         FROM produs_agricol_ysp pa JOIN cultura cult ON (pa.id_produs = cult.cod_produs)
         WHERE to_char(cult.data_cultura,'YYYY') >= '2011' AND LOWER(pa.categorie) = LOWER(cat))
         GROUP BY id_produs) tab_1 JOIN produs_agricol_ysp pr_ysp ON (tab_1.id_produs = pr_ysp.id_produs)
    WHERE tab_1.nr >= 2;
BEGIN
  OPEN my_cursor;
  LOOP
    FETCH my_cursor INTO v_nume;
      DBMS_OUTPUT.PUT_LINE(v_nume);
      v_nume := '';
    EXIT WHEN my_cursor%NOTFOUND;
  END LOOP;
  CLOSE my_cursor;
  
  IF SQL%NOTFOUND THEN
          RAISE_APPLICATION_ERROR(-20001,'Nu am gasit date');
  END IF;
END;

BEGIN
  p_1_a('Cereale');
END;

-- Exercitiul 2
ALTER TABLE teren_agricol_ysp
ADD suprafata_totala NUMBER(5);

UPDATE teren_agricol_ysp teren
SET suprafata_totala = (SELECT SUM(suprafata) FROM parcela_ysp WHERE teren.id_teren = cod_teren GROUP BY cod_teren);

SELECT * FROM teren_agricol_ysp;
SELECT * FROM parcela_ysp; 
SELECT SUM(suprafata), cod_teren FROM parcela_ysp GROUP BY cod_teren;

CREATE OR REPLACE TRIGGER tr_2_b_ysp
  BEFORE INSERT OR UPDATE OR DELETE OF suprafata ON parcela_ysp FOR EACH ROW
  BEGIN
    IF INSERTING THEN
      UPDATE teren_agricol_ysp
      SET suprafata_totala = suprafata_totala + :NEW.suprafata;
    ELSIF UPDATING THEN
      UPDATE teren_agricol_ysp
      SET suprafata_totala = suprafata_totala - :OLD.suprafata + :NEW.suprafata;
    ELSE
      UPDATE teren_agricol_ysp
      SET suprafata_totala = suprafata_totala - :OLD.suprafata;
    END IF;
END;

DROP TRIGGER tr_2_b_ysp;

DELETE FROM parcela_ysp
WHERE id_parcela = 100;

UPDATE parcela_ysp
SET suprafata = 60
WHERE id_parcela = 100;

INSERT INTO parcela_ysp VALUES(2000,'P20',50,100);

ROLLBACK;