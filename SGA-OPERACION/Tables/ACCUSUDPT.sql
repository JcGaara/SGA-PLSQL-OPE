CREATE TABLE OPERACION.ACCUSUDPT
(
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  CODDPT  CHAR(6 BYTE),
  TIPO    NUMBER(2)                             NOT NULL,
  ACCESO  NUMBER(1)                             NOT NULL,
  APROB   NUMBER(1)                             NOT NULL,
  CODETA  NUMBER(5),
  FECUSU  DATE                                  DEFAULT sysdate               NOT NULL,
  OPCION  NUMBER(4)                             DEFAULT 0                     NOT NULL,
  AREA    NUMBER(4),
  USUREG  VARCHAR2(50 BYTE)                     DEFAULT USER                  NOT NULL,
  FECMOD  DATE                                  DEFAULT SYSDATE               NOT NULL,
  USUMOD  VARCHAR2(50 BYTE)                     DEFAULT USER                  NOT NULL
);

COMMENT ON TABLE OPERACION.ACCUSUDPT IS 'Acceso de usuarios a la visualizacion a opciones del modulo';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.TIPO IS 'Tipo de permiso (ef, solot, ot)';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.ACCESO IS 'Tipo de acceso (Lectura, escritura)';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.APROB IS 'Permiso para aprobar';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.OPCION IS 'Opcion de ingreso';

COMMENT ON COLUMN OPERACION.ACCUSUDPT.AREA IS 'Codigo de area';


