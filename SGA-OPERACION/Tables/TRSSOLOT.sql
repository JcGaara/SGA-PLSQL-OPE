CREATE TABLE OPERACION.TRSSOLOT
(
  CODTRS         NUMBER(10)                     NOT NULL,
  CODINSSRV      NUMBER(10),
  CODSOLOT       NUMBER(8),
  TIPO           NUMBER(1),
  TIPTRS         NUMBER(2),
  ESTTRS         NUMBER(2),
  ESTINSSRV      NUMBER(2),
  ESTINSSRVANT   NUMBER(2),
  CODSRVNUE      CHAR(4 BYTE),
  BWNUE          NUMBER(10),
  CODSRVANT      CHAR(4 BYTE),
  BWANT          NUMBER(10),
  FECEJE         DATE,
  FECTRS         DATE,
  NUMSLC         CHAR(10 BYTE),
  NUMPTO         CHAR(5 BYTE),
  IDADD          CHAR(3 BYTE),
  FECUSU         DATE                           DEFAULT SYSDATE,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user,
  CODUSUEJE      VARCHAR2(30 BYTE),
  PUNTO          NUMBER(10),
  PID            NUMBER(10),
  PID_OLD        NUMBER(10),
  FLGBIL         NUMBER(1)                      DEFAULT 0                     NOT NULL,
  FECINIFAC      DATE,
  FLGPOST        NUMBER(1)                      DEFAULT 0                     NOT NULL,
  OBSERR         VARCHAR2(200 BYTE),
  CODCLICES      CHAR(8 BYTE),
  CODGRUPOPRO    NUMBER,
  CODGRUPOFAC    NUMBER,
  IDINSTPRODCES  NUMBER(10),
  IDCESION       NUMBER,
  IDCODREL       CHAR(8 BYTE),
  IDPLATAFORMA   NUMBER
);

COMMENT ON TABLE OPERACION.TRSSOLOT IS 'Transacciones de la solicitud de ot';

COMMENT ON COLUMN OPERACION.TRSSOLOT.IDCESION IS 'Identificador de Cesión Contractual';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FLGBIL IS 'Indica si la transaccion se encuentra en facturación';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FECINIFAC IS 'Fecha de inicio de factura';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FLGPOST IS 'Indica si la transaccion se ejecuto con la fecha de postergacion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODCLICES IS 'Cliente asociado a la cesión';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODGRUPOPRO IS 'Secuencial de # procesos transferidos a facturación';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODGRUPOFAC IS 'Secuencial de grupo dentro de cada proceso';

COMMENT ON COLUMN OPERACION.TRSSOLOT.IDINSTPRODCES IS 'Instancia de producto activo en facturación cuando se solicita la cesión';

COMMENT ON COLUMN OPERACION.TRSSOLOT.PID IS 'Identificador de la instacia de producto';

COMMENT ON COLUMN OPERACION.TRSSOLOT.PID_OLD IS 'Identificador de la instacia de producto anterior';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODTRS IS 'Codigo de la transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.TIPO IS 'Tipo de transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TRSSOLOT.ESTINSSRVANT IS 'Codigo del estado de la instancia de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODSRVNUE IS 'Codigo de servicio nuevo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.BWNUE IS 'Ancho de banda nuevo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODSRVANT IS 'Codigo de servicio antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.BWANT IS 'Ancho de banda antiguo';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FECEJE IS 'Fecha de ejecución';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FECTRS IS 'Fecha de transaccion';

COMMENT ON COLUMN OPERACION.TRSSOLOT.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.TRSSOLOT.NUMPTO IS 'Numero de punto del proyecto';

COMMENT ON COLUMN OPERACION.TRSSOLOT.IDADD IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.TRSSOLOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TRSSOLOT.CODUSUEJE IS 'Registra el usuario al ejecutar las transacciones ';

COMMENT ON COLUMN OPERACION.TRSSOLOT.PUNTO IS 'Punto de solicitud de ot';

COMMENT ON COLUMN OPERACION.TRSSOLOT.IDPLATAFORMA IS 'Identificador de la plataforma';


