CREATE TABLE OPERACION.OTPTO
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ESTOTPTO     NUMBER(2)                        NOT NULL,
  POP          NUMBER(10),
  FECINI       DATE                             DEFAULT sysdate,
  FECFIN       DATE,
  FECCOM       DATE,
  FECINISRV    DATE,
  CODSRVNUE    CHAR(4 BYTE),
  BWNUE        NUMBER(10),
  CODSRVANT    CHAR(4 BYTE),
  BWANT        NUMBER(10),
  OBSERVACION  VARCHAR2(500 BYTE),
  DIRECCION    VARCHAR2(480 BYTE),
  COSEQU       NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMAT       NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMOCLI     NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMATCLI    NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  COSMO_S      NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMAT_S     NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  PUERTA       NUMBER(1),
  TIPOTPTO     NUMBER(2),
  CODINSSRV    NUMBER(10),
  FECPOST      DATE
);

COMMENT ON TABLE OPERACION.OTPTO IS 'Detalle de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTO.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTO.PUNTO IS 'Punto de la ot';

COMMENT ON COLUMN OPERACION.OTPTO.ESTOTPTO IS 'Estado del punto de la ot';

COMMENT ON COLUMN OPERACION.OTPTO.POP IS 'POP';

COMMENT ON COLUMN OPERACION.OTPTO.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.OTPTO.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.OTPTO.FECCOM IS 'Fecha de compromiso';

COMMENT ON COLUMN OPERACION.OTPTO.FECINISRV IS 'Fecha de inicio de servicio';

COMMENT ON COLUMN OPERACION.OTPTO.CODSRVNUE IS 'Codigo de servicio nuevo';

COMMENT ON COLUMN OPERACION.OTPTO.BWNUE IS 'Ancho de banda nuevo';

COMMENT ON COLUMN OPERACION.OTPTO.CODSRVANT IS 'Codigo de servicio antiguo';

COMMENT ON COLUMN OPERACION.OTPTO.BWANT IS 'Ancho de banda antiguo';

COMMENT ON COLUMN OPERACION.OTPTO.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTPTO.DIRECCION IS 'DIRECCION';

COMMENT ON COLUMN OPERACION.OTPTO.COSEQU IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.OTPTO.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTO.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTO.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTO.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTO.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.OTPTO.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.OTPTO.PUERTA IS 'Puerta';

COMMENT ON COLUMN OPERACION.OTPTO.TIPOTPTO IS 'Tipo de la ot';

COMMENT ON COLUMN OPERACION.OTPTO.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.OTPTO.FECPOST IS 'No se utiliza';


