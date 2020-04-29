CREATE TABLE OPERACION.TIPMOTOT
(
  TIPMOTOT     NUMBER(3)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  ESTADO       NUMBER(1)                        DEFAULT 0                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.TIPMOTOT IS 'Tipos de motivo de la Orden de Trabajo';

COMMENT ON COLUMN OPERACION.TIPMOTOT.TIPMOTOT IS 'Codigo del tipo motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPMOTOT.DESCRIPCION IS 'Descripcion del tipo motivo de la ot';

COMMENT ON COLUMN OPERACION.TIPMOTOT.ESTADO IS 'Estado del tipo de motivo, 0 inactivo, 1 activo';

COMMENT ON COLUMN OPERACION.TIPMOTOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPMOTOT.CODUSU IS 'Codigo de Usuario registro';


