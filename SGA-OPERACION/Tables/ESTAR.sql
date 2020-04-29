CREATE TABLE OPERACION.ESTAR
(
  ESTAR        NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       VARCHAR2(10 BYTE)                NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ESTAR IS 'Estado del analisis de rentabilidad';

COMMENT ON COLUMN OPERACION.ESTAR.ESTAR IS 'Codigo del estado de analisis de rentabilidad (Pk)';

COMMENT ON COLUMN OPERACION.ESTAR.DESCRIPCION IS 'Descripcion del estado de analisis de rentabilidad';

COMMENT ON COLUMN OPERACION.ESTAR.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ESTAR.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTAR.FECUSU IS 'Fecha de registro';


