CREATE OR REPLACE TRIGGER OPERACION.T_MAESTRO_STOCK_MAT_BI
  BEFORE INSERT
  on OPERACION.MAESTRO_STOCK_MAT
  for each row
declare
ln_idalm NUMBER(10);
begin
   if :new.idalm is null then
       select sq_maestro_stock_mat.nextval into ln_idalm from DUAL;
       :new.idalm := ln_idalm;
   end if;
end;
/



