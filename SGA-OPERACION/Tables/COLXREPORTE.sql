CREATE TABLE OPERACION.COLXREPORTE
(
  CODCOL    NUMBER(8)                           NOT NULL,
  CODRPT    NUMBER(8)                           NOT NULL,
  COLUMNA   VARCHAR2(50 BYTE),
  POSICION  NUMBER(5)                           DEFAULT 1                     NOT NULL,
  ORDEN     VARCHAR2(4 BYTE),
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT USER                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  TIPO      VARCHAR2(20 BYTE),
  ANCHO     NUMBER(8)                           DEFAULT 100,
  SINTAXIS  LONG
);

COMMENT ON TABLE OPERACION.COLXREPORTE IS 'No es usada';

COMMENT ON COLUMN OPERACION.COLXREPORTE.CODCOL IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.CODRPT IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.COLUMNA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.POSICION IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.ORDEN IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.COLXREPORTE.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.COLXREPORTE.TIPO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.ANCHO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.COLXREPORTE.SINTAXIS IS 'No se utiliza';


