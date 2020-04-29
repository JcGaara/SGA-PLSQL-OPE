ALTER TABLE operacion.sgat_df_proceso_servidor ADD CONSTRAINT pk_sgat_df_proceso_servidor PRIMARY KEY ( prosn_idservproceso )
USING INDEX 
  TABLESPACE OPERACION_IDX
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
