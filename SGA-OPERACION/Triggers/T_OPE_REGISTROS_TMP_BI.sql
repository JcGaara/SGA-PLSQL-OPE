CREATE OR REPLACE TRIGGER OPERACION.t_ope_registros_tmp_bi
  before insert on operacion.ope_registros_tmp
  for each row
declare
  ln_id number;
begin
  select operacion.SQ_ope_registros_tmp.Nextval into ln_id from dummy_ope;
  :new.IDSEQ := ln_id;
end;
/



