CREATE TABLE OPERACION.CONDXREPORTE
(
  CODCOND    NUMBER(8)                          NOT NULL,
  CODRPT     NUMBER(8)                          NOT NULL,
  COLUMNA    VARCHAR2(50 BYTE)                  NOT NULL,
  CONDICION  VARCHAR2(15 BYTE),
  VALOR      VARCHAR2(100 BYTE),
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT USER                  NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL,
  TIPO       CHAR(1 BYTE)
);

COMMENT ON TABLE OPERACION.CONDXREPORTE IS 'No es usada';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.CODCOND IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.CODRPT IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.COLUMNA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.CONDICION IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.VALOR IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.CONDXREPORTE.TIPO IS 'No se utiliza';

