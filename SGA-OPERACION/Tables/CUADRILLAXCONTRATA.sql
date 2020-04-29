CREATE TABLE OPERACION.CUADRILLAXCONTRATA
(
  CODCON            NUMBER(6)                   NOT NULL,
  CODCUADRILLA      VARCHAR2(5 BYTE)            NOT NULL,
  NOMBRE_CUADRILLA  VARCHAR2(150 BYTE),
  RPC               NUMBER(10),
  ESTADO            NUMBER(1)                   DEFAULT 1                     NOT NULL,
  FECREG            DATE                        DEFAULT SYSDATE               NOT NULL,
  USUREG            VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  FECMOD            DATE                        DEFAULT SYSDATE               NOT NULL,
  USUMOD            VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.CUADRILLAXCONTRATA IS 'Tabla de configuración para cuadrillas por contrata';

COMMENT ON COLUMN OPERACION.CUADRILLAXCONTRATA.CODCON IS 'Codigo de la contrata';

COMMENT ON COLUMN OPERACION.CUADRILLAXCONTRATA.CODCUADRILLA IS 'Codigo de la cuadrilla';

COMMENT ON COLUMN OPERACION.CUADRILLAXCONTRATA.NOMBRE_CUADRILLA IS 'Nombre de la cuadrilla';

COMMENT ON COLUMN OPERACION.CUADRILLAXCONTRATA.RPC IS 'RPC de la cuadrilla';

COMMENT ON COLUMN OPERACION.CUADRILLAXCONTRATA.ESTADO IS 'Estado de la cuadrilla';


