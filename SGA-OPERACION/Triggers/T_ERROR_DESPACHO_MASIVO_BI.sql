CREATE OR REPLACE TRIGGER OPERACION.T_ERROR_DESPACHO_MASIVO_BI
  BEFORE INSERT
  on OPERACION.ERROR_DESPACHO_MASIVO
  for each row
declare
ln_id_error NUMBER(10);
begin
   if :new.id_error is null then
       select SQ_error_despacho_masivo.nextval into ln_id_error from DUAL;
       :new.id_error := ln_id_error;
   end if;
end;
/



