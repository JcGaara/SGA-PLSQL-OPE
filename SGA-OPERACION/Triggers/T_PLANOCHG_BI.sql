CREATE OR REPLACE TRIGGER OPERACION.T_PLANOCHG_BI
  BEFORE INSERT
  on OPERACION.PLANOCHG
  for each row

/******************************************************************************
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------

    1        15/10/2009  Jimmy Farfán    REQ 104404: Tareas de GIS para
                                         Inventario de Planos
*******************************************************************************/
declare
ln_idseq NUMBER(10);
begin
--   if :new.idalm is null then
       select sq_planochg.nextval into ln_idseq from DUAL;
       :new.idseq := ln_idseq;
--   end if;
end;
/



