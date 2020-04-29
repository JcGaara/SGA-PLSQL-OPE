create or replace trigger operacion.sga_tru_df_proceso_det
before update
on operacion.sgat_df_proceso_det
referencing old as old new as new
for each row
begin
  :new.prodv_usumod   := user;
  :new.prodv_ipmod     := sys_context('userenv','ip_address');
  :new.prodv_pcmod     := sys_context('userenv', 'terminal');
  :new.prodd_fecmod   := sysdate;
end;
/