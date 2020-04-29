-- Create table
create table OPERACION.WIMAX_ESCENARIOS
(
  COD_ESCE  NUMBER(5) not null,
  COD_WEBS  NUMBER(5),
  CABE_ESCE VARCHAR2(1000),
  PIE_ESCE  VARCHAR2(1000),
  ESTA_ESCE CHAR(1),
  COD_OPE   NUMBER,
  TECNOL    CHAR(1),
  FECUSU    DATE default SYSDATE not null,
  CODUSU    VARCHAR2(30) default user not null
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
alter table OPERACION.WIMAX_ESCENARIOS
  add constraint WIMAX_ESCENARIOS_PK primary key (COD_ESCE)
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
create index OPERACION.IDX_WIMAX_ESCENARIOS_01 on OPERACION.WIMAX_ESCENARIOS (COD_WEBS, TECNOL, COD_OPE)
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