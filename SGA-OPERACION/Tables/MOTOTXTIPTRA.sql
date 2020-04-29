-- Create table
create table OPERACION.MOTOTXTIPTRA
(
  IDMOTXTIP NUMBER not null,
  TIPTRA    NUMBER not null,
  CODMOTOT  NUMBER not null,
  USUREG    VARCHAR2(30) default user not null,
  FECREG    DATE default sysdate not null,
  USUMOD    VARCHAR2(30) default user,
  FECMOD    DATE default sysdate
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.MOTOTXTIPTRA
  is 'Motivo de Ot por tipo de trabajo';
-- Add comments to the columns 
comment on column OPERACION.MOTOTXTIPTRA.IDMOTXTIP
  is 'Id del Motivo de Ot por tipo de trabajo ';
comment on column OPERACION.MOTOTXTIPTRA.TIPTRA
  is 'Tipo de Trabajo';
comment on column OPERACION.MOTOTXTIPTRA.CODMOTOT
  is 'Motivo de Ot';
comment on column OPERACION.MOTOTXTIPTRA.USUREG
  is 'Usuario   que   insertó   el registro';
comment on column OPERACION.MOTOTXTIPTRA.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.MOTOTXTIPTRA.USUMOD
  is 'Usuario   que modificó   el registro';
comment on column OPERACION.MOTOTXTIPTRA.FECMOD
  is 'Fecha   que se   modificó el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOTOTXTIPTRA
  add constraint PK_MOTOTXTIPTRA primary key (IDMOTXTIP)
  using index 
  tablespace OPERACION_DAT ;
-- Create/Recreate indexes 
create unique index OPERACION.IDX_MOTOTXTIPTRA on OPERACION.MOTOTXTIPTRA (TIPTRA, CODMOTOT)
  tablespace OPERACION_DAT ;
-- Grant/Revoke object privileges 
grant delete on OPERACION.MOTOTXTIPTRA to R_PROD;