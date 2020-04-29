CREATE INDEX OPERACION.IDX_SGAT_TRS_VISITA_TEC_01 ON
    OPERACION.SGAT_TRS_VISITA_TECNICA (
        TRSN_COD_ID
    ASC )
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );