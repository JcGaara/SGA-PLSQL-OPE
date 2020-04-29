create or replace trigger operacion.sga_tri_df_proceso_servidor
  before insert on operacion.sgat_df_proceso_servidor
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.prosn_idservproceso is null then
  select operacion.SGASEQ_DF_PROCESO_SERVIDOR.nextval into :new.prosn_idservproceso from dual;
  else
    select operacion.SGASEQ_DF_PROCESO_SERVIDOR.currval into maxid from dual;
    while (:new.prosn_idservproceso > maxid) loop
      select operacion.SGASEQ_DF_PROCESO_SERVIDOR.nextval into :new.prosn_idservproceso from dual;
      select operacion.SGASEQ_DF_PROCESO_SERVIDOR.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/