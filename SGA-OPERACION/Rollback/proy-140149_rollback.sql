DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH');
DELETE FROM OPERACION.TIPOPEDD WHERE abrev = 'MOTCANORDCH';
DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH');
DELETE FROM OPERACION.TIPOPEDD WHERE abrev = 'DATAGENDACH';
DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH');
DELETE FROM OPERACION.TIPOPEDD WHERE abrev = 'ESTVIAGECH';
DROP PACKAGE BODY OPERACION.PKG_APP_INSTALADOR;
DROP PACKAGE OPERACION.PKG_APP_INSTALADOR
/