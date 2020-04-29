CREATE TABLE OPERACION.OTPTOETAINF
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  TIPINFOT     NUMBER(5)                        NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  FECTENSOL    DATE,
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODTIPSOL    CHAR(3 BYTE)
);

COMMENT ON TABLE OPERACION.OTPTOETAINF IS 'Informe de cada etapa de la orden de trabajo  (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.PUNTO IS 'Punto de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.TIPINFOT IS 'Tipo de informe de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.FECTENSOL IS 'Fecha tentativa de soluci�n';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.OBSERVACION IS 'Observaci�n';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAINF.CODTIPSOL IS 'Codigo del tipo de solicitud';

