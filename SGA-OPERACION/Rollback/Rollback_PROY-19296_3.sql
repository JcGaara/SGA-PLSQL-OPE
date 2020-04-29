delete from operacion.OPEDD
 where TIPOPEDD in
       (select TIPOPEDD from tipopedd where abrev = 'RANG_TEMP_SLA');

delete from operacion.tipopedd
 where DESCRIPCION = 'RANGOS DE TIEMPO SLA'
   and ABREV = 'RANG_TEMP_SLA';
commit;