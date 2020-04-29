CREATE TABLE OPERACION.SOLOTPTO_ID_CONTRATA
(
  CODSOLOT      NUMBER(8)                       NOT NULL,
  PUNTO         NUMBER(10)                      NOT NULL,
  ORDEN         NUMBER(8)                       NOT NULL,
  CODCON        NUMBER(6),
  CONTACTO      VARCHAR2(150 BYTE),
  TELCON        VARCHAR2(50 BYTE),
  CODTIPHALLAZ  NUMBER(10),
  OBSERVACION   VARCHAR2(200 BYTE),
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT USER,
  FECUSU        DATE                            DEFAULT SYSDATE,
  CODUSUMOD     VARCHAR2(30 BYTE)               DEFAULT USER,
  FECUSUMOD     DATE                            DEFAULT SYSDATE
);

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.CODSOLOT IS 'codigo de la solot';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.PUNTO IS 'punto de la solot';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.ORDEN IS 'id de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.CONTACTO IS 'nombre del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.TELCON IS 'telefono del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID_CONTRATA.CODTIPHALLAZ IS 'codigo del tipo de hallazgo';

