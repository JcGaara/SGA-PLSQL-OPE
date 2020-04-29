----  Rollback Parametrizacion Estado de Fotos
DELETE FROM OPERACION.OPEDD D
 WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD
                       FROM OPERACION.TIPOPEDD T
                      WHERE T.ABREV = 'ESTADO_FOTO');
commit;
 
DELETE FROM OPERACION.TIPOPEDD D 
WHERE D.ABREV = 'ESTADO_FOTO'; 
commit;
/