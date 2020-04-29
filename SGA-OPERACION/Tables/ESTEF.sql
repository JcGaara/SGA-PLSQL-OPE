CREATE TABLE OPERACION.ESTEF
(
  ESTEF        NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ESTEF IS 'Estado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.ESTEF.ESTEF IS 'Codigo del estado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.ESTEF.DESCRIPCION IS 'Descripcion del estado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.ESTEF.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ESTEF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTEF.FECUSU IS 'Fecha de registro';


