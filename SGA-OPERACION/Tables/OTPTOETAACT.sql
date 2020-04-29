CREATE TABLE OPERACION.OTPTOETAACT
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODACT       NUMBER(5)                        NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  FECINI       DATE,
  FECFIN       DATE,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  COSTO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  PORCONTRATA  NUMBER(1)                        DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODCON       NUMBER(6),
  MONEDA       CHAR(1 BYTE)                     DEFAULT 'D'                   NOT NULL
);

COMMENT ON TABLE OPERACION.OTPTOETAACT IS 'Actividades de cada etapa de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.PUNTO IS 'Punto del cada orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.FECINI IS 'Fecha inicial de la actividad dela etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.FECFIN IS 'Fecha fin de la actividad dela etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CANTIDAD IS 'Cantidad de la actividad';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.PORCONTRATA IS 'Identifica si la actividad es realizada por un contratista';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.OTPTOETAACT.MONEDA IS 'Codigo de moneda';


