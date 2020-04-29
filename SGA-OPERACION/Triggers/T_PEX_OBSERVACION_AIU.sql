CREATE OR REPLACE TRIGGER OPERACION.T_PEX_OBSERVACION_AIU
AFTER INSERT OR UPDATE
ON OPERACION.PEX_OBSERVACION
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       T_PEX_OBSERVACION_AIU
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/07/2006             1. Created this trigger.
******************************************************************************/
BEGIN

P_WF_OBSERVACIONES_PEX (:NEW.codsolot, 547,:NEW.observacion, :NEW.idobserv);


END T_PEX_OBSERVACION_AIU;
/



