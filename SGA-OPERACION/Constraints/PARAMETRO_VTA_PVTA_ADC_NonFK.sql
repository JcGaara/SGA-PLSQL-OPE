ALTER TABLE operacion.parametro_vta_pvta_adc 
ADD CONSTRAINT pk_codsolot_adc PRIMARY KEY (codsolot)
  USING INDEX 
  tablespace OPERACION_IDX;