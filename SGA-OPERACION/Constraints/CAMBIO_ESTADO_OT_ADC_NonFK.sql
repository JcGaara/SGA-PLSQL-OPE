ALTER TABLE operacion.cambio_estado_ot_adc
  ADD CONSTRAINT pk_cambio_estado_ot_adc PRIMARY KEY (secuencia)
  USING INDEX 
  tablespace OPERACION_IDX;