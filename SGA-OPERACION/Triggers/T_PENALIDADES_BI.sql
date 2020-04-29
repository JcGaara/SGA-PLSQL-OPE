CREATE OR REPLACE TRIGGER OPERACION.T_PENALIDADES_BI
  BEFORE INSERT
  ON OPERACION.PENALIDADES
  FOR EACH ROW
BEGIN
   IF :NEW.idpenalidad IS NULL THEN
      SELECT NVL(MAX(idpenalidad),0)+1 INTO :NEW.idpenalidad FROM PENALIDADES;
   END IF;
EXCEPTION
WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20500,'ERROR AL GENERAR ID');
END;
/


