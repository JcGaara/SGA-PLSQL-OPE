CREATE TABLE OPERACION.PREUSUFAS
(
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  CODDPT  CHAR(6 BYTE),
  CODFAS  NUMBER(8)                             NOT NULL,
  CODETA  NUMBER(5)                             NOT NULL,
  TIPACC  NUMBER(2),
  ACCESO  NUMBER(1),
  FECREG  DATE                                  DEFAULT SYSDATE               NOT NULL,
  USUREG  VARCHAR2(50 BYTE)                     DEFAULT USER                  NOT NULL,
  FECMOD  DATE                                  DEFAULT SYSDATE               NOT NULL,
  USUMOD  VARCHAR2(50 BYTE)                     DEFAULT USER                  NOT NULL
);

COMMENT ON TABLE OPERACION.PREUSUFAS IS 'Acceso a las fases de control de costos';

COMMENT ON COLUMN OPERACION.PREUSUFAS.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PREUSUFAS.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.PREUSUFAS.CODFAS IS 'Codigo de la fase ';

COMMENT ON COLUMN OPERACION.PREUSUFAS.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.PREUSUFAS.TIPACC IS 'Tipo de acceso (No es utilizado)';

COMMENT ON COLUMN OPERACION.PREUSUFAS.ACCESO IS 'Tipo de acceso (Lectura, escritura)';


