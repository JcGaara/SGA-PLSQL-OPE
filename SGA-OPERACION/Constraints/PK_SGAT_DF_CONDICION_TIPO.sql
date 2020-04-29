ALTER TABLE operacion.sgat_df_condicion_tipo ADD CONSTRAINT pk_sgat_df_condicion_tipo PRIMARY KEY ( contn_idtipocondicion )
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
