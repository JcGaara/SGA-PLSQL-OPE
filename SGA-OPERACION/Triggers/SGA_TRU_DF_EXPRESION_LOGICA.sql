create or replace trigger operacion.sga_tru_df_expresion_logica
before update
on operacion.sgat_df_expresion_logica
referencing old as old new as new
for each row
begin
  :new.exlov_usumod   := user;
  :new.exlov_ipmod     := sys_context('userenv','ip_address');
  :new.exlov_pcmod     := sys_context('userenv', 'terminal');
  :new.exlod_fecmod   := sysdate;
end;
/