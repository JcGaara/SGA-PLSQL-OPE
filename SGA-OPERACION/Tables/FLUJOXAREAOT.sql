CREATE TABLE OPERACION.FLUJOXAREAOT
(
  CODDPTORI  CHAR(6 BYTE)                       NOT NULL,
  CODDPTDES  CHAR(6 BYTE)                       NOT NULL,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT USER                  NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL,
  AREA_ORI   NUMBER(4)                          NOT NULL,
  AREA_DES   NUMBER(4)                          NOT NULL
);

COMMENT ON TABLE OPERACION.FLUJOXAREAOT IS 'Flujos por area de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.CODDPTORI IS 'Codigo del departamento origen';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.CODDPTDES IS 'Codigo del departamento destino';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.AREA_ORI IS 'Codigo de area origen';

COMMENT ON COLUMN OPERACION.FLUJOXAREAOT.AREA_DES IS 'Codigo de area destino';


