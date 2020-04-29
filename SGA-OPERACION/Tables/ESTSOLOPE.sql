CREATE TABLE OPERACION.ESTSOLOPE
(
  ESTSOLOPE    NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.ESTSOLOPE IS 'Estado de operaciones de la solicitud de ot';

COMMENT ON COLUMN OPERACION.ESTSOLOPE.ESTSOLOPE IS 'Estado de solicitud de operacion';

COMMENT ON COLUMN OPERACION.ESTSOLOPE.DESCRIPCION IS 'Descripcion del estado de la solicitud de ot';

COMMENT ON COLUMN OPERACION.ESTSOLOPE.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTSOLOPE.CODUSU IS 'Codigo de Usuario registro';


