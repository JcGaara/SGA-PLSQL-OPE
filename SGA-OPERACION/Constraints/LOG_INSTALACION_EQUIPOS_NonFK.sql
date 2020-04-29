ALTER TABLE operacion.log_instalacion_equipos 
ADD CONSTRAINT pk_log_instalacion_equipos PRIMARY KEY (message_id, idagenda)
  USING INDEX 
  TABLESPACE OPERACION_IDX;
