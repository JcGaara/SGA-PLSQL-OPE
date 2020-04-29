CREATE OR REPLACE TRIGGER OPERACION.T_MOT_SOLUCION_BI
  before insert on OPERACION.MOT_SOLUCION
 for each row
declare
  ln_id number;
begin
  select nvl(max(MOT_SOLUCION.CODMOT_SOLUCION),0)+1 into ln_id from MOT_SOLUCION;
 :new.CODMOT_SOLUCION := ln_id;
 end;
/



