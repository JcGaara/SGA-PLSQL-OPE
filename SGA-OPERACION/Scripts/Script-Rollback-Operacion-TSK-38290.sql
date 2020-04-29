-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'TIP_INCIDENCE');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'TIP_INCIDENCE';

-- Eliminar package
drop package BODY atccorp.pq_notifica_usuario;
drop package atccorp.pq_notifica_usuario;

commit;
/
