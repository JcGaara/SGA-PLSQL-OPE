-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'NOTIFICA_INCIDENCIA');


-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'NOTIFICA_INCIDENCIA';
commit;
/
