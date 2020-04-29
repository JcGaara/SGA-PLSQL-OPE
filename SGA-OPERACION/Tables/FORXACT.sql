CREATE TABLE OPERACION.FORXACT
(
  CODACT    NUMBER(5)                           NOT NULL,
  CODFOR    NUMBER(5)                           NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.FORXACT IS 'No es usada';

COMMENT ON COLUMN OPERACION.FORXACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.FORXACT.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.FORXACT.CANTIDAD IS 'Cantidad de actividad en la formula';

COMMENT ON COLUMN OPERACION.FORXACT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.FORXACT.CODUSU IS 'Codigo de Usuario registro';


