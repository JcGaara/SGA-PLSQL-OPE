CREATE OR REPLACE TRIGGER OPERACION.T_MAESTRO_SERIES_EQU_BI
  BEFORE INSERT
  on OPERACION.MAESTRO_SERIES_EQU
  for each row
declare
ln_idalm NUMBER(10);
begin
--   if :new.idalm is null then
       select sq_maestro_Series_equ.nextval into ln_idalm from DUAL;
       :new.idalm := ln_idalm;
--   end if;
end;
/



