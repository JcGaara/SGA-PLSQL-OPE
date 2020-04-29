create or replace trigger operacion.sga_tri_df_proceso_det
  before insert on operacion.sgat_df_proceso_det
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.prodn_idseq is null then
  select operacion.SGASEQ_DF_PROCESO_DET.nextval into :new.prodn_idseq from dual;
  else
    select operacion.SGASEQ_DF_PROCESO_DET.currval into maxid from dual;
    while (:new.prodn_idseq > maxid) loop
      select operacion.SGASEQ_DF_PROCESO_DET.nextval into :new.prodn_idseq from dual;
      select operacion.SGASEQ_DF_PROCESO_DET.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/