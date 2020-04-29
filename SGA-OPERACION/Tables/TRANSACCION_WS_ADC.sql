create table operacion.transaccion_ws_adc
(
  idtransaccion NUMBER not null,
  codsolot      NUMBER(8),
  idagenda      NUMBER(8),
  metodo        VARCHAR2(30),
  xmlenvio      CLOB default empty_clob(),
  xmlrespuesta  CLOB default empty_clob(),
  iderror       VARCHAR2(6),
  mensajeerror  VARCHAR2(2000),
  ip            VARCHAR2(30),
  feccrea       DATE default SYSDATE,
  usucrea       VARCHAR2(30) default USER
)
tablespace OPERACION_DAT;
