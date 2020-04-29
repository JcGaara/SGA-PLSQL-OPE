CREATE TABLE OPERACION.ACTXCOSTO
(
  CODACT     NUMBER(5)                          NOT NULL,
  ORDEN      NUMBER(4)                          NOT NULL,
  COSTO      NUMBER(10,2)                       DEFAULT 0                     NOT NULL,
  MONEDA_ID  NUMBER(10),
  FECANO     NUMBER(4)                          NOT NULL,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXCOSTO IS 'No es usada';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.MONEDA_ID IS 'Codigo moneda';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.FECANO IS 'Fecha anual';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTXCOSTO.FECUSU IS 'Fecha de registro';


