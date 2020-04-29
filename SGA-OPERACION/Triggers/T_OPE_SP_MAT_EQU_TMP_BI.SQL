create or replace trigger OPERACION.T_OPE_SP_MAT_EQU_TMP_BI
  before insert on OPERACION.OPE_SP_MAT_EQU_TMP
  for each row
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       16/09/2011  Tommy Arakaki   REQ 159960 - Requisicion Materiels y Equipos
  ***********************************************************/
declare
  ln_id number;
begin
  if :new.idsptmp is null then
    select nvl(max(idsptmp),0)+1 into ln_id
    from OPERACION.OPE_SP_MAT_EQU_TMP;

    :new.idsptmp  := ln_id;
  end if;
end;
/