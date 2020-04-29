/*Eliminamos de la tabla constante*/
delete from operacion.constante o where o.constante = 'PROD_CLOUD_FAC';

/*Eliminimos parametros*/
delete from opedd o where  o.tipopedd in (select tipopedd from tipopedd where abrev = 'DATAV_ESTADO');

delete from opedd o where o.abreviacion = 'ESTINSPRD' and o.tipopedd in (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD');

DELETE FROM OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'TRANS_BILL') AND ABREVIACION = 'ESTPID';

delete from  tipopedd where abrev = 'DATAV_ESTADO';

/*Elimiamos el index*/
drop index OPERACION.IDX_SOLOTPTO_009;
commit;
/