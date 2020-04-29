CREATE OR REPLACE TRIGGER OPERACION.T_plantilla_traslado_BI
BEFORE INSERT
ON OPERACION.plantilla_traslado
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /********************************************************************
     REVISIONS:
     Ver        Date        Author           Description
     --------  ----------  --------------  ------------------------
     1.0       30/12/2009  Joseph Asencios   REQ 114000: Creación
  *********************************************************************/
DECLARE
begin
  IF :NEW.IDPLANTILLA IS NULL THEN
    SELECT SQ_IDPLANTILLA_TRAS.nextval INTO :NEW.IDPLANTILLA FROM DUAL;
  END IF;
END;
/



