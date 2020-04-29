CREATE TABLE OPERACION.OTPTOETAPER
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODTRA       CHAR(8 BYTE)                     NOT NULL,
  OBSERVACION  VARCHAR2(100 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OTPTOETAPER IS 'Personal responsable de cada etapa de la orden de trabajo  (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.PUNTO IS 'Punto de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.CODTRA IS 'Codigo de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAPER.FECUSU IS 'Fecha de registro';


