-- Create table
create table OPERACION.OPE_CORREO_MAE
(
  IDCORREO  NUMBER not null,
  CORREO    VARCHAR2(200) not null,
  USUREG    VARCHAR2(30) default USER,
  FECREG    DATE default SYSDATE,
  USUMOD    VARCHAR2(30) default USER,
  FECMOD    DATE default SYSDATE,
  FLGESTADO NUMBER(1) default 1
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
-- Add comments to the columns 
comment on column OPERACION.OPE_CORREO_MAE.USUREG
  is 'Usuario que inserto el registro';
comment on column OPERACION.OPE_CORREO_MAE.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_CORREO_MAE.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_CORREO_MAE.FECMOD
  is 'Fecha que se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_CORREO_MAE
  add constraint PK_IDCORREO primary key (IDCORREO)
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
