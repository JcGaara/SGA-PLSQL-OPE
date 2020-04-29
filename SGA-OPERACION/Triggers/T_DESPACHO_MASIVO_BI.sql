CREATE OR REPLACE TRIGGER OPERACION.T_DESPACHO_MASIVO_BI
  BEFORE INSERT
  on OPERACION.DESPACHO_MASIVO
  for each row
declare
ln_id_trs NUMBER(10);
begin
   if :new.id_trs is null then
       select sq_despacho_masivo1.nextval into ln_id_trs from DUAL;
       :new.id_trs := ln_id_trs;
   end if;
end;
/



