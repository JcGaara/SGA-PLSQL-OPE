-- Create table
create table OPERACION.OPE_SP_MAT_EQU_DET_IMP
(
  IDSPDET        NUMBER not null,
  IDSPCAB        NUMBER not null,
  ELE_PEP        VARCHAR2(30),
  USUREG         VARCHAR2(30) default user not null,
  FECREG         DATE default SYSDATE not null,
  USUMOD         VARCHAR2(30) default user not null,
  FECMOD         DATE default SYSDATE not null,
  COD_CEN_COSTO  VARCHAR2(30),
  NRO_ACTIVO     VARCHAR2(30),
  CUENTA_MAYOR   VARCHAR2(32),
  CONCEPTO_CAPEX VARCHAR2(50),
  NRO_ORDEN      VARCHAR2(30),
  CEN_COSTO      VARCHAR2(32)
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

