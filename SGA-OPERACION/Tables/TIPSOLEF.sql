CREATE TABLE OPERACION.TIPSOLEF
(
  TIPSOLEF     NUMBER(4)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.TIPSOLEF IS 'Tipo de trabajo del proyecto';

COMMENT ON COLUMN OPERACION.TIPSOLEF.TIPSOLEF IS 'Tipo de solicitud de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPSOLEF.DESCRIPCION IS 'Descripcion del tipo de solicitud del ef';

COMMENT ON COLUMN OPERACION.TIPSOLEF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPSOLEF.CODUSU IS 'Codigo de Usuario registro';


