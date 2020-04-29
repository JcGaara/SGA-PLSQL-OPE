create or replace trigger operacion.sga_tri_df_transaccion_det
  before insert on operacion.sgat_df_transaccion_det
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.trsdn_idseq is null then
  select operacion.sgaseq_df_transaccion_det.nextval into :new.trsdn_idseq from dual;
  else
    select operacion.sgaseq_df_transaccion_det.currval into maxid from dual;
    while (:new.trsdn_idseq > maxid) loop
      select operacion.sgaseq_df_transaccion_det.nextval into :new.trsdn_idseq from dual;
      select operacion.sgaseq_df_transaccion_det.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/