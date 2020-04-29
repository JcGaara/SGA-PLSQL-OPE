-- ROLLBACK
delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'CVE_CP');
delete from operacion.tipopedd where ABREV='CVE_CP';

commit;
