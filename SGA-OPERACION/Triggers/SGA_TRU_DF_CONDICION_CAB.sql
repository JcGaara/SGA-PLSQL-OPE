create or replace trigger operacion.sga_tru_df_condicion_cab
before update
on operacion.sgat_df_condicion_cab
referencing old as old new as new
for each row
begin
  :new.concv_usumod   := user;
  :new.concv_ipmod     := sys_context('userenv','ip_address');
  :new.concv_pcmod     := sys_context('userenv', 'terminal');
  :new.concd_fecmod   := sysdate;
end;
/