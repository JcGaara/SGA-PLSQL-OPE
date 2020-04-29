grant select, insert, update, delete 
on OPERACION.INVENTARIO_ENV_ADC to WEBSERVICE;

GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.tmp_capacidad to webservice;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.transaccion_ws_adc to webservice;
GRANT SELECT ON operacion.parametro_cab_adc TO webservice;
GRANT SELECT ON operacion.parametro_det_adc TO webservice;
GRANT SELECT ON operacion.solot TO webservice;
GRANT SELECT ON operacion.agendamiento TO webservice;
GRANT SELECT ON operacion.sq_ope_ws_sgasap TO webservice;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.INVENTARIO_ENVIO_ETA_ERR to webservice;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.bucket_contrata_adc to webservice;
GRANT REFERENCES ON operacion.zona_adc TO marketing;

GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.zona_adc TO marketing;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.log_instalacion_equipos to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.transaccion_ws_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.LOG_ERROR_WS_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.INVENTARIO_EM_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.estado_motivo_sga_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.TIPO_ORDEN_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.dth_preasociacion_tmp to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.TMP_CAPACIDAD to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.INVENTARIO_ENV_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.INVENTARIO_ENVIO_ETA_ERR to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.INVENTARIO_ENV_ADC_LOG_ERR to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.VTATABCLI_HIS to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.zona_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.PARAMETRO_VTA_PVTA_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.estado_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.subtipo_orden_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.matriz_tystipsrv_tiptra_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.franja_horaria to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.cambio_estado_ot_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPERACION.WORK_SKILL_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.PARAMETRO_CAB_ADC to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.bucket_contrata_adc to r_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.parametro_det_adc to r_prod;
