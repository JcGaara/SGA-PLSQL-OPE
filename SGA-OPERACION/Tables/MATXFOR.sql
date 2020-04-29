CREATE TABLE OPERACION.MATXFOR
(
  CODFOR    NUMBER(5)                           NOT NULL,
  CODMAT    CHAR(15 BYTE)                       NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.MATXFOR IS 'No es usada';

COMMENT ON COLUMN OPERACION.MATXFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.MATXFOR.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.MATXFOR.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.MATXFOR.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MATXFOR.FECUSU IS 'Fecha de registro';


