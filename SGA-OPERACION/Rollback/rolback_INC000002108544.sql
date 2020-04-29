/* ******************** ******************** 
ROLLBACK CONFIGURACION MENSAJE
/* ******************** ******************** */
delete from atccorp.atcparameter where codparameter = 'MSJSGA8';
commit;
/