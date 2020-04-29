CREATE OR REPLACE TRIGGER OPERACION.T_AGENDA_TAREAS_BI
  BEFORE INSERT
  on OPERACION.AGENDA_TAREAS
  for each row
/************************************************************
   REVISIONS:
   Ver        Date        Author           Description
   --------  ----------  --------------  ------------------------
   1.0       19/11/2009  Hector Huaman   REQ-92361:Consideraciones para TPI
***********************************************************/
declare
ln_idagenda NUMBER(10); --<1.0>
begin
 SELECT SQ_IDTAREA_WIMAX.NEXTVAL into :NEW.IDTAREA FROM DUAL;
--<1.0>
 select sq_agenda_Tareas.nextval into ln_idagenda from DUAL;
 :new.idagenda := ln_idagenda;
--</1.0>
end;
/



