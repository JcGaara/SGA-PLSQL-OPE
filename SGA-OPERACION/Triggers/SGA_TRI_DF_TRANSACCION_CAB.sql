create or replace trigger operacion.sga_tri_df_transaccion_cab
  before insert on operacion.sgat_df_transaccion_cab
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.trscn_idtrs is null then
  select operacion.SGASEQ_DF_TRANSACCION_CAB.nextval into :new.trscn_idtrs from dual;
  else
    select operacion.SGASEQ_DF_TRANSACCION_CAB.currval into maxid from dual;
    while (:new.trscn_idtrs > maxid) loop
      select operacion.SGASEQ_DF_TRANSACCION_CAB.nextval into :new.trscn_idtrs from dual;
      select operacion.SGASEQ_DF_TRANSACCION_CAB.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/