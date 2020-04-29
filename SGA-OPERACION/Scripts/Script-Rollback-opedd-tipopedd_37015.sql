-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC');

delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'ASOCIATED_INCIDENCE_CNOC';

delete from operacion.tipopedd 
  where abrev = 'ASOCIATED_INC_INTER_CNOC';

commit;

