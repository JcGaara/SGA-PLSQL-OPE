create or replace trigger operacion.sga_tru_df_proceso_tipo
before update
on operacion.sgat_df_proceso_tipo
referencing old as old new as new
for each row
begin
  :new.protv_usumod   := user;
  :new.protv_ipmod     := sys_context('userenv','ip_address');
  :new.protv_pcmod     := sys_context('userenv', 'terminal');
  :new.protd_fecmod   := sysdate;
end;
/