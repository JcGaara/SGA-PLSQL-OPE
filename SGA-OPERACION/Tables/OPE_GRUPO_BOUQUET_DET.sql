CREATE TABLE OPERACION.OPE_GRUPO_BOUQUET_DET
(
  IDGRUPO     NUMBER(5)                         NOT NULL,
  CODBOUQUET  NUMBER(5)                         NOT NULL,
  FLG_ACTIVO  NUMBER(1)                         DEFAULT 1,
  USUREG      VARCHAR2(30 BYTE)                 DEFAULT USER,
  FECREG      DATE                              DEFAULT SYSDATE,
  USUMOD      VARCHAR2(30 BYTE)                 DEFAULT USER,
  FECMOD      DATE                              DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_GRUPO_BOUQUET_DET IS 'Sirve para registrar los bouquets de un grupo.';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.IDGRUPO IS 'Identificador del grupo de bouquet DTH';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.CODBOUQUET IS 'Código de Bouquet';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.FLG_ACTIVO IS 'Estado del grupo de bouquet DTH. 0: Inactivo, 1: Activo';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_DET.FECMOD IS 'Fecha que se modificó el registro';


