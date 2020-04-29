--3. -Adicionar indices a la tabla inssrv  
create index OPERACION.IDX_INSSRV10 on OPERACION.INSSRV (NUMSLC, CODINSSRV)
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
create index OPERACION.IDX_INSSRV11 on OPERACION.INSSRV (ESTINSSRV, TIPINSSRV)
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