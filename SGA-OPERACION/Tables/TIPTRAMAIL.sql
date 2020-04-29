CREATE TABLE OPERACION.TIPTRAMAIL
(
  ID      NUMBER(8)                             NOT NULL,
  ACCION  NUMBER(2)                             NOT NULL,
  TIPTRA  NUMBER(4)                             NOT NULL,
  EMAIL   VARCHAR2(200 BYTE)                    NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL,
  AREA    NUMBER(4)                             NOT NULL
);

COMMENT ON TABLE OPERACION.TIPTRAMAIL IS 'Mail asociado a tipo de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.ID IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.ACCION IS 'Accion para el envio';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.EMAIL IS 'Listado de correo';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPTRAMAIL.AREA IS 'Codigo de area';


