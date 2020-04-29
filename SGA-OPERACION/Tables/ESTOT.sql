CREATE TABLE OPERACION.ESTOT
(
  ESTOT        NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL
);

COMMENT ON TABLE OPERACION.ESTOT IS 'Estado de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.ESTOT.ESTOT IS 'Codigo del estado de la ot (Pk)';

COMMENT ON COLUMN OPERACION.ESTOT.DESCRIPCION IS 'Descripcion del estado de la ot';

COMMENT ON COLUMN OPERACION.ESTOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTOT.ABREVI IS 'Abreviatura';


