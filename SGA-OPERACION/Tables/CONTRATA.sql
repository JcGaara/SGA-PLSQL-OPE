CREATE TABLE OPERACION.CONTRATA
(
  CODCON         NUMBER(6)                      NOT NULL,
  NOMBRE         VARCHAR2(100 BYTE)             NOT NULL,
  FECUSU         DATE                           DEFAULT SYSDATE               NOT NULL,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FLG_INS        NUMBER(1)                      DEFAULT 0                     NOT NULL,
  FLG_DIS        NUMBER(1)                      DEFAULT 0                     NOT NULL,
  CAL_INS        NUMBER(4)                      DEFAULT 0                     NOT NULL,
  CAL_DIS        NUMBER(4)                      DEFAULT 0                     NOT NULL,
  CONT_INS       NUMBER(4)                      DEFAULT 0                     NOT NULL,
  CONT_DIS       NUMBER(4)                      DEFAULT 0                     NOT NULL,
  PTR_DIS        NUMBER(1)                      DEFAULT 0                     NOT NULL,
  ESTADO         NUMBER(1)                      DEFAULT 0,
  EMAIL          VARCHAR2(400 BYTE),
  FLG_ASIGNA     NUMBER(1)                      DEFAULT 0                     NOT NULL,
  RANKING        NUMBER,
  CARGA_TRABAJO  NUMBER(3),
  FLG_CONAX      NUMBER(1)                      DEFAULT 0,
  ALMACEN        CHAR(4 BYTE),
  NOMBRE_SAP     VARCHAR2(300 BYTE),
  DESCRIPCION    VARCHAR2(300 BYTE)
);

COMMENT ON TABLE OPERACION.CONTRATA IS 'Listado de contratista';

COMMENT ON COLUMN OPERACION.CONTRATA.NOMBRE_SAP IS 'Nombre registrado en SAP';

COMMENT ON COLUMN OPERACION.CONTRATA.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.CONTRATA.NOMBRE IS 'NOMBRE';

COMMENT ON COLUMN OPERACION.CONTRATA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.CONTRATA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.CONTRATA.FLG_INS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.FLG_DIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.CAL_INS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.CAL_DIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.CONT_INS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.CONT_DIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.PTR_DIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CONTRATA.ALMACEN IS 'Codigo almacen de la Contrata, desde donde hace reservas';


