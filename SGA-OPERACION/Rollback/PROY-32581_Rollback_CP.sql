-- DROP COLUMN TABLE
DROP TABLE OPERACION.log_config_equcom_cp;
-- DELETE
DELETE FROM  OPERACION.opedd  
WHERE codigon = 753 AND descripcion = 'HFC - CAMBIO DE PLAN' 
  AND tipopedd = 402 ;
COMMIT;
------------------------------------------------------------
ALTER TABLE OPERACION.TIPEQU DROP COLUMN TIPO_ABREV;
------------------------------------------------------------
---DETALLE
DELETE FROM operacion.opedd 
 WHERE TIPOPEDD = (SELECT tipopedd 
                     FROM operacion.tipopedd b 
                    where B.ABREV ='CONF_TIPO_DECOS');
---CABECERA
DELETE FROM OPERACION.TIPOPEDD
 WHERE ABREV = 'CONF_TIPO_DECOS';

 commit;
