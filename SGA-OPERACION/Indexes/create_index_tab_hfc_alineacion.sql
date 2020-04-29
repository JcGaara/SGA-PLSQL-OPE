-- Create/Recreate indexes 
create index OPERACION.IDX100_CUSTOMER_ID on OPERACION.TAB_HFC_ALINEACION (CUSTOMER_ID)
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
create index OPERACION.IDX100_NUMERO on OPERACION.TAB_HFC_ALINEACION (NUMERO)
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
create index OPERACION.IDX110_TAB_HFC on OPERACION.TAB_HFC_ALINEACION (CODINSSRV, FLG_UNICO)
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
create index OPERACION.IDX90_COD_ID on OPERACION.TAB_HFC_ALINEACION (CO_ID)
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
create index OPERACION.IDX90_CODINSSRV on OPERACION.TAB_HFC_ALINEACION (CODINSSRV)
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
create index OPERACION.IDX90_CODSOLOT on OPERACION.TAB_HFC_ALINEACION (CODSOLOT)
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
create index OPERACION.IDX90_CODSRV on OPERACION.TAB_HFC_ALINEACION (CODSRV)
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
create index OPERACION.IDX90_IDPRODUCTO on OPERACION.TAB_HFC_ALINEACION (IDPRODUCTO)
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
  create index OPERACION.IDX90_NUMERO_BSCS on OPERACION.TAB_HFC_ALINEACION (NUMERO_BSCS)
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
  create index OPERACION.IDX90_CUSTOMER on OPERACION.TAB_HFC_ALINEACION (CUSTOMER)
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
    create index OPERACION.IDX90_CICLO on OPERACION.TAB_HFC_ALINEACION (CICLO)
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
