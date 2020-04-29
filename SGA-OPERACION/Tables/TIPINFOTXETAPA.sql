CREATE TABLE OPERACION.TIPINFOTXETAPA
(
  CODETA    NUMBER(5)                           NOT NULL,
  TIPINFOT  NUMBER(5)                           NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.TIPINFOTXETAPA IS 'Tipos de informe de la ot asociada las etapas';

COMMENT ON COLUMN OPERACION.TIPINFOTXETAPA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.TIPINFOTXETAPA.TIPINFOT IS 'Tipo de informe de orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPINFOTXETAPA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPINFOTXETAPA.FECUSU IS 'Fecha de registro';


