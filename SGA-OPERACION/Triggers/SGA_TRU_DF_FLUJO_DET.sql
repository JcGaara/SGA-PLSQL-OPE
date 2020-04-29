create or replace trigger operacion.sga_tru_df_flujo_det
before update
on operacion.sgat_df_flujo_det
referencing old as old new as new
for each row
begin
  :new.fludv_usumod   := user;
  :new.fludv_ipmod     := sys_context('userenv','ip_address');
  :new.fludv_pcmod     := sys_context('userenv', 'terminal');
  :new.fludd_fecmod   := sysdate;
end;
/