CREATE OR REPLACE TRIGGER OPERACION.T_perfil_traslado_BI
BEFORE INSERT
ON OPERACION.perfil_traslado
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
  IF :NEW.CODPERFIL IS NULL THEN
    SELECT SQ_perfil_traslado_ID.nextval INTO :NEW.CODPERFIL FROM DUAL;
  END IF;
END;
/



