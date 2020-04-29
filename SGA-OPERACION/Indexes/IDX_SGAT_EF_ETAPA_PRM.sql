-- CREATE/RECREATE INDEXES 
CREATE INDEX OPERACION.IDX_SGAT_EF_ETAPA_PRM ON OPERACION.SGAT_EF_ETAPA_PRM (EFEPV_TRANSACCION)
  TABLESPACE OPERACION_DAT
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