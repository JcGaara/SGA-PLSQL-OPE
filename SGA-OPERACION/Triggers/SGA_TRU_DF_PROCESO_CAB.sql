create or replace trigger operacion.sga_tru_df_proceso_cab
before update
on operacion.sgat_df_proceso_cab
referencing old as old new as new
for each row
begin
  :new.procv_usumod   := user;
  :new.procv_ipmod     := sys_context('userenv','ip_address');
  :new.procv_pcmod     := sys_context('userenv', 'terminal');
  :new.procd_fecmod   := sysdate;
end;
/