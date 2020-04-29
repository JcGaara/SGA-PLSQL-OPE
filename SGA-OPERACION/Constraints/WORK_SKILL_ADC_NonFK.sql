ALTER TABLE operacion.work_skill_adc 
ADD CONSTRAINT pk_work_skill_adc PRIMARY KEY (id_work_skill) 
  USING INDEX 
  TABLESPACE OPERACION_IDX;
