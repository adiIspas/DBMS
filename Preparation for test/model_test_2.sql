-- Model test laborator 2

-- Exercitiul 1
CREATE OR REPLACE PROCEDURE p_1_a(suprafata_1 parcela_ysp.suprafata%TYPE,
  suprafata_2 parcela_ysp.suprafata%TYPE) AS
  
  TYPE nume IS TABLE OF parcela_ysp.nume_parcela%TYPE;
  v_nume nume := nume();
  
  CURSOR my_cursor IS
    SELECT nume_parcela
    FROM (
          SELECT COUNT(cod_teren) nr, cod_teren, nume_parcela
          FROM parcela_ysp JOIN cultura ON id_parcela = cod_parcela
          WHERE suprafata >= suprafata_1 AND suprafata <= suprafata_2 AND (TO_CHAR(data_cultura,'YYYY') >= 2011 AND TO_CHAR(data_cultura,'YYYY') <= 2012)
          GROUP BY cod_teren, nume_parcela
          )
    WHERE nr >= 2;
  
  BEGIN
    OPEN my_cursor;
    FETCH my_cursor BULK COLLECT INTO v_nume;
    
    IF v_nume.COUNT() = 0 THEN
      DBMS_OUTPUT.PUT_LINE('NU EXISTA DATE');
    END IF;
    
    FOR i IN v_nume.FIRST .. v_nume.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(v_nume(i));
    END LOOP;
    
    CLOSE my_cursor;
END;

DROP PROCEDURE p_1_a;

BEGIN
  p_1_a(1,5);
END;

-- Exercitiul 2
ALTER TABLE produs_agricol_ysp
ADD numar_parcele NUMBER(4);

UPDATE produs_agricol_ysp tab_1
SET numar_parcele = (SELECT COUNT(cod_parcela)
                     FROM cultura_ysp JOIN produs_agricol_ysp ON cod_produs = id_produs
                     WHERE id_produs = tab_1.id_produs
                     GROUP BY id_produs);

CREATE OR REPLACE TRIGGER trig_2_b_ysp
  BEFORE INSERT OR DELETE ON cultura_ysp FOR EACH ROW
  BEGIN
  IF INSERTING THEN
    UPDATE produs_agricol_ysp
    SET numar_parcele = numar_parcele + 1
    WHERE :NEW.cod_produs = id_produs;
  ELSE
    UPDATE produs_agricol_ysp
    SET numar_parcele = numar_parcele - 1
    WHERE :OLD.cod_produs = id_produs;
  END IF;
END;

INSERT INTO cultura_ysp VALUES (118,100,100,SYSDATE);
DELETE FROM cultura_ysp
WHERE id_cultura = 118 AND ROWNUM <= 1;

SELECT * 
FROM cultura_ysp ORDER BY 1;

SELECT * 
FROM produs_agricol_ysp ORDER BY 1;