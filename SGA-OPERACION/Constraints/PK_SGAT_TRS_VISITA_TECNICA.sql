alter table OPERACION.SGAT_TRS_VISITA_TECNICA
  add constraint PK_SGAT_TRS_VISITA_TECNICA primary key (TRSN_COD_ID, TRSN_CUSTOMER_ID, TRSV_CODSRV)
  using index 
  tablespace OPERACION_DAT
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