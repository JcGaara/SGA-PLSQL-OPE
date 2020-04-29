CREATE TABLE OPERACION.TRSINSSRV
(
  CODTRS        NUMBER(10)                      NOT NULL,
  CODINSSRV     NUMBER(10)                      NOT NULL,
  CODOT         NUMBER(8),
  ESTTRS        NUMBER(2)                       NOT NULL,
  TIPTRS        NUMBER(2)                       NOT NULL,
  ESTINSSRV     NUMBER(2)                       NOT NULL,
  ESTINSSRVANT  NUMBER(2)                       NOT NULL,
  FECEJE        DATE,
  FECTRS        DATE                            DEFAULT SYSDATE,
  CODSRVNUE     CHAR(4 BYTE),
  BWNUE         NUMBER(10),
  CODSRVANT     CHAR(4 BYTE),
  BWANT         NUMBER(10),
  NUMSLC        CHAR(10 BYTE),
  FECUSU        DATE                            DEFAULT SYSDATE,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user
);

COMMENT ON TABLE OPERACION.TRSINSSRV IS 'Transaccion asociada a un cambio en el SID';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODTRS IS 'Codigo de la transaccion';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.TRSINSSRV.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TRSINSSRV.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSINSSRV.ESTINSSRVANT IS 'Codigo del estado de la instancia de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.FECEJE IS 'Fecha de ejecución';

COMMENT ON COLUMN OPERACION.TRSINSSRV.FECTRS IS 'Fecha de transaccion';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODSRVNUE IS 'Codigo de servicio nuevo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.BWNUE IS 'Ancho de banda nuevo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODSRVANT IS 'Codigo de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.BWANT IS 'Ancho de banda antiguo';

COMMENT ON COLUMN OPERACION.TRSINSSRV.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.TRSINSSRV.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TRSINSSRV.CODUSU IS 'Codigo de Usuario registro';


