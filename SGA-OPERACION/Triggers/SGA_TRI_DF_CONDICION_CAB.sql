create or replace trigger operacion.sga_tri_df_condicion_cab
  before insert on operacion.sgat_df_condicion_cab
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.concn_idcondicion is null then
  select operacion.SGASEQ_DF_CONDICION_CAB.nextval into :new.concn_idcondicion from dual;
  else
    select operacion.SGASEQ_DF_CONDICION_CAB.currval into maxid from dual;
    while (:new.concn_idcondicion > maxid) loop
      select operacion.SGASEQ_DF_CONDICION_CAB.nextval into :new.concn_idcondicion from dual;
      select operacion.SGASEQ_DF_CONDICION_CAB.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/