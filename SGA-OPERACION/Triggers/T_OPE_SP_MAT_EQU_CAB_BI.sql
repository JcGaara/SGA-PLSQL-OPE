create or replace trigger OPERACION.T_OPE_SP_MAT_EQU_CAB_BI
  before insert on OPERACION.OPE_SP_MAT_EQU_CAB
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
  select operacion.SQ_OPE_SP_MAT_EQU_CAB.Nextval into ln_id from dummy_ope;
  :new.idspcab  := ln_id;
end;
/