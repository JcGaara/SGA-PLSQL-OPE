create or replace trigger operacion.sga_tru_df_proceso_servidor
before update
on operacion.sgat_df_proceso_servidor
referencing old as old new as new
for each row
begin
  :new.prosv_usumod   := user;
  :new.prosv_ipmod     := sys_context('userenv','ip_address');
  :new.prosv_pcmod     := sys_context('userenv', 'terminal');
  :new.prosd_fecmod   := sysdate;
end;
/