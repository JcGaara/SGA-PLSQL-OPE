CREATE TABLE OPERACION.ACTETAPAXFOR
(
  CODFOR    NUMBER(5)                           NOT NULL,
  CODACT    NUMBER(5)                           NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODETA    NUMBER(5)                           NOT NULL,
  CAN_MAX   NUMBER
);

COMMENT ON TABLE OPERACION.ACTETAPAXFOR IS 'Tabla de Actividades por etapa por formula';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.CODACT IS 'Codigo de Actividad';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.CANTIDAD IS 'Cantidad de Actividades';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ACTETAPAXFOR.CODETA IS 'Etapa';


