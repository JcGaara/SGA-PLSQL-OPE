CREATE TABLE OPERACION.TIPMETEF
(
  TIPMETEF     NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  DEFECTO      NUMBER(1)                        DEFAULT 1
);

COMMENT ON TABLE OPERACION.TIPMETEF IS 'Tipo de metrado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPMETEF.TIPMETEF IS 'Tipo de metrado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPMETEF.DESCRIPCION IS 'Descripcion del tipo de metrado';

COMMENT ON COLUMN OPERACION.TIPMETEF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPMETEF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPMETEF.DEFECTO IS 'Tipo de metrado';


