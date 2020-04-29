CREATE TABLE OPERACION.OTINFORME
(
  CODOT        NUMBER(8)                        NOT NULL,
  ORDEN        NUMBER(3)                        NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OTINFORME IS 'Informe de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTINFORME.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTINFORME.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.OTINFORME.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.OTINFORME.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTINFORME.FECUSU IS 'Fecha de registro';


