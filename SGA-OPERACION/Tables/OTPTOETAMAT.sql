CREATE TABLE OPERACION.OTPTOETAMAT
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODMAT       CHAR(15 BYTE)                    NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  OBSERVACION  VARCHAR2(200 BYTE),
  COSTO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  PORCONTRATA  NUMBER(1)                        DEFAULT 0                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  CODCON       NUMBER(6)
);

COMMENT ON TABLE OPERACION.OTPTOETAMAT IS 'Materiales de cada etapa de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.PUNTO IS 'Punto de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.COSTO IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.PORCONTRATA IS 'Indica si la etapa es por contrata';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAMAT.CODCON IS 'Codigo del contratista';


