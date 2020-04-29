CREATE OR REPLACE TRIGGER OPERACION.T_TRANSACCIONES_FCO_BUI
   BEFORE UPDATE OR INSERT ON OPERACION.TRANSACCIONES_FCO
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
/********************************************************************************
     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     05/03/2010  Hector Huaman  M   REQ-94683: Creación
 ********************************************************************************/
BEGIN

   IF UPDATING THEN
      :NEW.FECMOD := SYSDATE;
      :NEW.USUMOD := USER;
   ELSIF INSERTING THEN
      :NEW.FECREG := SYSDATE;
      :NEW.USUREG := USER;
   END IF;
END;
/



