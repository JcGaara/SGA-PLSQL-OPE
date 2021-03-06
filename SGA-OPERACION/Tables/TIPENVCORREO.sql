CREATE TABLE OPERACION.TIPENVCORREO
(
  TIPENVCORREO  NUMBER(2)                       NOT NULL,
  DESCRIPCION   VARCHAR2(200 BYTE)              NOT NULL,
  FECUSU        DATE                            DEFAULT SYSDATE               NOT NULL,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.TIPENVCORREO IS 'Tipo de envio de correos';

COMMENT ON COLUMN OPERACION.TIPENVCORREO.TIPENVCORREO IS 'Tipo de envio de correo';

COMMENT ON COLUMN OPERACION.TIPENVCORREO.DESCRIPCION IS 'Descripcion del tipo de envio de correo';

COMMENT ON COLUMN OPERACION.TIPENVCORREO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPENVCORREO.CODUSU IS 'Codigo de Usuario registro';


