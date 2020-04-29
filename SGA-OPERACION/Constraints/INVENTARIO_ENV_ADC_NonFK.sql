ALTER TABLE operacion.inventario_env_adc
  ADD CONSTRAINT pk_inventario_env_adc PRIMARY KEY (id_inventario)
  USING INDEX 
  TABLESPACE operacion_idx;
