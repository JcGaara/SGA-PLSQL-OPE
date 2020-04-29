CREATE TABLE OPERACION.SECUENCIA_ESTADOS_AGENDA
(
  ESTAGENDAINI  NUMBER(2)                       NOT NULL,
  ESTAGENDAFIN  NUMBER(2)                       NOT NULL,
  USUREG        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECREG        DATE                            DEFAULT sysdate               NOT NULL,
  USUMOD        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECMOD        DATE                            DEFAULT sysdate               NOT NULL,
  TIPTRA        NUMBER(4)
);

COMMENT ON TABLE OPERACION.SECUENCIA_ESTADOS_AGENDA IS 'Tabla de secuencia de estados de agendamiento';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.ESTAGENDAINI IS 'Estado inicial o actual';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.ESTAGENDAFIN IS 'Estado final o posible de cambio';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.USUREG IS 'Usuario   que   insertó   el registro';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.USUMOD IS 'Usuario   que modificó   el registro';

COMMENT ON COLUMN OPERACION.SECUENCIA_ESTADOS_AGENDA.FECMOD IS 'Fecha   que se   modificó el registro';


