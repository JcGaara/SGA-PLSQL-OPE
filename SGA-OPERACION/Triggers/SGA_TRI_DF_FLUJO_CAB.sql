create or replace trigger operacion.sga_tri_df_flujo_cab
  before insert on operacion.sgat_df_flujo_cab
  referencing old as old new as new
  for each row
declare
  maxid number;
begin
  if :new.flucn_idflujo is null then
  select operacion.SGASEQ_DF_FLUJO_CAB.nextval into :new.flucn_idflujo from dual;
  else
    select operacion.SGASEQ_DF_FLUJO_CAB.currval into maxid from dual;
    while (:new.flucn_idflujo > maxid) loop
      select operacion.SGASEQ_DF_FLUJO_CAB.nextval into :new.flucn_idflujo from dual;
      select operacion.SGASEQ_DF_FLUJO_CAB.currval into maxid from dual;
    end loop;
  end if;
exception
  when others then
    raise_application_error(-20500, 'ERROR AL GENERAR ID');
end;
/