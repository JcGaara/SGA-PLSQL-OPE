create table OPERACION.SGAT_MOTOTSUB
(
  moton_codmotot        NUMBER not null,
  moton_submotot        NUMBER not null,
  motov_codgestion      VARCHAR2(10) not null,
  motov_descripcion     VARCHAR2(80),
  motov_descrip_notas   VARCHAR2(500),
  moton_tiptrs          NUMBER default 5,
  motov_usureg          VARCHAR2(30) default user not null,
  motod_fecreg          DATE default sysdate not null,
  motov_usumod          VARCHAR2(30) default user,
  motod_fecmod          DATE default sysdate,
  moton_tiptra          NUMBER(4),
  moton_codcase         NUMBER,
  moton_codtypeatention NUMBER(3),
  moton_estado         number
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
comment on column OPERACION.SGAT_MOTOTSUB.moton_codmotot
  is 'Código del Motivo de Post Venta';
comment on column OPERACION.SGAT_MOTOTSUB.moton_submotot
  is 'Código del SubMotivo de Post Venta';
comment on column OPERACION.SGAT_MOTOTSUB.motov_codgestion
  is 'Codigo de la Gestión de Venta ';
comment on column OPERACION.SGAT_MOTOTSUB.motov_descripcion
  is 'Descripción de SubMotivos';
comment on column OPERACION.SGAT_MOTOTSUB.motov_descrip_notas
  is 'Especificaciones  de SubMotivos';
comment on column OPERACION.SGAT_MOTOTSUB.moton_tiptrs
  is 'Tipo de Tiptrs';
comment on column OPERACION.SGAT_MOTOTSUB.motov_usureg
  is 'Usuario que registro';
comment on column OPERACION.SGAT_MOTOTSUB.motod_fecreg
  is 'Fecha que se registro';
comment on column OPERACION.SGAT_MOTOTSUB.motov_usumod
  is 'Usuario que  Modifico';
comment on column OPERACION.SGAT_MOTOTSUB.motod_fecmod
  is 'Fecha que se Modifico';
comment on column OPERACION.SGAT_MOTOTSUB.moton_tiptra
  is 'Código Tipo Trabajo';
comment on column OPERACION.SGAT_MOTOTSUB.moton_codcase
  is 'Código Tipo de caso';
comment on column OPERACION.SGAT_MOTOTSUB.moton_codtypeatention
  is 'Código tipo de Incidencia';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_MOTOTSUB
  add constraint PK_MOTOTSUB_MOTON_SUBMOTOT primary key (MOTON_SUBMOTOT)
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