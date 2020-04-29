-- Create table
create table OPERACION.SGAT_EF_PARTIDA_DET
(
  efpdn_id       NUMBER(5) not null,
  efpdn_iddet    NUMBER(5) not null,
  efpdv_codpar   CHAR(15) not null,
  efpdn_cantidad NUMBER(5,2) not null
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
