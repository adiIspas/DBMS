-- Simulare TEST 1

-- Exercitiul 1
-- A)
create or replace PROCEDURE NUME_PARCELE_YSP(
  suprafata1 parcela.suprafata%TYPE,
  suprafata2 parcela.suprafata%TYPE
) AS
  TYPE tab_parcela IS TABLE OF 
      parcela.nume_parcela%TYPE;
  v_parcele tab_parcela := tab_parcela();
  BEGIN
  
  SELECT p.nume_parcela
  BULK COLLECT INTO v_parcele
  FROM
  (
    SELECT COUNT(cod_produs) nr, cod_produs
    FROM produs_agricol pa JOIN 
      cultura c ON pa.id_produs = c.cod_produs
    GROUP BY cod_produs
    
  ) a JOIN cultura cult ON 
          a.cod_produs = cult.cod_produs
      JOIN parcela p ON 
          p.id_parcela = cult.cod_parcela
  WHERE p.suprafata BETWEEN suprafata1 AND 
                    suprafata2
                AND a.nr >= 2
        AND to_char(cult.data_cultura, 'YYYY') BETWEEN
      '2011' AND '2012';
  
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 
          'Nu sunt parcele');
  END IF;
  
  FOR idx IN v_parcele.FIRST..v_parcele.LAST LOOP
    IF v_parcele.EXISTS(idx) THEN
      DBMS_OUTPUT.PUT(nvl(v_parcele(idx), 'Fara nume') || ' ');
    END IF;
  END LOOP;
  
  DBMS_OUTPUT.NEW_LINE;
  
  
  END;
  
  /
  


-- B)
SET SERVEROUTPUT ON;

EXEC NUME_PARCELE_YSP(25,75);

-- C)
-- Inclus in A


-- Exercitiul 2
-- A)

CREATE TABLE teren_agricol_ysp AS (SELECT * FROM teren_agricol);
CREATE TABLE parcela_ysp AS (SELECT * FROM parcela);
CREATE TABLE produs_agricol_ysp AS (SELECT * FROM produs_agricol); 
CREATE TABLE cultura_ysp AS (SELECT * FROM cultura);

ALTER TABLE PRODUS_AGRICOL_YSP
ADD numar_parcele NUMBER(12);

SELECT * FROM PRODUS_AGRICOL_YSP;

-- B)


-- C)

--------------
-- Simulare TEST 2
-- Exercitiul 1


-- Exercitiul 2