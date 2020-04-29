-- Create table
create table OPERACION.OPE_SP_MAT_EQU_DET
(
  IDSPDET        NUMBER not null,
  IDSPCAB        NUMBER not null,
  LINEA          NUMBER,
  PEDIDO         NUMBER(2) default 0,
  CONTRATA       VARCHAR2(50),
  CODMAT         CHAR(15),
  CANTIDAD       NUMBER(8),
  IMPUTACION     CHAR(1),
  PRECIO_UNI     NUMBER(10,2),
  OBSERVACION1   VARCHAR2(500),
  OBSERVACION2   VARCHAR2(500),
  FEC_INGRESO    DATE,
  FEC_ENTREGA    DATE,
  FEC_GEN_SP     DATE,
  FEC_APR_SP     DATE,
  EST_APR_SP     NUMBER(2),
  USUREG         VARCHAR2(30) default user not null,
  FECREG         DATE default SYSDATE not null,
  USUMOD         VARCHAR2(30) default user not null,
  FECMOD         DATE default SYSDATE not null,
  NRO_SOLPED     NUMBER,
  NRO_PEDIDO     NUMBER,
  FEC_GEN_PC     DATE,
  FEC_APR_PC     DATE,
  EST_APR_PC     NUMBER(2),
  FEC_ENVIO      DATE,
  DESCRIPCION    VARCHAR2(150),
  MONEDA_ID      NUMBER(1),
  CODUND         CHAR(3),
  IDENTIFICA_SP  NUMBER default 1,
  COD_SAP        CHAR(18),
  SOT            NUMBER,
  EF             NUMBER,
  CENTRO_GESTOR  VARCHAR2(25),
  NRO_NECESIDAD  VARCHAR2(25),
  GRUPO_ARTICULO VARCHAR2(25),
  TIPO_POSICION  VARCHAR2(25),
  VALOR_INPUT    NUMBER(2),
  GRUPO          VARCHAR2(30),
  CENTRO         CHAR(4),
  ALMACEN        VARCHAR2(4)
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
comment on table OPERACION.OPE_SP_MAT_EQU_DET
  is 'TABLA DETALLE DE MATERIALES Y EQUIPOS';
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_DET.CODMAT
  is 'Codigo de material, id tabla almtabmat';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.IMPUTACION
  is 'Imputacion';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.PRECIO_UNI
  is 'Precio unitario';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.OBSERVACION1
  is 'Observacion';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.OBSERVACION2
  is 'Observacion';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_INGRESO
  is 'Fecha de ingreso';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_ENTREGA
  is 'Fecha de entrega';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_GEN_SP
  is 'Fecha de generacion de la solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_APR_SP
  is 'Fecha de aprobacion de la solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.EST_APR_SP
  is 'Estado de aprobacion de la solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FECREG
  is 'Fecha que se insertó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FECMOD
  is 'Fecha que se modificó el registro';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.NRO_SOLPED
  is 'Numero de solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.NRO_PEDIDO
  is 'Numero de pedido de compra';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_GEN_PC
  is 'Fecha de generacion del pedido de compra';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_APR_PC
  is 'Fecha de aprobacion del pedido de compra';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.EST_APR_PC
  is 'Estado de aprobacion del pedido de compra';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FEC_ENVIO
  is 'Fecha de envio a proveedor';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.DESCRIPCION
  is 'Descripcion de solicitud de pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.MONEDA_ID
  is 'Tipo de moneda';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.IDENTIFICA_SP
  is 'Identificador de Solicitud de Pedido';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.COD_SAP
  is 'Codigo  SAP';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.SOT
  is 'Codigo de SOT';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.EF
  is 'Codigo de EF';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.VALOR_INPUT
  is 'Valor de imputacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_SP_MAT_EQU_DET
  add constraint PK_OPE_SP_DET primary key (IDSPDET, IDSPCAB)
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