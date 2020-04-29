-- Eliminar detalle de parametros
DELETE from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'AR_TIPO_PRECIO');

-- Eliminar cabecera de parametros
DELETE from operacion.tipopedd 
  where abrev = 'AR_TIPO_PRECIO';

COMMIT;