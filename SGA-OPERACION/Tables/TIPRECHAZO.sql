CREATE TABLE OPERACION.TIPRECHAZO
(
  TIPRECHAZO   NUMBER(5)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  FLG_OPE      NUMBER(1)                        DEFAULT 0                     NOT NULL,
  FLG_FNZ      NUMBER(1)                        DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.TIPRECHAZO IS 'Tipo de rechazo de cada punto de ef';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.TIPRECHAZO IS 'Tipo de rechazo';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.DESCRIPCION IS 'Descripcion del tipo de rechazo';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.FLG_OPE IS 'Indica si el tipo de rechazo es de operacion';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.FLG_FNZ IS 'Indica si el tipo de rechazo es financiero';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPRECHAZO.FECUSU IS 'Fecha de registro';


