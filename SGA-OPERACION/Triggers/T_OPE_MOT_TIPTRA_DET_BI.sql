CREATE OR REPLACE TRIGGER OPERACION.T_OPE_MOT_TIPTRA_DET_BI
  before insert on OPERACION.OPE_MOT_TIPTRA_DET
 for each row
declare
  ln_id number;
begin
  select nvl(max(OPE_MOT_TIPTRA_DET.ID),0)+1 into ln_id from OPE_MOT_TIPTRA_DET;
 :new.ID := ln_id;
 end;
/



