CREATE TABLE OPERACION.ENVCORREO
(
  TIPO    NUMBER(2)                             NOT NULL,
  CODDPT  CHAR(6 BYTE)                          NOT NULL,
  EMAIL   VARCHAR2(200 BYTE)                    NOT NULL,
  AREA    NUMBER(4)
);

COMMENT ON TABLE OPERACION.ENVCORREO IS 'Listado de los envio de correos';

COMMENT ON COLUMN OPERACION.ENVCORREO.TIPO IS 'Tipo de envio de correo';

COMMENT ON COLUMN OPERACION.ENVCORREO.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.ENVCORREO.EMAIL IS 'Listado de correo';

COMMENT ON COLUMN OPERACION.ENVCORREO.AREA IS 'Codigo de area';


