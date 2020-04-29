ALTER TABLE operacion.subtipo_orden_adc 
ADD CONSTRAINT pk_subtipo_orden_adc PRIMARY KEY (id_subtipo_orden)
  USING INDEX 
  tablespace OPERACION_IDX;
