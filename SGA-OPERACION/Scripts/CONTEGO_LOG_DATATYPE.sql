alter table OPERACION.SGAT_LOGERR modify LOGERRC_NUMREGISTRO varchar2(15);
alter table OPERACION.SGAT_LOGERR modify LOGERRC_CODSOLOT varchar2(15);

create index OPERACION.ix_sgat_trxcontego on OPERACION.SGAT_TRXCONTEGO (trxn_codsolot)
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

  create index OPERACION.ix_sgat_logerr on OPERACION.SGAT_LOGERR (LOGERRC_CODSOLOT)
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


UPDATE OPERACION.SGAT_LOGERR
  SET LOGERRC_NUMREGISTRO = TRIM(LOGERRC_NUMREGISTRO),
	  LOGERRC_CODSOLOT    = TRIM(LOGERRC_CODSOLOT);
COMMIT
/