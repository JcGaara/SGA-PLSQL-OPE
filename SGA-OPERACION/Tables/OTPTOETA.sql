CREATE TABLE OPERACION.OTPTOETA
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  COSMAT       NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMOCLI     NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMATCLI    NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  FECCOM       DATE,
  PORCONTRATA  NUMBER(1)                        DEFAULT 0                     NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  COSMO_S      NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMAT_S     NUMBER(10,2)                     DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.OTPTOETA IS 'Etapa de cada detalle de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETA.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETA.PUNTO IS 'Punto de la ot';

COMMENT ON COLUMN OPERACION.OTPTOETA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTOETA.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.OTPTOETA.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.OTPTOETA.FECCOM IS 'Fecha de compromiso';

COMMENT ON COLUMN OPERACION.OTPTOETA.PORCONTRATA IS 'Identifica si la etapa es realizada por el contrata';

COMMENT ON COLUMN OPERACION.OTPTOETA.OBSERVACION IS 'OBSERVACION';

COMMENT ON COLUMN OPERACION.OTPTOETA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.OTPTOETA.COSMAT_S IS 'Costo del material en soles';


