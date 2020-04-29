CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_CAB_BI
  before insert on OPERACION.OPE_INS_EQUIPO_CAB
  for each row
declare
  ln_id number;
begin
  select operacion.SQ_OPE_INS_EQUIPO_CAB.Nextval into ln_id from dummy_ope;
  :new.IDINS_EQUIPO := ln_id;
end;
/



