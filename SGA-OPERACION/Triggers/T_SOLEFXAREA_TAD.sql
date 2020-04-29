CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_TAD
  AFTER DELETE ON SOLEFXAREA
  REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

/******************************************************************************
   NAME:       T_SOLEFXAREA_TAD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        31/07/2008  Hèctor Huamàn.     1. Created this trigger.
******************************************************************************/
DECLARE
ln_idlog number(8);
BEGIN

   select nvl(max(id),0)+1 into ln_idlog from solefxarea_log_ef;
   insert into solefxarea_log_ef(id,codef, usulog, feclog,estado,area)
        values ( ln_idlog,:old.codef ,user, sysdate, 'RETIRADO',:old.area);

   --JMAP
   update operacion.estsolef_dias_utiles set flg_valido = 0
   where codef = :old.codef and codarea = :old.area;

   --JMAP

END;
/



