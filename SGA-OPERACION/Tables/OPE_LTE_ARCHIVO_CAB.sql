-- Create table
create table OPERACION.OPE_LTE_ARCHIVO_CAB
(
  idlote  NUMBER(10) not null,
  archivo VARCHAR2(50) not null,
  bouquet VARCHAR2(10) not null,
  estado  NUMBER(2),
  usureg  VARCHAR2(30) default USER not null,
  fecreg  DATE default SYSDATE not null,
  usumod  VARCHAR2(30) default USER not null,
  fecmod  DATE default SYSDATE not null
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
comment on table OPERACION.OPE_LTE_ARCHIVO_CAB
  is 'Tabla de cabecera de archivos. Cada archivo corresponde a un bouquete distinto contenido dentro del grupo de solicitudes incluidas en el lote que se esta procesando. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de solicitudes al conax.';
-- Add comments to the columns 
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.idlote
  is 'Identificador del lote del archivo';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.archivo
  is 'nombre del archivo';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.bouquet
  is 'numero del bouquete';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.estado
  is 'estado del archivo. 1: GENERADO, 2:ENVIADO_CONAX, 3: DEVUELTO CONAX, 4: ERROR';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.fecreg
  is 'Fecha de creacion del registro';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.usumod
  is 'Usuario de modifico el registro';
comment on column OPERACION.OPE_LTE_ARCHIVO_CAB.fecmod
  is 'Fecha modificacion del registro';