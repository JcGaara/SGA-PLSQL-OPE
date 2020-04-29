CREATE TABLE OPERACION.TIPOTPTO
(
  TIPOTPTO     NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.TIPOTPTO IS 'Tipo de cada detalle de la orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPOTPTO.TIPOTPTO IS 'Tipo de punto';

COMMENT ON COLUMN OPERACION.TIPOTPTO.DESCRIPCION IS 'Descripcion del punto de ot';

COMMENT ON COLUMN OPERACION.TIPOTPTO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPOTPTO.CODUSU IS 'Codigo de Usuario registro';


