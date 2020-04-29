CREATE TABLE OPERACION.TIPINFEF
(
  TIPINFEF     NUMBER(5)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.TIPINFEF IS 'Tipo de informe del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPINFEF.TIPINFEF IS 'Tipo de informe del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPINFEF.DESCRIPCION IS 'Descripcion del tipo de informe del ef';

COMMENT ON COLUMN OPERACION.TIPINFEF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPINFEF.FECUSU IS 'Fecha de registro';


