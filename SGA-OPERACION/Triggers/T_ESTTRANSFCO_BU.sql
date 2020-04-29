CREATE OR REPLACE TRIGGER OPERACION.T_ESTTRANSFCO_BU
   BEFORE UPDATE  ON OPERACION.ESTTRANSFCO
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
/********************************************************************************
     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     05/03/2010  Hector Huaman  M   REQ-94683: Creación
 ********************************************************************************/
DECLARE
BEGIN
   :NEW.FECMOD := SYSDATE;
   :NEW.USUMOD := USER;
END;
/



