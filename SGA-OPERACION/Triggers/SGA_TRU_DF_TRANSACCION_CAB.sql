create or replace trigger operacion.sga_tru_df_transaccion_cab
before update
on operacion.sgat_df_transaccion_cab
referencing old as old new as new
for each row
begin
  :new.trscv_usumod   := user;
  :new.trscv_ipmod     := sys_context('userenv','ip_address');
  :new.trscv_pcmod     := sys_context('userenv', 'terminal');
  :new.trscd_fecmod   := sysdate;
end;
/