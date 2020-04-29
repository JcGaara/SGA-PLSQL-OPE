CREATE TABLE OPERACION.OPE_ESTADO_RECARGA
(
  CODESTREC     CHAR(2 BYTE)                    NOT NULL,
  DESCRIPCION   VARCHAR2(50 BYTE),
  FLG_ACTIVO    NUMBER(1)                       DEFAULT 1,
  USUREG        VARCHAR2(30 BYTE)               DEFAULT USER,
  FECREG        DATE                            DEFAULT SYSDATE,
  USUMOD        VARCHAR2(30 BYTE)               DEFAULT USER,
  FECMOD        DATE                            DEFAULT SYSDATE,
  COD_ESTADO_1  VARCHAR2(10 BYTE)
);

COMMENT ON TABLE OPERACION.OPE_ESTADO_RECARGA IS 'Maestro de estados de recarga';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.CODESTREC IS 'Identificador de la tabla';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.DESCRIPCION IS 'Descripcion del estado';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.FLG_ACTIVO IS 'Flag que indica si esta activo el estado';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.USUREG IS 'Usuario   que   insert�   el registro';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.USUMOD IS 'Usuario   que modific�   el registro';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.FECMOD IS 'Fecha   que se   modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_ESTADO_RECARGA.COD_ESTADO_1 IS 'Codigo de estados equivalentes en OCS';

