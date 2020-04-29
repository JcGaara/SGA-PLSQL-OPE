CREATE OR REPLACE TRIGGER OPERACION.T_PEX_OBSERVACION_BI
BEFORE INSERT
ON OPERACION.PEX_OBSERVACION
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       T_PEX_OBSERVACION_BI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/02/2006    VICTOR HUGO    1. Created this trigger.
******************************************************************************/
BEGIN
   if :new.idobserv is null then
   	  select nvl(max(idobserv), 0) + 1 into :new.idobserv from pex_observacion;
   end if;
END T_PEX_OBSERVACION_BI;
/



