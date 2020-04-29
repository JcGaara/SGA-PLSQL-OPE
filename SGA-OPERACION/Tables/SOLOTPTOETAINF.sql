CREATE TABLE OPERACION.SOLOTPTOETAINF
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  ORDEN_INF    NUMBER(5)                        NOT NULL,
  TIPINFOT     NUMBER(5)                        NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  FECTENSOL    DATE,
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODTIPSOL    CHAR(3 BYTE)
);

COMMENT ON TABLE OPERACION.SOLOTPTOETAINF IS 'Listado de personal por cada etapa del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.PUNTO IS 'Putno de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.ORDEN_INF IS 'Orden del componente de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.TIPINFOT IS 'Tipo de informe de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.FECTENSOL IS 'Fecha tentativa de solucion';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAINF.CODTIPSOL IS 'Codigo del tipo de solicitud';


