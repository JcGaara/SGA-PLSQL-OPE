create or replace trigger operacion.sga_tru_df_condicion_tipo
before update
on operacion.sgat_df_condicion_tipo
referencing old as old new as new
for each row
begin
  :new.contv_usumod   := user;
  :new.contv_ipmod     := sys_context('userenv','ip_address');
  :new.contv_pcmod     := sys_context('userenv', 'terminal');
  :new.contd_fecmod   := sysdate;
end;
/