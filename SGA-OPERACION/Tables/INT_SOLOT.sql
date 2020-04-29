CREATE TABLE OPERACION.INT_SOLOT
(
  IDSEQ          NUMBER(10)                     NOT NULL,
  PROCESO        NUMBER(10)                     NOT NULL,
  GRUPO          NUMBER(4),
  ESTADO         NUMBER(1)                      DEFAULT 0                     NOT NULL,
  CODSOLOT       NUMBER(8),
  CODCLI         CHAR(8 BYTE),
  TIPTRA         NUMBER(4),
  CODINSSRV      NUMBER(10),
  NUMSLC         CHAR(10 BYTE),
  PUNTO          NUMBER(10),
  RECOSI         NUMBER(10),
  PID            NUMBER(10),
  CODMOTOT       NUMBER(3),
  TIPSRV         CHAR(4 BYTE),
  IDPRODUCTO     NUMBER(10),
  TIPINSSRV      NUMBER(2),
  CODINSSRV_DES  NUMBER(10),
  CODINSSRV_ORI  NUMBER(10),
  FECUSU         DATE                           DEFAULT SYSDATE               NOT NULL,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECUSUMOD      DATE                           DEFAULT SYSDATE,
  CODUSUMOD      VARCHAR2(30 BYTE)              DEFAULT user,
  FECCOM         DATE,
  ESTSOL         NUMBER(2)                      NOT NULL,
  OBSERVACION    VARCHAR2(500 BYTE)
);

COMMENT ON TABLE OPERACION.INT_SOLOT IS 'Interfase para generar solicitudes de orden de trabajo';

COMMENT ON COLUMN OPERACION.INT_SOLOT.TIPINSSRV IS 'Tipo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODINSSRV_DES IS 'Codigo de instancia de servicio destino';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODINSSRV_ORI IS 'Codigo de instancia de servicio origen';

COMMENT ON COLUMN OPERACION.INT_SOLOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.INT_SOLOT.FECUSUMOD IS 'Fecha de modificacion';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.INT_SOLOT.FECCOM IS 'Fecha de compromiso';

COMMENT ON COLUMN OPERACION.INT_SOLOT.ESTSOL IS 'Estado de la solicitud';

COMMENT ON COLUMN OPERACION.INT_SOLOT.OBSERVACION IS 'Observaci�n';

COMMENT ON COLUMN OPERACION.INT_SOLOT.IDSEQ IS 'Llave primaria de la tabla';

COMMENT ON COLUMN OPERACION.INT_SOLOT.PROCESO IS 'Proceso';

COMMENT ON COLUMN OPERACION.INT_SOLOT.GRUPO IS 'Grupo';

COMMENT ON COLUMN OPERACION.INT_SOLOT.ESTADO IS 'Estado';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.INT_SOLOT.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INT_SOLOT.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.INT_SOLOT.PUNTO IS 'Punto de la solicitud';

COMMENT ON COLUMN OPERACION.INT_SOLOT.RECOSI IS 'Numero de ticket';

COMMENT ON COLUMN OPERACION.INT_SOLOT.PID IS 'Identificador de la instacia de producto';

COMMENT ON COLUMN OPERACION.INT_SOLOT.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.INT_SOLOT.TIPSRV IS 'Codigo del tipo de servicio';

COMMENT ON COLUMN OPERACION.INT_SOLOT.IDPRODUCTO IS 'Identificador del producto';

