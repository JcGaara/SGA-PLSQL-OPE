-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'MAIL_DTH');

delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_DTH');

delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'OPE_DTH');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where abrev = 'MAIL_DTH';

delete from operacion.tipopedd 
  where abrev = 'TV_DTH';

delete from operacion.tipopedd 
  where abrev = 'OPE_DTH';

commit;
/
