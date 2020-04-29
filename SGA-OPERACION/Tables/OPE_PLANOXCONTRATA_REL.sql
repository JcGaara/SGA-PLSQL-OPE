CREATE TABLE OPERACION.OPE_PLANOXCONTRATA_REL
(
  CODCON     NUMBER(6)                          NOT NULL,
  IDPLANO    VARCHAR2(10 BYTE)                  NOT NULL,
  TIPTRA     NUMBER(4)                          NOT NULL,
  ESTADO     NUMBER(1),
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECREG     DATE                               DEFAULT sysdate,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECMOD     DATE                               DEFAULT sysdate,
  PRIORIDAD  NUMBER(1)                          DEFAULT 1
);

COMMENT ON TABLE OPERACION.OPE_PLANOXCONTRATA_REL IS 'Tabla para relacionar las contratas con planos';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.CODCON IS 'Identificador de contrata';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.IDPLANO IS 'Identificador de plano';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.TIPTRA IS 'Identificador de tipo de trabajo';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.ESTADO IS '1:Activo, 0:Inactivo';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.USUREG IS 'Usuario   que   insertó   el registro';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.USUMOD IS 'Usuario   que modificó   el registro';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.FECMOD IS 'Fecha   que se   modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_PLANOXCONTRATA_REL.PRIORIDAD IS 'Prioridad de la contrata para ubicaion y tipo de trabajo';


