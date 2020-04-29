CREATE TABLE OPERACION.ESTOTPTO
(
  ESTOTPTO     NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  ABREVI       CHAR(4 BYTE)
);

COMMENT ON TABLE OPERACION.ESTOTPTO IS 'Estado de cada detalle de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.ESTOTPTO.ESTOTPTO IS 'Estado del punto de la ot';

COMMENT ON COLUMN OPERACION.ESTOTPTO.DESCRIPCION IS 'Descripcion del estado del punto de ot';

COMMENT ON COLUMN OPERACION.ESTOTPTO.ABREVI IS 'Abreviatura';


