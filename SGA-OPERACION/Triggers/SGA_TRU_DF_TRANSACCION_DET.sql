create or replace trigger operacion.sga_tru_df_transaccion_det
before update
on operacion.sgat_df_transaccion_det
referencing old as old new as new
for each row
begin
  :new.trsdv_usumod   := user;
  :new.trsdv_ipmod     := sys_context('userenv','ip_address');
  :new.trsdv_pcmod     := sys_context('userenv', 'terminal');
  :new.trsdd_fecmod   := sysdate;
end;
/