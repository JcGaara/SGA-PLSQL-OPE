CREATE TABLE OPERACION.ESTEQU
(
  ESTEQU       NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  TIPEQU       NUMBER(6)
);

COMMENT ON TABLE OPERACION.ESTEQU IS 'Estado de los equipos';

COMMENT ON COLUMN OPERACION.ESTEQU.ESTEQU IS 'Codigo del estado de equipo';

COMMENT ON COLUMN OPERACION.ESTEQU.DESCRIPCION IS 'Descripcion del estado de equipo';

COMMENT ON COLUMN OPERACION.ESTEQU.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ESTEQU.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTEQU.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTEQU.TIPEQU IS 'Codigo de tipo de equipo (Pk)';


