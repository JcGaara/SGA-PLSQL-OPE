CREATE OR REPLACE TRIGGER OPERACION.T_plantilla_traslado_BU
BEFORE UPDATE
ON OPERACION.plantilla_traslado
REFERENCING OLD AS OLD NEW AS NEW
  /********************************************************************
     REVISIONS:
     Ver        Date        Author           Description
     --------  ----------  --------------  ------------------------
     1.0       30/12/2009  Joseph Asencios   REQ 114000: Creación
  *********************************************************************/
FOR EACH ROW
DECLARE
BEGIN
  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;
END;
/



