create or replace trigger operacion.sga_tru_df_condicion_det
before update
on operacion.sgat_df_condicion_det
referencing old as old new as new
for each row
begin
  :new.condv_usumod   := user;
  :new.condv_ipmod     := sys_context('userenv','ip_address');
  :new.condv_pcmod     := sys_context('userenv', 'terminal');
  :new.condd_fecmod   := sysdate;
end;
/