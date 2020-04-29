CREATE OR REPLACE TRIGGER OPERACION.SGATRI_SGAT_CONTROL_APP BEFORE INSERT
ON  OPERACION.SGAT_CONTROL_APP
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla OPERACION.SGAT_CONTROL_APP
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             14/02/2020     Cesar REngifo       Obtener datos para la tabla SGAT_CONTROL_APP

**********************************************************************************/
BEGIN
   IF :NEW.controln_id IS NULL THEN
      SELECT OPERACION.SGASEQ_SGAT_CONTROL_APP.NEXTVAL into :NEW.controln_id FROM DUAL;
   END IF;
END;
/