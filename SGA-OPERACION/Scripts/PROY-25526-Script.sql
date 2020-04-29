--Script
declare
begin
  --actualizar tareas de workflows DTH
  update opewf.tareadef td 
  set td.chg_proc = 'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact'
  where td.tareadef in (1144);
  
  commit;
end;
/