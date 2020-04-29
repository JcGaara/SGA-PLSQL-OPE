create table OPERACION.T_REGULARIZAR_ESTADO
(
  COD_REG               NUMBER,
  COD_ID                NUMBER,
  COD_SOLOT             NUMBER,
  NUMERO                VARCHAR2(20),
  TIPO                  VARCHAR2(1),
  ESTADO_REGULARIZACION VARCHAR2(1),
  DESC_REGULARIZACION   VARCHAR2(50),
  COD_ERROR             VARCHAR2(10),
  MSG_ERROR             VARCHAR2(500),
  FECHA_REG             DATE,
  FECHA_UPDATE          DATE
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
