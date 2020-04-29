-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd in 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'TIPTRA_ANULA_SOT_INST_WIMAX');

delete from operacion.opedd where tipopedd in 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'DIAS_ANULA_SOT_INST_WIMAX');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'TIPTRA_ANULA_SOT_INST_WIMAX';

delete from operacion.tipopedd 
  where abrev = 'DIAS_ANULA_SOT_INST_WIMAX';

-- Eliminar secuencia
drop sequence OPERACION.SQ_PROC_ANULA_SOT_WIMAX_INST;

-- Eliminar package
drop package BODY operacion.pq_cuspe_ope3;
drop package operacion.pq_cuspe_ope3;

commit;
/
