CREATE TABLE OPERACION.OTMAIL
(
  CODOT   NUMBER(8)                             NOT NULL,
  ACCION  NUMBER(2)                             NOT NULL,
  EMAIL   VARCHAR2(200 BYTE)                    NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OTMAIL IS 'Mail enviado por orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTMAIL.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTMAIL.ACCION IS 'Accion para el envio';

COMMENT ON COLUMN OPERACION.OTMAIL.EMAIL IS 'Listado de correo';

COMMENT ON COLUMN OPERACION.OTMAIL.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTMAIL.FECUSU IS 'Fecha de registro';


