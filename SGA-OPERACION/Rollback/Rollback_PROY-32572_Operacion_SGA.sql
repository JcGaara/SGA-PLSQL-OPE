ALTER table OPERACION.EF drop column efn_flag_ar;
COMMIT;

DROP table OPERACION.SGAT_USU_DW;
COMMIT;

  -- Elimniar detalle de parametros
DELETE from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'AR_TIPO_EVAL');

-- Eliminar cabecera de parametros
DELETE from operacion.tipopedd 
  where abrev = 'AR_TIPO_EVAL';


COMMIT;
/