CREATE TABLE OPERACION.TIPOTRANSACCION
(
  TIPO         NUMBER                           NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  TIPSRV       CHAR(4 BYTE),
  TIPTRA       NUMBER(4)                        NOT NULL,
  CODMOTOT     NUMBER(3)                        NOT NULL,
  TRANSACCION  CHAR(10 BYTE)
);

COMMENT ON COLUMN OPERACION.TIPOTRANSACCION.TIPO IS 'Tipo de transacci�n.';

COMMENT ON COLUMN OPERACION.TIPOTRANSACCION.TIPSRV IS 'Tipo de servicio de SOT';

COMMENT ON COLUMN OPERACION.TIPOTRANSACCION.TIPTRA IS 'Tipo de trabajo de SOT';

COMMENT ON COLUMN OPERACION.TIPOTRANSACCION.CODMOTOT IS 'Motivo de SOT';

COMMENT ON COLUMN OPERACION.TIPOTRANSACCION.TRANSACCION IS 'Transacci�n (CORTE, SUSPENSION, ACTIVACION,CLC,RECCLC)';

