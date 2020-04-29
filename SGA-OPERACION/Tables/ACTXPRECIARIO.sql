CREATE TABLE OPERACION.ACTXPRECIARIO
(
  CODPREC    NUMBER(10)                         NOT NULL,
  CODACT     NUMBER(5)                          NOT NULL,
  COSTO      NUMBER(10,2)                       DEFAULT 0                     NOT NULL,
  MONEDA_ID  NUMBER(2)                          NOT NULL,
  ACTIVO     CHAR(1 BYTE)                       DEFAULT '1'                   NOT NULL,
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT USER                  NOT NULL,
  FECREG     DATE                               DEFAULT SYSDATE               NOT NULL,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT USER                  NOT NULL,
  FECMOD     DATE                               DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXPRECIARIO IS 'Actividades por PRECIARIO';

COMMENT ON COLUMN OPERACION.ACTXPRECIARIO.CODPREC IS 'codigo de PRECIARIO';

COMMENT ON COLUMN OPERACION.ACTXPRECIARIO.CODACT IS 'codigo de actividad';

COMMENT ON COLUMN OPERACION.ACTXPRECIARIO.COSTO IS 'costo del PRECIARIO';

COMMENT ON COLUMN OPERACION.ACTXPRECIARIO.MONEDA_ID IS 'codigo de moneda del PRECIARIO';


