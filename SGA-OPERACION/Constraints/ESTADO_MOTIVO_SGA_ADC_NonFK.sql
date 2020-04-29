ALTER TABLE OPERACION.ESTADO_MOTIVO_SGA_ADC
  ADD CONSTRAINT pk_estado_motivo_sga_adc PRIMARY KEY (id_tipo_orden, idestado_sga_origen, idmotivo_sga_origen, idestado_adc_destino, idmotivo_sga_destino)
  USING INDEX 
  tablespace OPERACION_IDX;
