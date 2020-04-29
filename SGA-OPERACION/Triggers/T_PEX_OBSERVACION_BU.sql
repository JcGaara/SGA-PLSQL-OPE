CREATE OR REPLACE TRIGGER OPERACION.T_PEX_OBSERVACION_BU
BEFORE UPDATE
ON OPERACION.PEX_OBSERVACION
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       T_PEX_OPERACION_BU
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/02/2006             1. Created this trigger.
******************************************************************************/
BEGIN
   :NEW.FecUsuMod := SYSDATE;
   :NEW.CodUsuMod := USER;
END T_PEX_OPERACION_BU;
/



