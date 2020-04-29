create or replace trigger operacion.sga_tri_df_flujo_det
  before insert on operacion.sgat_df_flujo_det
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.fludn_idseq is null then
  select operacion.SGASEQ_DF_FLUJO_DET.nextval into :new.fludn_idseq from dual;
  else
    select operacion.SGASEQ_DF_FLUJO_DET.currval into maxid from dual;
    while (:new.fludn_idseq > maxid) loop
      select operacion.SGASEQ_DF_FLUJO_DET.nextval into :new.fludn_idseq from dual;
      select operacion.SGASEQ_DF_FLUJO_DET.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/