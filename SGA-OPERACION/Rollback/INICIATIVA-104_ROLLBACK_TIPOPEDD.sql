delete from OPERACION.OPEDD where TIPOPEDD IN (select TIPOPEDD from OPERACION.TIPOPEDD where abrev = 'TIPO_SEF_COSTEO');
delete from OPERACION.TIPOPEDD where abrev = 'TIPO_SEF_COSTEO';
/
