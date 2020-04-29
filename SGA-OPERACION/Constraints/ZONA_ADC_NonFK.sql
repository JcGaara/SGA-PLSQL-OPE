ALTER TABLE operacion.zona_adc 
ADD CONSTRAINT pk_idzona_adc PRIMARY KEY (idzona)
  USING INDEX 
  tablespace OPERACION_IDX;