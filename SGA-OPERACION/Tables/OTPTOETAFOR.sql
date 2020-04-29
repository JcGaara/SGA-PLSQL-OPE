CREATE TABLE OPERACION.OTPTOETAFOR
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODFOR       NUMBER(5)                        NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  PORCONTRATA  NUMBER(1)                        DEFAULT 0                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.OTPTOETAFOR IS 'Formula de cada etapa de la orden de trabajo  (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.PUNTO IS 'Punto de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.CANTIDAD IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.PORCONTRATA IS 'Indica si es realizado por el contrata';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAFOR.CODUSU IS 'Codigo de Usuario registro';


