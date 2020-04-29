CREATE TABLE OPERACION.MATXACT
(
  CODACT    NUMBER(5)                           NOT NULL,
  CODMAT    CHAR(15 BYTE)                       NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.MATXACT IS 'No es usada';

COMMENT ON COLUMN OPERACION.MATXACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.MATXACT.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.MATXACT.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.MATXACT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MATXACT.FECUSU IS 'Fecha de registro';


