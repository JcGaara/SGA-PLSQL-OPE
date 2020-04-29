-- Create table
-- Create table
create table OPERACION.NUMERO_NOALINEADO
(
  ID_ALINEADO     NUMBER not null,
  TIPO_NOALINEADO VARCHAR2(10),
  COD_ID          NUMBER,
  NUMERO          VARCHAR2(30),
  TSERVICIO       VARCHAR2(30),
  OBSERVACION     VARCHAR2(500),
  CODUSU          VARCHAR2(25) default USER,
  FECUSU          DATE default SYSDATE
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.NUMERO_NOALINEADO
  add constraint ID_ALINEADO_PK primary key (ID_ALINEADO)
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
-- Create/Recreate indexes 
create index OPERACION.COD_ID_100 on OPERACION.NUMERO_NOALINEADO (COD_ID)
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
create index OPERACION.NUMERO_100 on OPERACION.NUMERO_NOALINEADO (NUMERO)
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
  