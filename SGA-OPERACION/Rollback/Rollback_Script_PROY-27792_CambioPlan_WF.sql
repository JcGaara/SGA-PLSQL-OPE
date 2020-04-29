--Rollback
declare
  ln_tarea    number;
  ln_tareadef number;
  ln_tareapos varchar2(200);
begin
  --actualizar pos_tarea de la tarea padre HFC (altas Claro)
  select tarea
    into ln_tareadef
    from opewf.tareawfdef
   where descripcion = 'Cambio de Plan JANUS'
     and wfdef = 1286;

  select replace(pos_tareas, ';' || ln_tareadef, '')
    into ln_tareapos
    from opewf.tareawfdef
   where descripcion = 'Asignar Número Telefónico CP'
     and wfdef = 1286;

  select tarea
    into ln_tarea
    from opewf.tareawfdef
   where descripcion = 'Asignar Número Telefónico CP'
     and wfdef = 1286;
     
  update opewf.tareawfdef set pos_tareas = ln_tareapos where tarea = ln_tarea;
  
  update opewf.tareadef set pre_proc = '' where tareadef = 1020;

  --Eliminar definicion de la tarea
  delete from opewf.tareawfdef
   where descripcion = 'Cambio de Plan JANUS'
   and wfdef = 1286;
   
  delete from opewf.tareadef
   where descripcion = 'Cambio de Plan JANUS';
   
  commit;
end;
/
