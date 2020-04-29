-- Create table
create table OPERACION.TAB_REC_CSR_LTE_DET
(
  idprocess_det    NUMBER not null,
  idprocess        NUMBER,
  bouquet          VARCHAR2(10),
  numserie_tarjeta VARCHAR2(30),
  fecreg           DATE,
  usureg           VARCHAR2(30),
  fecmod           DATE,
  usumod           VARCHAR2(30)
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
create unique index OPERACION.IDX_TAB_CSR_LTE_DET on OPERACION.TAB_REC_CSR_LTE_DET (IDPROCESS_DET)
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
alter table OPERACION.TAB_REC_CSR_LTE_DET
  add constraint PK_TAB_CSR_LTE_DET primary key (IDPROCESS_DET);
alter table OPERACION.TAB_REC_CSR_LTE_DET
  add constraint FK_IDPROCESS_CSR_LTE_CAB foreign key (IDPROCESS)
  references OPERACION.TAB_REC_CSR_LTE_CAB (IDPROCESS);
