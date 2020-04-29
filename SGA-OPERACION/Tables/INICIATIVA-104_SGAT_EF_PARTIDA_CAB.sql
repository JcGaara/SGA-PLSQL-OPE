-- Create table
create table OPERACION.SGAT_EF_PARTIDA_CAB
(
  efpcn_id      NUMBER(5) not null,
  efpcv_rfs_gis VARCHAR2(20),
  efpcn_estado  NUMBER(1) default 0 not null,
  efpcv_usureg  VARCHAR2(30) default USER not null,
  efpcd_fecreg  DATE default SYSDATE not null
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
/
