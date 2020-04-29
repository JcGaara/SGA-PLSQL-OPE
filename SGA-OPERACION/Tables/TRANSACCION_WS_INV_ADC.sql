create table OPERACION.TRANSACCION_WS_INV_ADC
(
  idtransaccion NUMBER not null,
  id_proceso    number,
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

comment on table operacion.transaccion_ws_inv_adc is 'Tabla de Transacciones de WebService de Inventario';
comment on column operacion.transaccion_ws_inv_adc.idtransaccion is 'Identificador de Transaccion';
comment on column operacion.transaccion_ws_inv_adc.id_proceso is 'Tipo de Proceso, 2: Incremental, 1: Full';
comment on column operacion.transaccion_ws_inv_adc.metodo is 'Metodo de Servicio';
comment on column operacion.transaccion_ws_inv_adc.xmlenvio  is 'Xml de Envio';
comment on column operacion.transaccion_ws_inv_adc.xmlrespuesta  is 'Xml de Respuesta';
comment on column operacion.transaccion_ws_inv_adc.iderror  is 'Identificador de Error';
comment on column operacion.transaccion_ws_inv_adc.mensajeerror  is 'Mensaje de Error';
comment on column operacion.transaccion_ws_inv_adc.ip  is 'IP';
comment on column operacion.transaccion_ws_inv_adc.feccrea  is 'Fecha de Creacion';
comment on column operacion.transaccion_ws_inv_adc.usucrea  is 'Usuario de Creacion';