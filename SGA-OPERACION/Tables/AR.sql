CREATE TABLE OPERACION.AR
(
  CODEF        NUMBER(8)                        NOT NULL,
  DOCID        NUMBER(10)                       NOT NULL,
  ESTAR        NUMBER(2),
  RENTABLE     NUMBER(1),
  FECAPR       DATE,
  TIR          NUMBER(10,4),
  VAN          NUMBER(10,4),
  PAYBACK      VARCHAR2(20 BYTE),
  FRR          NUMBER(8,5),
  OBSERVACION  VARCHAR2(1000 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  COSTOASIG    NUMBER(10,2)
);

COMMENT ON TABLE OPERACION.AR IS 'Analisis de Rentabilidad';

COMMENT ON COLUMN OPERACION.AR.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.AR.DOCID IS 'id de documento';

COMMENT ON COLUMN OPERACION.AR.ESTAR IS 'Codigo estado de analisis de rentabilidad';

COMMENT ON COLUMN OPERACION.AR.RENTABLE IS 'Indica si el proyecto es rentable';

COMMENT ON COLUMN OPERACION.AR.FECAPR IS 'Fecha de aprobación';

COMMENT ON COLUMN OPERACION.AR.TIR IS 'Tasa de interna de retorno';

COMMENT ON COLUMN OPERACION.AR.VAN IS 'Valor actual neto';

COMMENT ON COLUMN OPERACION.AR.PAYBACK IS 'Payback';

COMMENT ON COLUMN OPERACION.AR.FRR IS 'Factor rapido de rentabilidad';

COMMENT ON COLUMN OPERACION.AR.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.AR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.AR.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.AR.COSTOASIG IS 'Costo asignado';


