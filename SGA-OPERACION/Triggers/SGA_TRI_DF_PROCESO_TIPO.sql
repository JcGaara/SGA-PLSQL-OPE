create or replace trigger operacion.sga_tri_df_proceso_tipo
  before insert on operacion.sgat_df_proceso_tipo
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.protn_idtipoproceso is null then
  select operacion.SGASEQ_DF_PROCESO_TIPO.nextval into :new.protn_idtipoproceso from dual;
  else
    select operacion.SGASEQ_DF_PROCESO_TIPO.currval into maxid from dual;
    while (:new.protn_idtipoproceso > maxid) loop
      select operacion.SGASEQ_DF_PROCESO_TIPO.nextval into :new.protn_idtipoproceso from dual;
      select operacion.SGASEQ_DF_PROCESO_TIPO.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/