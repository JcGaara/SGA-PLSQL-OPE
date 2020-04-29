CREATE TABLE OPERACION.EFHISMOD
(
  SEQ          NUMBER(10)                       NOT NULL,
  CODEF        NUMBER(8)                        NOT NULL,
  OBSERVACION  VARCHAR2(2000 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  IDMOTIVO     NUMBER(2)
);

COMMENT ON TABLE OPERACION.EFHISMOD IS 'Historico de las modificaciones del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFHISMOD.SEQ IS 'Id de la tabla';

COMMENT ON COLUMN OPERACION.EFHISMOD.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFHISMOD.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.EFHISMOD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFHISMOD.CODUSU IS 'Codigo de Usuario registro';


