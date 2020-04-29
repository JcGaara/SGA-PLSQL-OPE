CREATE OR REPLACE TRIGGER OPERACION.T_MATRIZPRECIO_BI
BEFORE INSERT
ON OPERACION.MATRIZPRECIO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
declare
  ln_id number;
begin
  Select max(codigo) into ln_id
  from matrizprecio;
  If ln_id is null then
     ln_id := 0;
  End if;
  ln_id := ln_id + 1;
  :new.codigo := ln_id;
end T_MATRIZPRECIO_BI;
/



