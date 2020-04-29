-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'RPT_DEMO_TAREA');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'RPT_DEMO_TAREA';

commit;
/
