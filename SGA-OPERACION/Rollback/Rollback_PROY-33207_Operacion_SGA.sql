  -- Elimniar detalle de parametros
DELETE from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'AR_TIPO_CANAL_VTA');

-- Eliminar cabecera de parametros
DELETE from operacion.tipopedd 
  where abrev = 'AR_TIPO_CANAL_VTA';

COMMIT;