
ALTER TABLE operacion.transaccion_ws_adc
DROP COLUMN codincidence;

ALTER TABLE operacion.tmp_capacidad
DROP COLUMN codincidence;

ALTER TABLE operacion.matriz_tystipsrv_tiptra_adc
DROP COLUMN con_cap_i;

-------
ALTER TABLE operacion.tiptrabajo
DROP COLUMN id_tipo_orden_ce;
   
ALTER TABLE operacion.TIPO_ORDEN_ADC
DROP COLUMN flg_Tipo;

ALTER TABLE  operacion.SUBTIPO_ORDEN_ADC
DROP COLUMN lineas ;
---- steve
ALTER TABLE operacion.inventario_env_adc
DROP COLUMN flg_tipo;

ALTER TABLE operacion.inventario_env_adc_log_err
DROP COLUMN flg_tipo;

ALTER TABLE operacion.inventario_envio_eta_err 
DROP COLUMN flg_tipo;

ALTER TABLE operacion.inventario_em_adc  
DROP COLUMN flg_Tipo;

DROP SEQUENCE operacion.seq_materiales_servicios_adc;
   
DROP TABLE operacion.parametro_incidence_adc;
DROP TABLE operacion.matriz_incidence_adc;
 
DROP TABLE OPERACION.MATERIALES_SERVICIOS_ADC;
DROP TABLE OPERACION.SERVICIO_MAT_ADC;
