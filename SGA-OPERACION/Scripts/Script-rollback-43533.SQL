DELETE OPEDD WHERE TIPOPEDD=(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV= 'PORTABILIDAD_MSG') ;
commit;
DELETE OPEDD WHERE TIPOPEDD=(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV= 'PORTABILIDAD_MSG_CP') ;
commit;