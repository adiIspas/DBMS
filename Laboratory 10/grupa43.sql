BEGIN
  FOR i IN 1..24 LOOP
    EXECUTE IMMEDIATE 'DROP USER exam_:i CASCADE'
    USING  RETURNING BULK COLLECT INTO ;
  END LOOP;
END;

CREATE OR REPLACE PROCEDURE sterge_useri
sir VARCHAR(255);
BEGIN 
FOR i in 1..23 loop
sir := 'DROP USER exam' || i || 'cascade';
EXECUT IMEDIATE sir
END LOOP;

CALL sterge_useri();

CREATE OR REPLACE USER creaza_useri
sir VARCHAR(255);
BEGIN

FOR i in 1..24 loop
  sir := 'create user exam'||i||'identified by student';
end loop;
END;
/