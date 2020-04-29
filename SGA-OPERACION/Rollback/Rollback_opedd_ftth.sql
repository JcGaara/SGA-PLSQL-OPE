delete from operacion.opedd
 where codigon = '830'
   and tipopedd =
       (select tipopedd from tipopedd where abrev = 'TIPTRASISACTVP');

commit;
/