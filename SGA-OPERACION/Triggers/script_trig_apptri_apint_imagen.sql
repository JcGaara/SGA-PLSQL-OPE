CREATE OR REPLACE TRIGGER OPERACION.APPTRI_APINT_IMAGEN BEFORE INSERT
ON  OPERACION.SGAT_APINT_IMAGEN
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla OPERACION.SGAT_APINT_IMAGEN
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             10/01/2020    Cesar Rengifo      Obtener datos para la tabla SGAT_APINT_IMAGEN

**********************************************************************************/
BEGIN
   IF :NEW.apintn_idimagen IS NULL THEN
      SELECT OPERACION.APPSEQ_APINT_IMAGEN.NEXTVAL into :NEW.apintn_idimagen FROM DUAL;
   END IF;
END;
/