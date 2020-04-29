DROP TRIGGER OPERACION.SGATRI_SGAT_USU_DW;
DROP TRIGGER OPERACION.SGATRU_SGAT_USU_DW;

  -- Elimniar detalle de parametros
DELETE from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'AR_TIP_DIV');

-- Eliminar cabecera de parametros
DELETE from operacion.tipopedd 
  where abrev = 'AR_TIP_DIV';
  