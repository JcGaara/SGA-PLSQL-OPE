DELETE FROM operacion.parametro_det_adc WHERE abreviatura = 'FLG_ORDEN_OT';
DELETE FROM operacion.parametro_det_adc WHERE abreviatura = 'GESTIONAR_ORDEN_SGA';
DELETE FROM operacion.parametro_det_adc WHERE abreviatura = 'RESPUESTA_ERROR';
DELETE FROM operacion.parametro_det_adc WHERE abreviatura = '69122';
DELETE FROM operacion.parametro_cab_adc WHERE abreviatura = 'DISPONIBILIDAD_CAPACIDAD';
DELETE FROM operacion.parametro_cab_adc WHERE abreviatura = 'CREAR_OT_WF';
DELETE FROM operacion.parametro_cab_adc WHERE abreviatura = 'WARNING_BUCKET_ERROR';

COMMIT;
/