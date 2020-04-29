-- Create table
create table OPERACION.OPE_LTE_ARCHIVO_DET
(
  idlote       NUMBER(10) not null,
  archivo      VARCHAR2(50) not null,
  bouquet      VARCHAR2(10) not null,
  serie        VARCHAR2(30),
  estado       VARCHAR2(10),
  mensaje      VARCHAR2(2000),
  flg_revision NUMBER(1) default 0,
  usureg       VARCHAR2(30) default USER not null,
  fecreg       DATE default SYSDATE not null,
  usumod       VARCHAR2(30) default USER not null,
  fecmod       DATE default SYSDATE not null
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
comment on table OPERACION.OPE_LTE_ARCHIVO_DET
  is 'Tabla donde se registra la seria de las tarjetas que seran incluidas dentro de cada uno de los archivos a enviar al conax. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de solicitudes al conax.';
-- Add comments to the columns 
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.idlote
  is 'Identificador del lote';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.archivo
  is 'nombre del archivo';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.bouquet
  is 'numero del bouquet';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.serie
  is 'Numero de seria de la tarjeta del deco';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.estado
  is 'OK,ERROR';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.mensaje
  is 'Mensaje descriptivo del error encontrado';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.flg_revision
  is '0: No requiere revisión, 1: Requiere revisión';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.fecreg
  is 'Fecha creacion del registro';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.usumod
  is 'Usuario modificacion del regsitro';
comment on column OPERACION.OPE_LTE_ARCHIVO_DET.fecmod
  is 'Fecha modificacion del registro';