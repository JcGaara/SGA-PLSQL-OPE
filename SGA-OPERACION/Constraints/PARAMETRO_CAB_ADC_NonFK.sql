ALTER TABLE operacion.parametro_cab_adc
  ADD CONSTRAINT pk_parametro_cab_adc PRIMARY KEY (id_parametro)
  USING INDEX 
  tablespace OPERACION_IDX;