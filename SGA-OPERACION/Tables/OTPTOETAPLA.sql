CREATE TABLE OPERACION.OTPTOETAPLA
(
  CODOT       NUMBER(8)                         NOT NULL,
  PUNTO       NUMBER(10)                        NOT NULL,
  CODETA      NUMBER(5)                         NOT NULL,
  FLGDISENO   NUMBER(1)                         DEFAULT 0                     NOT NULL,
  FLGPERMISO  NUMBER(1)                         DEFAULT 0                     NOT NULL,
  FLGCAD      NUMBER(1)                         DEFAULT 0                     NOT NULL,
  FECDISENO   DATE,
  FECPERMISO  DATE,
  FECCAD      DATE,
  FECUSU      DATE                              DEFAULT SYSDATE               NOT NULL,
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user                  NOT NULL,
  FLGINST     NUMBER(1)                         DEFAULT 0                     NOT NULL,
  FECINST     DATE
);

COMMENT ON TABLE OPERACION.OTPTOETAPLA IS 'No es usada';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.PUNTO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FLGDISENO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FLGPERMISO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FLGCAD IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FECDISENO IS 'Fecha de dise�o';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FECPERMISO IS 'Fecha de permiso municipal';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FECCAD IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FLGINST IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOETAPLA.FECINST IS 'Fecha de instalacion';


