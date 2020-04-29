CREATE TABLE OPERACION.TIPTRAEF
(
  TIPTRAEF     NUMBER(4)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  GRUPODESC    VARCHAR2(100 BYTE)
);

COMMENT ON TABLE OPERACION.TIPTRAEF IS 'Tipo de trabajo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPTRAEF.TIPTRAEF IS 'Codigo del tipo de trabajo de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.TIPTRAEF.DESCRIPCION IS 'Descripcion del tipo de trabajo de ef';

COMMENT ON COLUMN OPERACION.TIPTRAEF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPTRAEF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPTRAEF.GRUPODESC IS 'Descripcion del grupo';


