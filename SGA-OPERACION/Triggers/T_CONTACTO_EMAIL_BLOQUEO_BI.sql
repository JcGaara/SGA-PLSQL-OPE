CREATE OR REPLACE TRIGGER OPERACION.T_CONTACTO_EMAIL_BLOQUEO_BI
/*********************************************************************************************
     NOMBRE:            T_CONTACTO_EMAIL_BLOQUEO_BI
     PROPOSITO:
     REVISIONES:
     Ver        Fecha        Autor            Descripcion
     ---------  ----------  ---------------   -----------------------------------
     1.0       25/04/2011   Juan Ramos Pérez  REQ.157873 Mejoras en bloqueo/desbloqueo por FCO y conciliación de pagos por FCO
***********************************************************************************************/
BEFORE INSERT
ON OPERACION.CONTACTO_EMAIL_BLOQUEO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
   ln_id NUMBER(10);
BEGIN
   IF :NEW.IDCONTACTO IS NULL THEN
      SELECT OPERACION.SQ_CONTACTO_EMAIL_BLOQUEO.NEXTVAL
        INTO ln_id
        FROM DUAL;
      :NEW.IDCONTACTO := ln_id;
   END IF;
END;
/



