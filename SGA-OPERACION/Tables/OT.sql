CREATE TABLE OPERACION.OT
(
  CODOT        NUMBER(8)                        NOT NULL,
  CODMOTOT     NUMBER(3)                        NOT NULL,
  CODSOLOT     NUMBER(8)                        NOT NULL,
  TIPTRA       NUMBER(4)                        NOT NULL,
  ESTOT        NUMBER(2)                        NOT NULL,
  DOCID        NUMBER(10)                       NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  FECCLI       DATE,
  LUGAR        VARCHAR2(500 BYTE),
  OBSERVACION  VARCHAR2(2000 BYTE),
  CODDPT       CHAR(6 BYTE)                     NOT NULL,
  FECULTEST    DATE                             NOT NULL,
  FECCOM       DATE,
  COSMO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMAT       NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMATCLI    NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSMOCLI     NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  COSEQU       NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODOTPADRE   NUMBER(8),
  COSMO_S      NUMBER(10,2)                     DEFAULT 0,
  COSMAT_S     NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  ORIGEN       CHAR(1 BYTE),
  RESPONSABLE  VARCHAR2(30 BYTE),
  APRTRS       NUMBER(1)                        DEFAULT 0,
  AREA         NUMBER(4),
  TIPO         VARCHAR2(30 BYTE),
  FLAGEJE      NUMBER(1)
);

COMMENT ON TABLE OPERACION.OT IS 'Orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OT.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OT.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OT.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.OT.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.OT.ESTOT IS 'Estado de la ot';

COMMENT ON COLUMN OPERACION.OT.DOCID IS 'id de documento';

COMMENT ON COLUMN OPERACION.OT.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.OT.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.OT.FECCLI IS 'Fecha del cliente';

COMMENT ON COLUMN OPERACION.OT.LUGAR IS 'LUGAR';

COMMENT ON COLUMN OPERACION.OT.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OT.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.OT.FECULTEST IS 'Fecha ultima de test';

COMMENT ON COLUMN OPERACION.OT.FECCOM IS 'Fecha de compromiso';

COMMENT ON COLUMN OPERACION.OT.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OT.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OT.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OT.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OT.COSEQU IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.OT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OT.CODOTPADRE IS 'Codigo de la orden de trabajo padre';

COMMENT ON COLUMN OPERACION.OT.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.OT.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.OT.ORIGEN IS 'Origen';

COMMENT ON COLUMN OPERACION.OT.RESPONSABLE IS 'Responsable de la ejecucion';

COMMENT ON COLUMN OPERACION.OT.APRTRS IS 'Indica si es reponsable de la aprobacion de la transaccion';

COMMENT ON COLUMN OPERACION.OT.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.OT.TIPO IS 'Tipo de orden de trabajo';

COMMENT ON COLUMN OPERACION.OT.FLAGEJE IS 'Identifica si la ot es responsable de la ejecución';


