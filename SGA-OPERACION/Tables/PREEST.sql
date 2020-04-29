CREATE TABLE OPERACION.PREEST
(
  CODPRE  NUMBER(8)                             NOT NULL,
  IDUBI   NUMBER(10)                            NOT NULL,
  ITEM    NUMBER(8)                             NOT NULL,
  ESTADO  NUMBER(2)                             NOT NULL,
  CODFAS  NUMBER(2)                             NOT NULL,
  FECCAM  DATE                                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT USER                  NOT NULL
);

COMMENT ON TABLE OPERACION.PREEST IS 'No usada - Estado del presupuesto ';

COMMENT ON COLUMN OPERACION.PREEST.CODPRE IS 'Codigo del presupuesto';

COMMENT ON COLUMN OPERACION.PREEST.IDUBI IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREEST.ITEM IS 'Item';

COMMENT ON COLUMN OPERACION.PREEST.ESTADO IS 'Estado del presupuesto';

COMMENT ON COLUMN OPERACION.PREEST.CODFAS IS 'Codigo de la fase ';

COMMENT ON COLUMN OPERACION.PREEST.FECCAM IS 'Fecha de cambio';

COMMENT ON COLUMN OPERACION.PREEST.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.PREEST.CODUSU IS 'Codigo de Usuario registro';


