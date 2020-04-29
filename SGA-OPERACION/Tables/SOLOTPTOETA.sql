CREATE TABLE OPERACION.SOLOTPTOETA
(
  CODSOLOT           NUMBER(8)                  NOT NULL,
  PUNTO              NUMBER(10)                 NOT NULL,
  ORDEN              NUMBER(4)                  NOT NULL,
  CODETA             NUMBER(5)                  NOT NULL,
  CODCON             NUMBER(6),
  CODUSU             VARCHAR2(30 BYTE)          DEFAULT user                  NOT NULL,
  FECUSU             DATE                       DEFAULT SYSDATE               NOT NULL,
  PORCONTRATA        NUMBER(1)                  DEFAULT 0                     NOT NULL,
  ESTETA             NUMBER(2)                  DEFAULT 7,
  FECINI             DATE,
  FECFIN             DATE,
  FECCON             DATE,
  FECLIQ             DATE,
  FECPER             DATE,
  OBS                VARCHAR2(400 BYTE),
  PCCODTAREA         NUMBER(15),
  PCTIPGASTO         VARCHAR2(30 BYTE),
  PCIDORGGASTO       NUMBER(15),
  FECVAL             DATE,
  FECFAC             DATE,
  FECPROG            DATE,
  RESPONSABLE        VARCHAR2(30 BYTE),
  TPOREQUERIDO       NUMBER(5),
  FLGOR              NUMBER                     DEFAULT 0,
  OC                 NUMBER,
  FLG_CAPITALIZABLE  NUMBER                     DEFAULT 0,
  SOC                VARCHAR2(20 BYTE),
  CODALMOF           NUMBER,
  FECDIS             DATE,
  FECINS             DATE,
  FECAUD             DATE,
  FLG_SPGENERADO     NUMBER                     DEFAULT 0                     NOT NULL,
  IDLIQ              NUMBER,
  IDAGENDA           NUMBER(8)
);

COMMENT ON TABLE OPERACION.SOLOTPTOETA IS 'Listado de etapa del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.IDLIQ IS 'Id de Liquidacion';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.PUNTO IS 'Punto de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.PORCONTRATA IS 'Indica si la etapa es ejecutada por el contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.ESTETA IS 'Estado de la etapa del punto';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECFIN IS 'Fecha final';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECCON IS 'Fecha de contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECLIQ IS 'Fecha de liquidación';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECPER IS 'Fecha de permiso municipal';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.OBS IS 'Observacion';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.PCCODTAREA IS 'Task ID del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.PCTIPGASTO IS 'Tipo de Gasto del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.PCIDORGGASTO IS 'Organización de gasto del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.CODALMOF IS 'almacen of';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FECAUD IS 'Fecha de auditoría';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.FLG_SPGENERADO IS '0 = NO; 1 = En cola; 2= Error; 3 = Procesado';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA.IDAGENDA IS 'id de la agenda generada en la tabla agendamiento';


