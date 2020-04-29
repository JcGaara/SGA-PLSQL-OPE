-- Eliminar detalle de parametros
DELETE from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'AR_GRUPO_DEST');

COMMIT;