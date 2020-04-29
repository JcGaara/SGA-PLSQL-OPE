CREATE TABLE OPERACION.TIPINFOT
(
  TIPINFOT     NUMBER(5)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  GRUPO        CHAR(2 BYTE),
  GRUPODESC    VARCHAR2(50 BYTE),
  ESTADO       NUMBER(1)                        DEFAULT 1                     NOT NULL
);

COMMENT ON TABLE OPERACION.TIPINFOT IS 'Tipo de informe de la ot';

COMMENT ON COLUMN OPERACION.TIPINFOT.TIPINFOT IS 'Tipo de informe de orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPINFOT.DESCRIPCION IS 'Descripcion del tipo de informe de ot';

COMMENT ON COLUMN OPERACION.TIPINFOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPINFOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPINFOT.GRUPO IS 'Grupo';

COMMENT ON COLUMN OPERACION.TIPINFOT.GRUPODESC IS 'Descripcion del grupo';

COMMENT ON COLUMN OPERACION.TIPINFOT.ESTADO IS 'Estado del tipo de informe';


