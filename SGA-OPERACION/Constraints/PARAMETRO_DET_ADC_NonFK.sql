ALTER TABLE operacion.parametro_det_adc
  ADD CONSTRAINT pk_parametro_det_adc PRIMARY KEY (id_detalle)
  USING INDEX 
  tablespace OPERACION_IDX;
