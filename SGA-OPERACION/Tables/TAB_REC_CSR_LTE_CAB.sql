-- Create table
create table OPERACION.TAB_REC_CSR_LTE_CAB
(
  idprocess NUMBER not null,
  codsolot  NUMBER,
  tipo      VARCHAR2(1),
  fecreg    DATE,
  usureg    VARCHAR2(30),
  fecmod    DATE,
  usumod    VARCHAR2(30)
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
-- Create/Recreate indexes 
create unique index OPERACION.IDX_TAB_CSR_LTE_CAB on OPERACION.TAB_REC_CSR_LTE_CAB (IDPROCESS)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TAB_REC_CSR_LTE_CAB
  add constraint PK_TAB_CSR_LTE_CAB primary key (IDPROCESS);
