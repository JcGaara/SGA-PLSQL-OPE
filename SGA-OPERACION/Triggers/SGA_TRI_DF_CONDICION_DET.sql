create or replace trigger operacion.sga_tri_df_condicion_det
  before insert on operacion.sgat_df_condicion_det
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.condn_idseq is null then
  select operacion.SGASEQ_DF_CONDICION_DET.nextval into :new.condn_idseq from dual;
  else
    select operacion.SGASEQ_DF_CONDICION_DET.currval into maxid from dual;
    while (:new.condn_idseq > maxid) loop
      select operacion.SGASEQ_DF_CONDICION_DET.nextval into :new.condn_idseq from dual;
      select operacion.SGASEQ_DF_CONDICION_DET.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/