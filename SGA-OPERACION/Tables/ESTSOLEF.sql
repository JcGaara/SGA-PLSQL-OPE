CREATE TABLE OPERACION.ESTSOLEF
(
  ESTSOLEF     NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL
);

COMMENT ON TABLE OPERACION.ESTSOLEF IS 'Estado de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.ESTSOLEF.ESTSOLEF IS 'Estado de la solicitud de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.ESTSOLEF.DESCRIPCION IS 'Descripcion del estado de solicitud del ef';

COMMENT ON COLUMN OPERACION.ESTSOLEF.ABREVI IS 'Abreviatura';


