--ROLLBACK
delete from OPERACION.OPEDD    where TIPOPEDD in (select TIPOPEDD
                         from TIPOPEDD
                        WHERE DESCRIPCION = 'DIAS VENC.FECHA BAJA DEL SERV.'
                          AND ABREV = 'DIAS_VENC') ;

delete from OPERACION.TIPOPEDD
WHERE DESCRIPCION = 'DIAS VENC.FECHA BAJA DEL SERV.'
    AND ABREV = 'DIAS_VENC';
						  
commit;
