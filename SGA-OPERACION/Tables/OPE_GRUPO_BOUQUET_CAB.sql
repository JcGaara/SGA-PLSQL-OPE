CREATE TABLE OPERACION.OPE_GRUPO_BOUQUET_CAB
(
  IDGRUPO      NUMBER(5)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  FLG_ACTIVO   NUMBER(1)                        DEFAULT 1,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECREG       DATE                             DEFAULT SYSDATE,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECMOD       DATE                             DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_GRUPO_BOUQUET_CAB IS 'Sirve para registrar los grupos de bouquet de DTH usado para el refresco de la señal.';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.IDGRUPO IS 'Identificador del grupo de bouquet DTH';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.DESCRIPCION IS 'Nombre del grupo de bouquet DTH';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.FLG_ACTIVO IS 'Estado del grupo de bouquet DTH. 0: Inactivo, 1: Activo';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_GRUPO_BOUQUET_CAB.FECMOD IS 'Fecha que se modificó el registro';


