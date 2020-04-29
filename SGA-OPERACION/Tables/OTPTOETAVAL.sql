CREATE TABLE OPERACION.OTPTOETAVAL
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  FECHA        DATE,
  NROFACT      VARCHAR2(15 BYTE),
  CODCON       NUMBER(10)                       NOT NULL,
  ESTADO       CHAR(2 BYTE),
  MONTO        NUMBER(10,2)                     NOT NULL,
  TIPCAM       NUMBER(5,2),
  MONEDA       CHAR(2 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  COSMO        NUMBER(10,2),
  COSMAT       NUMBER(10,2),
  TOTALFAC     NUMBER(10,2),
  FECREC       DATE,
  NROCARTA     VARCHAR2(15 BYTE),
  TIPO         NUMBER(1),
  FECVENCARTA  DATE
);

COMMENT ON TABLE OPERACION.OTPTOETAVAL IS 'No es usada';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.PUNTO IS 'Punto de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.FECHA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.NROFACT IS 'Numero de facturación';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.ESTADO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.MONTO IS 'Monto ';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.TIPCAM IS 'Tipo de cambio';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.MONEDA IS 'Codigo de la moneda';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.TOTALFAC IS 'Total de facturación';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.FECREC IS 'Fecha de recepción';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.NROCARTA IS 'Numero de carta';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.TIPO IS 'Tipo';

COMMENT ON COLUMN OPERACION.OTPTOETAVAL.FECVENCARTA IS 'Fecha de vencimiento de carta';


