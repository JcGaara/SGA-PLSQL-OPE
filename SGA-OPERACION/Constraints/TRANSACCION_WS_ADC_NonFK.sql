ALTER TABLE operacion.transaccion_ws_adc 
ADD CONSTRAINT pk_idtransaccion PRIMARY KEY (idtransaccion)
  USING INDEX 
  tablespace OPERACION_IDX;