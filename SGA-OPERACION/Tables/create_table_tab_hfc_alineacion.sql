-- Create table
create table OPERACION.TAB_HFC_ALINEACION
(
  CODCLI      CHAR(8),
  TIPSRV      CHAR(4),
  CODSRV      CHAR(4),
  CODINSSRV   NUMBER(10),
  ESTINSSRV   NUMBER(2),
  NUMERO      VARCHAR2(20),
  CODSOLOT    NUMBER(8),
  NUMSEC      NUMBER(20),
  CUSTOMER_ID NUMBER,
  CO_ID       NUMBER,
  CODPLAN_B   NUMBER,
  FLG_UNICO   NUMBER default 0,
  FLG_SISTEMA NUMBER default 0,
  IDPRODUCTO  NUMBER,
  NUMERO_BSCS VARCHAR2(20),
  CUSTOMER    VARCHAR2(50),
  CICLO       VARCHAR2(20)
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
