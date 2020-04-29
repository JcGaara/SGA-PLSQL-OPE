CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_DET_BI
  before insert on OPERACION.OPE_INS_EQUIPO_DET
  for each row
declare
  ln_id number;
begin
  select operacion.SQ_OPE_INS_EQUIPO_DET.Nextval into ln_id from dummy_ope;
  :new.IDINS_EQUIPO_DET := ln_id;

  update OPERACION.OPE_INS_EQUIPO_CAB
     set NUM_LINEAS_LIBRES = NUM_LINEAS_LIBRES - 1
   where IDINS_EQUIPO = :new.IDINS_EQUIPO;
end;
/



