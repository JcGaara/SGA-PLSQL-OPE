CREATE TABLE OPERACION.ESTPREUBIETA
(
  ESTETA       NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       VARCHAR2(20 BYTE)
);

COMMENT ON TABLE OPERACION.ESTPREUBIETA IS 'Estado de cada etapa del detalle del presupuesto (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.ESTPREUBIETA.ESTETA IS 'Codigo del estado de la etapa';

COMMENT ON COLUMN OPERACION.ESTPREUBIETA.DESCRIPCION IS 'Descripcion de estado de la etapa del presupuesto';

COMMENT ON COLUMN OPERACION.ESTPREUBIETA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTPREUBIETA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTPREUBIETA.ABREVI IS 'Abreviatura';


