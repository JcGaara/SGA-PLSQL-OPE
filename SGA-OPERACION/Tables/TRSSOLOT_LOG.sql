CREATE TABLE OPERACION.TRSSOLOT_LOG
(
  ID            NUMBER(10)                      NOT NULL,
  CODTRS        NUMBER(10)                      NOT NULL,
  CODINSSRV     NUMBER(10),
  CODSOLOT      NUMBER(8),
  TIPO          NUMBER(1),
  TIPTRS        NUMBER(2),
  ESTTRS        NUMBER(2),
  ESTINSSRV     NUMBER(2),
  ESTINSSRVANT  NUMBER(2),
  CODSRVNUE     CHAR(4 BYTE),
  BWNUE         NUMBER(10),
  CODSRVANT     CHAR(4 BYTE),
  BWANT         NUMBER(10),
  FECEJE        DATE,
  FECTRS        DATE,
  NUMSLC        CHAR(10 BYTE),
  NUMPTO        CHAR(5 BYTE),
  IDADD         CHAR(3 BYTE),
  FECUSU        DATE                            DEFAULT SYSDATE,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user,
  CODUSUEJE     VARCHAR2(30 BYTE),
  PUNTO         NUMBER(10),
  PID           NUMBER(10),
  PID_OLD       NUMBER(10),
  FLGBIL        NUMBER(1)                       DEFAULT 0                     NOT NULL,
  FECINIFAC     DATE,
  FLGPOST       NUMBER(1)                       DEFAULT 0                     NOT NULL,
  CODUSU_LOG    VARCHAR2(30 BYTE)               DEFAULT user,
  FECUSU_LOG    DATE                            DEFAULT SYSDATE,
  IDPLATAFORMA  NUMBER
);

COMMENT ON TABLE OPERACION.TRSSOLOT_LOG IS 'Log de las transacciones de la solicitud de ot';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.ID IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODTRS IS 'Codigo de la transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.TIPO IS 'Tipo de la transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.ESTINSSRVANT IS 'Codigo del estado de la instancia de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODSRVNUE IS 'Codigo de servicio nuevo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.BWNUE IS 'Ancho de banda nuevo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODSRVANT IS 'Codigo de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.BWANT IS 'Ancho de banda antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FECEJE IS 'Fecha de ejecucin';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FECTRS IS 'Fecha de transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.NUMSLC IS 'Numero del proyecto';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.NUMPTO IS 'Numero de punto del proyecto';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.IDADD IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODUSUEJE IS 'Registra el usuario al ejecutar las transacciones ';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.PUNTO IS 'Punto de la solicitud';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.PID IS 'Identificador de la instacia de producto';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.PID_OLD IS 'Identificador de la instacia de producto anterior';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FLGBIL IS 'Indica si la transaccion se encuentra en facturacin';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FECINIFAC IS 'Fecha de inicio de factura';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FLGPOST IS 'Indica si la transaccion se ejecuto con la fecha de postergacion';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.CODUSU_LOG IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.FECUSU_LOG IS 'Fecha de registro log';

COMMENT ON COLUMN OPERACION.TRSSOLOT_LOG.IDPLATAFORMA IS 'Identificador de la plataforma';


