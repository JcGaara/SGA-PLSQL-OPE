------------------------- RF 14: ACTUALIZACION CANTIDAD DE DECOS-------------------------------------------------------- 
DELETE FROM operacion.parametro_det_adc
 WHERE id_parametro IN
       (SELECT id_parametro
          FROM operacion.parametro_cab_adc
         WHERE abreviatura = 'HFC_ORDEN_SERVICIOS');
------------------------------------------------------------------------------------------------------------------------
DELETE FROM operacion.parametro_cab_adc
 WHERE abreviatura = 'HFC_ORDEN_SERVICIOS';
------------------------------------------------------------------------------------------------------------------------ 
DELETE FROM operacion.parametro_det_adc
 WHERE id_parametro IN
       (SELECT id_parametro
          FROM operacion.parametro_cab_adc
         WHERE abreviatura = 'HFCI_ORDEN_DECOS');
------------------------------------------------------------------------------------------------------------------------ 
DELETE FROM operacion.parametro_cab_adc
 WHERE abreviatura = 'HFCI_ORDEN_DECOS';
------------------------------------------------------------------------------------------------------------------------ 
UPDATE operacion.subtipo_orden_adc SET decos = NULL WHERE cod_subtipo_orden = 'DTHI2';
UPDATE operacion.subtipo_orden_adc SET decos = NULL WHERE cod_subtipo_orden = 'DTHI3';

DELETE FROM operacion.opedd
 WHERE codigon = 67
   AND abreviacion = 'masivo_analogico';

COMMIT;
/
