-- Create table
create table OPERACION.OPE_LTE_LOTE_SLTD_AUX
(
  idlote      NUMBER(10) not null,
  numsol      NUMBER(5),
  numarchivos NUMBER(3),
  estado      NUMBER(1) not null,
  usureg      VARCHAR2(30) default USER not null,
  fecreg      DATE default SYSDATE not null,
  usumod      VARCHAR2(30) default USER not null,
  fecmod      DATE default SYSDATE not null
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
comment on table OPERACION.OPE_LTE_LOTE_SLTD_AUX
  is 'Tabla de agrupacion de solicitudes suspension / activacion para la generacion de archivos a enviar el conax. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de LTE.';
-- Add comments to the columns 
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.idlote
  is 'Identificador del lote';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.numsol
  is 'Numero de solicitudes incluidas en el lote';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.numarchivos
  is 'Numero de archivos al conax incluidos en el lote';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.estado
  is 'Estado del lote: 1:PEND_EJECUCION, 2:GEN_ARCHIVOS, 3: ARCHIVOS_COMPLETADOS, 4: ENV_CONAX,5: REC_CONAX, 6: VERIFICADO';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.usureg
  is 'Usuario que genero el registro';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.fecreg
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.usumod
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_LTE_LOTE_SLTD_AUX.fecmod
  is 'Fecha de modificacion del registro';