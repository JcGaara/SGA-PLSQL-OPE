CREATE TABLE OPERACION.TMP_TRSSOLOT
(
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
  FLGPOST       NUMBER(1)                       DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.TMP_TRSSOLOT IS 'No es usada';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODTRS IS 'Codigo de la transaccion';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.TIPO IS 'Tipo de transaccion';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.ESTINSSRVANT IS 'Codigo del estado de la instancia de servicio antiguo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODSRVNUE IS 'Codigo de servicio nuevo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.BWNUE IS 'Ancho de banda nuevo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODSRVANT IS 'Codigo de servicio antiguo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.BWANT IS 'Ancho de banda antiguo';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FECEJE IS 'Fecha de ejecución';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FECTRS IS 'Fecha de transaccion';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.NUMPTO IS 'Numero de punto del proyecto';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.IDADD IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.CODUSUEJE IS 'Registra el usuario al ejecutar las transacciones ';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.PUNTO IS 'Punto de solicitud de ot';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.PID IS 'Identificador de la instacia de producto';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.PID_OLD IS 'Identificador de la instacia de producto anterior';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FLGBIL IS 'Indica si la transaccion se encuentra en facturación';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FECINIFAC IS 'Fecha de inicio de factura';

COMMENT ON COLUMN OPERACION.TMP_TRSSOLOT.FLGPOST IS 'Indica si la transaccion se ejecuto con la fecha de postergacion';


