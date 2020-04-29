CREATE TABLE OPERACION.OTPTOETACON
(
  CODOT   NUMBER(8)                             NOT NULL,
  PUNTO   NUMBER(10)                            NOT NULL,
  CODETA  NUMBER(5)                             NOT NULL,
  CODCON  NUMBER(6)                             NOT NULL,
  COSMAT  NUMBER(10,2)                          DEFAULT 0                     NOT NULL,
  COSMO   NUMBER(10,2)                          DEFAULT 0                     NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.OTPTOETACON IS 'Contrata de cada etapa de la orden de trabajo  (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETACON.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETACON.PUNTO IS 'Punto de la ot';

COMMENT ON COLUMN OPERACION.OTPTOETACON.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETACON.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.OTPTOETACON.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTOETACON.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTOETACON.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETACON.CODUSU IS 'Codigo de Usuario registro';


