CREATE OR REPLACE TRIGGER OPERACION.T_TIPOPEDD_BI
 BEFORE INSERT ON OPERACION.TIPOPEDD
FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       02/02/2010  Antonio Lagos   Creacion, REQ 106908, asignacion de id
  ***********************************************************/
DECLARE
BEGIN
   if :new.tipopedd is null then
     select nvl(max(tipopedd),0) + 1 into :new.tipopedd from tipopedd;
   end if;
END;
/



