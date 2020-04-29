CREATE OR REPLACE TRIGGER AUDITORIA.APPTRI_LOG_AUDIT BEFORE INSERT
ON  AUDITORIA.APP_LOG_AUDIT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla Log Auditoria
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             23/12/2019     Cesar Rengifo      Obtener datos para la tabla APP_LOG_AUDIT

**********************************************************************************/
BEGIN
   IF :NEW.LOGN_ID IS NULL THEN
      SELECT APPSEQ_LOG_AUDIT.NEXTVAL into :NEW.LOGN_ID FROM DUAL;
   END IF;
END;
/