create or replace trigger operacion.sga_tri_df_expresion_logica
  before insert on operacion.sgat_df_expresion_logica
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.exlon_idexplog is null then
  select operacion.SGASEQ_DF_EXPRESION_LOGICA.nextval into :new.exlon_idexplog from dual;
  else
    select operacion.SGASEQ_DF_EXPRESION_LOGICA.currval into maxid from dual;
    while (:new.exlon_idexplog > maxid) loop
      select operacion.SGASEQ_DF_EXPRESION_LOGICA.nextval into :new.exlon_idexplog from dual;
      select operacion.SGASEQ_DF_EXPRESION_LOGICA.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/