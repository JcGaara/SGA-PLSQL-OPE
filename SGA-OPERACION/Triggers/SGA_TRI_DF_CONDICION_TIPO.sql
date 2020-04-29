create or replace trigger operacion.sga_tri_df_condicion_tipo
  before insert on operacion.sgat_df_condicion_tipo
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.contn_idtipocondicion is null then
  select operacion.SGASEQ_DF_CONDICION_TIPO.nextval into :new.contn_idtipocondicion from dual;
  else
    select operacion.SGASEQ_DF_CONDICION_TIPO.currval into maxid from dual;
    while (:new.contn_idtipocondicion > maxid) loop
      select operacion.SGASEQ_DF_CONDICION_TIPO.nextval into :new.contn_idtipocondicion from dual;
      select operacion.SGASEQ_DF_CONDICION_TIPO.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/