create or replace trigger operacion.sga_tru_df_flujo_cab
before update
on operacion.sgat_df_flujo_cab
referencing old as old new as new
for each row
begin
  :new.flucv_usumod   := user;
  :new.flucv_ipmod     := sys_context('userenv','ip_address');
  :new.flucv_pcmod     := sys_context('userenv', 'terminal');
  :new.flucd_fecmod   := sysdate;
end;
/