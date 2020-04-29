create or replace trigger operacion.sga_tri_df_proceso_cab
  before insert on operacion.sgat_df_proceso_cab
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.procn_idproceso is null then
  select operacion.SGASEQ_DF_PROCESO_CAB.nextval into :new.procn_idproceso from dual;
  else
    select operacion.SGASEQ_DF_PROCESO_CAB.currval into maxid from dual;
    while (:new.procn_idproceso > maxid) loop
      select operacion.SGASEQ_DF_PROCESO_CAB.nextval into :new.procn_idproceso from dual;
      select operacion.SGASEQ_DF_PROCESO_CAB.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/