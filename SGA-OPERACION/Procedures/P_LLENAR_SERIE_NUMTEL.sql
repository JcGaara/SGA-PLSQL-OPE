CREATE OR REPLACE PROCEDURE OPERACION.P_LLENAR_SERIE_NUMTEL (serie IN CHAR) IS
TELEFONO  VARCHAR2(30);
BEGIN

FOR I IN 0..9999 LOOP

  TELEFONO := SERIE || LPAD( I , 4, '0' );

  INSERT INTO NUMTEL(NUMERO) VALUES (TELEFONO);

END LOOP;


END;
/


