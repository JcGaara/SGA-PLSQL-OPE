CREATE TABLE OPERACION.PREUBIETAVAL
(
  CODPRE       NUMBER(8)                        NOT NULL,
  IDUBI        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  FECHA        DATE,
  NROFACT      VARCHAR2(15 BYTE),
  CODCON       NUMBER(10),
  ESTADO       CHAR(2 BYTE),
  MONTO        NUMBER(10,2)                     NOT NULL,
  TIPCAM       NUMBER(5,2),
  MONEDA       CHAR(1 BYTE),
  COSMO        NUMBER(10,2),
  COSMAT       NUMBER(10,2),
  TOTALFAC     NUMBER(10,2),
  FECREC       DATE,
  NROCARTA     VARCHAR2(15 BYTE),
  TIPO         NUMBER(1),
  FECVENCARTA  DATE,
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.PREUBIETAVAL IS 'No se usada';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.CODPRE IS 'Codigo del presupuesto';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.IDUBI IS 'Punto del presupuesto';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.FECHA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.NROFACT IS 'Numero de factura';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.ESTADO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.MONTO IS 'Monto';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.TIPCAM IS 'Tipo de cambio';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.MONEDA IS 'Codigo de moneda';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.TOTALFAC IS 'Total de factura';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.FECREC IS 'Fecha de recepción';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.NROCARTA IS 'Numero de carta';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.TIPO IS 'Tipo';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.FECVENCARTA IS 'Fecha de vencimiento de carta';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PREUBIETAVAL.FECUSU IS 'Fecha de registro';


