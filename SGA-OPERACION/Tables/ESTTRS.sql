CREATE TABLE OPERACION.ESTTRS
(
  ESTTRS       NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.ESTTRS.ESTTRS IS 'Estado de la transaccion';

COMMENT ON COLUMN OPERACION.ESTTRS.DESCRIPCION IS 'Descripcion del estado de la transaccion';

COMMENT ON COLUMN OPERACION.ESTTRS.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ESTTRS.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTTRS.FECUSU IS 'Fecha de registro';


