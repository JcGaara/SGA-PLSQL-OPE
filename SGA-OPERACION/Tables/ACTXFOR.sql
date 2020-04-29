CREATE TABLE OPERACION.ACTXFOR
(
  CODACT    NUMBER(5)                           NOT NULL,
  CODFOR    NUMBER(5)                           NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXFOR IS 'Listado de actividades por cada formula definida';

COMMENT ON COLUMN OPERACION.ACTXFOR.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.ACTXFOR.CANTIDAD IS 'Cantidad de actividad';

COMMENT ON COLUMN OPERACION.ACTXFOR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ACTXFOR.CODUSU IS 'Codigo de Usuario registro';


