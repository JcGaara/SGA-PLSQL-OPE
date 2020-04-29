ALTER TABLE operacion.tipo_orden_adc 
ADD CONSTRAINT pk_tipo_orden_adc PRIMARY KEY (id_tipo_orden)
  USING INDEX 
  tablespace OPERACION_IDX;