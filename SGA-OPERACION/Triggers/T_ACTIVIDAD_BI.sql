CREATE OR REPLACE TRIGGER OPERACION.T_ACTIVIDAD_BI
BEFORE INSERT
ON OPERACION.actividad
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN

--   Select max(codact) into tmpVar from actividad;
   SELECT SQ_ACTIVIDAD_COD.NEXTVAL  INTO tmpVar FROM dual;
   IF :NEW.codact IS NULL THEN
      :NEW.codact := tmpVar;
   END IF;

-- Para validar el preciario de pex
   IF :NEW.codpex IS NULL THEN
   	  :NEW.codpex := :NEW.codact;
	END IF;
END;
/



