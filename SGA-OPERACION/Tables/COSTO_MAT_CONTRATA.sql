CREATE TABLE OPERACION.COSTO_MAT_CONTRATA
(
  CODMAT  CHAR(15 BYTE)                         NOT NULL,
  COSTO   NUMBER(10,3)                          NOT NULL,
  FECUSU  DATE                                  DEFAULT sysdate,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user
);

COMMENT ON TABLE OPERACION.COSTO_MAT_CONTRATA IS 'Costo de Materiales Contrata';

COMMENT ON COLUMN OPERACION.COSTO_MAT_CONTRATA.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.COSTO_MAT_CONTRATA.COSTO IS 'Costo del material';

COMMENT ON COLUMN OPERACION.COSTO_MAT_CONTRATA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.COSTO_MAT_CONTRATA.CODUSU IS 'Codigo de Usuario registro';

