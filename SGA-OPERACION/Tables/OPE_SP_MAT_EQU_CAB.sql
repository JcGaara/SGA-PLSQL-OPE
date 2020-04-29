-- Create table
create table OPERACION.OPE_SP_MAT_EQU_CAB
(
  IDSPCAB              NUMBER not null,
  ESTADO               NUMBER default 1,
  RESPONSABLE          VARCHAR2(30),
  DESCRIPCION          VARCHAR2(500),
  TEXTO_COMPLEMENTARIO VARCHAR2(2000),
  SOLICITANTE          VARCHAR2(30),
  AREA_SOLICITANTE     NUMBER(4),
  USUREG               VARCHAR2(30) default user not null,
  FECREG               DATE default SYSDATE not null,
  USUMOD               VARCHAR2(30) default user not null,
  FECMOD               DATE default SYSDATE not null,
  DOC                  NUMBER(10)
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
-- Add comments to the table 
comment on table OPERACION.OPE_SP_MAT_EQU_CAB
  is 'Tabla Cabecera de Materiales y equipo';
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.IDSPCAB
  is 'identificador';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.ESTADO
  is '1: activo ';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.RESPONSABLE
  is 'atendido por';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.DESCRIPCION
  is 'Descripcion';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.TEXTO_COMPLEMENTARIO
  is 'Texto complementario';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.SOLICITANTE
  is 'Solicitante';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.AREA_SOLICITANTE
  is 'Area Solicitante';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECREG
  is 'Fecha que se insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECMOD
  is 'Fecha que se modificó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.DOC
  is 'Id de Documento';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_SP_MAT_EQU_CAB
  add constraint PK_IDSPCAB primary key (IDSPCAB)
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