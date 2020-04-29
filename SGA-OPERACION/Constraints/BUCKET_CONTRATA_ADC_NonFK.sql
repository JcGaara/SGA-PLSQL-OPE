ALTER TABLE operacion.bucket_contrata_adc
  ADD CONSTRAINT pk_bucket_contrata_adc PRIMARY KEY (idbucket, codcon)
  USING INDEX 
  tablespace OPERACION_IDX;