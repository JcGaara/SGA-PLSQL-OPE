-- Create table
create table OPERACION.OPE_SP_MAT_EQU_TMP
(
  IDSPTMP              NUMBER not null,
  SOT                  NUMBER,
  EF                   NUMBER,
  NRO_SOLPED           VARCHAR2(100),
  LINEA                VARCHAR2(100),
  DESCRIPCION_CAB      VARCHAR2(500),
  TEXTO_COMPLEMENTARIO VARCHAR2(2000),
  DESCRIPCION_DET      VARCHAR2(500),
  AREA_SOLICITANTE     VARCHAR2(100),
  COD_SAP              VARCHAR2(100),
  GRUPO                VARCHAR2(100),
  IMPUTACION           VARCHAR2(150),
  CENTRO               VARCHAR2(100),
  ALMACEN              VARCHAR2(100),
  CANTIDAD             VARCHAR2(100),
  ABRUND               VARCHAR2(100),
  FEC_ENTREGA          VARCHAR2(100),
  SOLICITANTE          VARCHAR2(100),
  PRECIO_UNI           VARCHAR2(100),
  MONEDA               VARCHAR2(100),
  OBSERVACION1         VARCHAR2(500),
  FLG_PROCESADO        NUMBER(1) default 0,
  USUREG               VARCHAR2(30) default user not null,
  FECREG               DATE default SYSDATE not null,
  USUMOD               VARCHAR2(30) default user not null,
  FECMOD               DATE default SYSDATE not null
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
comment on table OPERACION.OPE_SP_MAT_EQU_TMP
  is 'Tabla Cabecera de Materiales y equipo';
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.IDSPTMP
  is 'identificador';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.SOT
  is 'Codigo de SOT';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.EF
  is 'Codigo de EF';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.NRO_SOLPED
  is 'Numero de solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.LINEA
  is 'Linea / Posición';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.DESCRIPCION_CAB
  is 'Descripcion Detalle';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.TEXTO_COMPLEMENTARIO
  is 'Texto complementario';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.AREA_SOLICITANTE
  is 'Area Solicitante';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.COD_SAP
  is 'Codigo SAP, id tabla almtabmat';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.GRUPO
  is 'Grupo de compra';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.IMPUTACION
  is 'Imputacion';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.CENTRO
  is 'Centro';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.ALMACEN
  is 'Almacen';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.CANTIDAD
  is 'Cantidad';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.ABRUND
  is 'Unidad';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.FEC_ENTREGA
  is 'Fecha de entrega';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.SOLICITANTE
  is 'Solicitante';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.PRECIO_UNI
  is 'Precio unitario';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.MONEDA
  is 'Tipo de moneda';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.OBSERVACION1
  is 'Observacion';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.FLG_PROCESADO
  is 'Flag de procesado, 0:Pendiente 1:Procesado, 2:Error';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.FECREG
  is 'Fecha que se insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_TMP.FECMOD
  is 'Fecha que se modificó el registro';
